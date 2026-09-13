//
//  ReceiptRepository.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/15/26.
//

import FactoryKit
import Networking
import Toast
import UIKit

@Observable
final class ReceiptRepository {
    enum State {
        case loading
        case loaded
        case failed
    }

    private let googleDriveService = Container.shared.googleDriveService()
    private let googleSheetsService = Container.shared.googleSheetsService()
    private let receiptSpreadsheetService = Container.shared.receiptSpreadsheetService()
    
    // TODO: - Sort by submission date instead?
    var sortedReceipts: [Receipt] {
        receipts.sorted { $0.transactionDate > $1.transactionDate }
    }
    
    var isLoading: Bool {
        state == .loading
    }
    
    var hasError: Bool {
        state == .failed
    }
    
    private(set) var failedRows = [ReceiptSpreadsheetDecoder.Response.FailedRow]()
    private var receipts = [Receipt]()
    private var state = State.loading
    
    /// Loads receipts by fetching all receipt rows, excluding headers, and updates the repository state.
    func loadReceipts() async {
        state = .loading
        await fetchAll()
    }
    
    /// Refreshes receipts by fetching all receipt rows, excluding headers, and updates the repository state.
    func refreshReceipts() async {
        await fetchAll()
    }
    
    /// Uploads the receipt image, appends the receipt to the spreadsheet, and updates the local receipt list.
    func add(
        _ receipt: Receipt,
        uiImage: UIImage
    ) async -> [Receipt]? {
        do {
            guard let imageID = await uploadReceiptImage(fileName: receipt.fileName, uiImage: uiImage) else { return nil }
            var receipt = receipt
            receipt.fileID = imageID
            return try await withSpreadsheetRecovery { spreadsheetID in
                try await self.appendRow(receipt, spreadsheetID: spreadsheetID)
            }
        } catch let error as AppendSpreadsheetRowsEndpoint.EndpointError {
            handleAppendSpreadsheetRowsError(error)
        } catch {
            handleUnknownError()
        }
        return nil
    }
    
    /// Updates an existing receipt in the spreadsheet and local receipt list.
    /// Appends the receipt to new spreadsheet and local receipt list after recovery.
    func update(_ receipt: Receipt) async -> [Receipt]? {
        guard let originalReceipt = receipts.first(where: { $0.id == receipt.id }) else {
            handleUnknownError()
            return nil
        }
        replaceReceipt(receipt)
        do {
            return try await withSpreadsheetRecovery { spreadsheetID in
                guard let row = try await self.findRow(
                    for: receipt.id,
                    spreadsheetID: spreadsheetID
                ), try await self.googleSheetsService.updateRows(
                    spreadsheetID: spreadsheetID,
                    range: ReceiptSpreadsheetSchema.rowRange(for: row),
                    values: [try ReceiptSpreadsheetEncoder.encode(receipt)]
                ) != nil else {
                    self.replaceReceipt(originalReceipt)
                    return nil
                }
                return self.receipts
            } onNewSpreadsheet: { spreadsheetID in
                try await self.appendRow(receipt, spreadsheetID: spreadsheetID)
            }
        } catch let error as FetchSpreadsheetRowsEndpoint.EndpointError {
            handleFetchSpreadsheetRowsError(error)
        } catch let error as UpdateSpreadsheetRowsEndpoint.EndpointError {
            handleUpdateSpreadsheetRowsError(error)
        } catch {
            handleUnknownError()
        }
        replaceReceipt(originalReceipt)
        return nil
    }
    
    /// Toggles the receipt's reimbursement status and updates it in the spreadsheet and local receipt list.
    func toggleReimbursementStatus(for receipt: Receipt) async -> [Receipt]? {
        var receipt = receipt
        receipt.isReimbursed.toggle()
        return await update(receipt)
    }
    
    /// Trashes the receipt image from Drive, deletes its associated data from Sheets, and updates the local receipt list.
    func delete(_ receipt: Receipt) async -> [Receipt]? {
        receipts.removeAll { $0.id == receipt.id }
        do {
            guard let receipts = try await deleteReceiptData(receipt) else {
                receipts.append(receipt)
                return nil
            }
            return receipts
        } catch let error as FetchSpreadsheetRowsEndpoint.EndpointError {
            handleFetchSpreadsheetRowsError(error)
        } catch let error as FetchSpreadsheetEndpoint.EndpointError {
            handleFetchSpreadsheetError(error)
        } catch let error as BatchUpdateSpreadsheetEndpoint.EndpointError {
            handleBatchUpdateSpreadsheetError(error)
        } catch {
            handleUnknownError()
        }
        receipts.append(receipt)
        return nil
    }
    
    /// Clears all the stored receipt data.
    func clear() {
        receipts = []
        state = .loaded
    }
}

// MARK: - Private Methods

private extension ReceiptRepository {
    /// Runs a Sheets operation with spreadsheet recovery and clears stored receipts when a new spreadsheet is created.
    func withSpreadsheetRecovery<T>(
        _ operation: @escaping (String) async throws -> T,
        onNewSpreadsheet: ((String) async throws -> T)? = nil
    ) async throws -> T {
        let onNewSpreadsheet = onNewSpreadsheet ?? operation
        return try await receiptSpreadsheetService.withSpreadsheetRecovery(
            operation,
            onNewSpreadsheet: { [weak self] spreadsheetID in
                self?.clear()
                return try await onNewSpreadsheet(spreadsheetID)
            }
        )
    }
    
    /// Fetches all receipt rows, excluding headers, and updates the repository state with the result.
    func fetchAll() async {
        do {
            guard let values = try await withSpreadsheetRecovery({ spreadsheetID in
                try await self.googleSheetsService.fetchRows(
                    spreadsheetID: spreadsheetID,
                    range: AppConstants.worksheetName + "!A2:Z"
                )
            }, onNewSpreadsheet: { _ in return nil }) else { return }
            let response = ReceiptSpreadsheetDecoder.decode(values)
            failedRows = response.failedRows
            receipts = response.receipts
            state = .loaded
        } catch {
            // Only set state to failed if we're loading since that means we aren't recoverable
            guard state == .loading else { return }
            state = .failed
        }
    }
    
    /// Uploads the given UIImage to Drive and returns the ID of the image if successful, nil if failed.
    func uploadReceiptImage(fileName: String, uiImage: UIImage) async -> String? {
        guard let data = uiImage.jpegData(compressionQuality: 0.8) else {
            ToastManager.shared.show(DefaultToastType.receiptImageUploadFailed)
            return nil
        }
        do {
            guard let response = try await googleDriveService.uploadFile(
                name: fileName,
                mimeType: "image/jpeg",
                data: data
            ) else { return nil }
            return response.id
        }  catch {
            handleUploadFileBodyError(error)
            return nil
        }
    }
    
    /// Appends a receipt row to the spreadsheet and local receipt list.
    func appendRow(
        _ receipt: Receipt,
        spreadsheetID: String
    ) async throws -> [Receipt]? {
        guard try await self.googleSheetsService.appendRows(
            spreadsheetID: spreadsheetID,
            range: AppConstants.worksheetName,
            values: [try ReceiptSpreadsheetEncoder.encode(receipt)]
        ) != nil else { return nil }
        receipts.append(receipt)
        return receipts
    }
    
    /// Locally replaces the existing receipt with the updated receipt.
    func replaceReceipt(_ receipt: Receipt) {
        if let index = receipts.firstIndex(where: { $0.id == receipt.id }) {
            receipts[index] = receipt
        }
    }
    
    /// Returns the spreadsheet row containing the specified receipt, if found.
    /// Ignores the first row since it's the header.
    /// Returns nil for all errors except for endpoint specific errors just like `APIManager`.
    func findRow(
        for receiptID: Receipt.ID,
        spreadsheetID: String
    ) async throws(FetchSpreadsheetRowsEndpoint.EndpointError) -> Int? {
        do {
            let values = try await googleSheetsService.fetchRows(
                spreadsheetID: spreadsheetID,
                range: AppConstants.worksheetName
            )
            return values.firstIndex { row in
                row.first == receiptID.uuidString
            }.map { $0 + 1 }
        } catch let APIManagerError.endpoint(error) {
            guard let error = error as? FetchSpreadsheetRowsEndpoint.EndpointError else { return nil }
            throw error
        } catch {
            return nil
        }
    }
        
    /// Deletes the receipt data from Sheets and trashes its associated image in Drive, propagating errors to the caller.
    /// Returns the current receipts when the operation completes without error, including when spreadsheet recovery
    /// creates a new spreadsheet.
    /// Returns nil when the receipt data cannot be deleted from Sheets.
    func deleteReceiptData(
        _ receipt: Receipt
    ) async throws -> [Receipt]? {
        try await withSpreadsheetRecovery { spreadsheetID in
            guard let row = try await self.findRow(
                for: receipt.id,
                spreadsheetID: spreadsheetID
            ), try await self.googleSheetsService.deleteRows(
                spreadsheetID: spreadsheetID,
                startIndex: row - 1,
                endIndex: row
            ) != nil else { return nil }
            guard let fileID = receipt.fileID,
                  let trashedFile = try? await self.googleDriveService.trashFile(id: fileID) else {
                self.showReceiptDeletedToast(receipt, spreadsheetID: spreadsheetID)
                return self.receipts
            }
            self.showReceiptDeletedToast(receipt, fileID: trashedFile.id, spreadsheetID: spreadsheetID)
            return self.receipts
        } onNewSpreadsheet: { _ in self.receipts }
    }
    
    /// Shows a toast confirming the receipt deletion and providing an Undo action to restore it.
    func showReceiptDeletedToast(
        _ receipt: Receipt,
        fileID: String? = nil,
        spreadsheetID: String
    ) {
        ToastManager.shared.show(
            DefaultToastType.receiptDeleted(
                undo: {
                    self.restoreDeletedReceipt(
                        receipt,
                        fileID: fileID,
                        spreadsheetID: spreadsheetID
                    )
                }
            )
        )
    }
    
    /// Restores a deleted receipt by re-adding its data to Sheets and untrashing its associated image in Drive if `fileID` is provided.
    func restoreDeletedReceipt(
        _ receipt: Receipt,
        fileID: String? = nil,
        spreadsheetID: String
    ) {
        Task {
            do {
                guard try await self.appendRow(
                    receipt,
                    spreadsheetID: spreadsheetID
                ) != nil else { return }
                guard let fileID else { return }
                _ = try? await self.googleDriveService.untrashFile(id: fileID)
            } catch let error as AppendSpreadsheetRowsEndpoint.EndpointError {
                handleAppendSpreadsheetRowsError(error)
            } catch {
                handleUnknownError()
            }
        }
    }
}

// MARK: - Private Error Handlers

private extension ReceiptRepository {
    func handleFetchSpreadsheetRowsError(_ error: FetchSpreadsheetRowsEndpoint.EndpointError) {
        switch error {
        case .spreadsheetNotFound:
            ToastManager.shared.show(DefaultToastType.spreadsheetNotFound)
        }
    }
    
    func handleAppendSpreadsheetRowsError(_ error: AppendSpreadsheetRowsEndpoint.EndpointError) {
        switch error {
        case .spreadsheetNotFound:
            ToastManager.shared.show(DefaultToastType.spreadsheetNotFound)
        }
    }
    
    func handleUpdateSpreadsheetRowsError(_ error: UpdateSpreadsheetRowsEndpoint.EndpointError) {
        switch error {
        case .spreadsheetNotFound:
            ToastManager.shared.show(DefaultToastType.spreadsheetNotFound)
        }
    }
    
    func handleUploadFileBodyError(_ error: UploadFileEndpoint.BodyError) {
        switch error {
        case .encodingFailed:
            ToastManager.shared.show(DefaultToastType.fileEncodingFailed)
        }
    }
    
    func handleFetchSpreadsheetError(_ error: FetchSpreadsheetEndpoint.EndpointError) {
        switch error {
        case .spreadsheetNotFound:
            ToastManager.shared.show(DefaultToastType.spreadsheetNotFound)
        }
    }
    
    func handleBatchUpdateSpreadsheetError(_ error: BatchUpdateSpreadsheetEndpoint.EndpointError) {
        switch error {
        case .spreadsheetNotFound:
            ToastManager.shared.show(DefaultToastType.spreadsheetNotFound)
        }
    }
    
    func handleUnknownError() {
        ToastManager.shared.show(DefaultToastType.unexpectedError)
    }
}
