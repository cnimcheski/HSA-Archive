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
import ZIPFoundation

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
    private let userDefaultsManager = Container.shared.userDefaultsManager()
    
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
    
    /// Exports all saved receipts as a compressed ZIP archive.
    func exportReceipts() async -> URL? {
        let fileManager = FileManager.default
        let exportDirectory = fileManager.temporaryDirectory.appending(path: UUID().uuidString)
        let receiptsDirectory = exportDirectory.appending(path: "Receipts")
        let archiveURL = fileManager.temporaryDirectory.appending(path: "HSA Archive.zip")
        defer { try? fileManager.removeItem(at: exportDirectory) }
        do {
            try fileManager.createDirectory(at: receiptsDirectory, withIntermediateDirectories: true)
            guard let csvRows = await exportReceiptFiles(to: receiptsDirectory) else { return nil }
            try writeCSV(rows: csvRows, to: exportDirectory)
            try? fileManager.removeItem(at: archiveURL)
            try fileManager.zipItem(
                at: exportDirectory,
                to: archiveURL,
                shouldKeepParent: false,
                compressionMethod: .deflate
            )
            return archiveURL
        } catch {
            return nil
        }
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
            return try await receiptSpreadsheetService.withFolderRecovery(.receipts) { folderID in
                guard let response = try await self.googleDriveService.uploadFile(
                    name: fileName,
                    mimeType: "image/jpeg",
                    parents: [folderID],
                    data: data
                ) else { return nil }
                return response.id
            }
        } catch let error as UploadFileEndpoint.EndpointError {
            handleUploadFileError(error)
        } catch let error as UploadFileEndpoint.BodyError {
            handleUploadFileBodyError(error)
        } catch {
            handleUnknownError()
        }
        return nil
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
            async let deletedReceiptRow = self.deleteReceiptRow(receipt, spreadsheetID: spreadsheetID)
            async let trashedReceiptFile = self.trashReceiptFile(receipt)
            let (deletedRow, trashedFile) = try await (deletedReceiptRow, trashedReceiptFile)
            guard deletedRow != nil else { return nil }
            guard let trashedFile else {
                self.showReceiptDeletedToast(receipt, spreadsheetID: spreadsheetID)
                return self.receipts
            }
            self.showReceiptDeletedToast(receipt, fileID: trashedFile.id, spreadsheetID: spreadsheetID)
            return self.receipts
        } onNewSpreadsheet: { _ in self.receipts }
    }
    
    /// Deletes the spreadsheet row for the given receipt.
    /// Returns the deleted spreadsheet row, if found.
    func deleteReceiptRow(_ receipt: Receipt, spreadsheetID: String) async throws -> Int? {
        guard let row = try await findRow(
            for: receipt.id,
            spreadsheetID: spreadsheetID
        ), try await googleSheetsService.deleteRows(
            spreadsheetID: spreadsheetID,
            startIndex: row - 1,
            endIndex: row
        ) != nil else { return nil }
        return row
    }
    
    /// Trashes the given receipt's image in Drive.
    func trashReceiptFile(_ receipt: Receipt) async -> UpdateFileEndpoint.Response? {
        guard let fileID = receipt.fileID else { return nil }
        return try? await googleDriveService.trashFile(id: fileID)
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
    
    /// Exports all local receipt images and returns their corresponding csv rows.
    func exportReceiptFiles(to directory: URL) async -> [[String]]? {
        await withTaskGroup { group in
            for receipt in receipts {
                group.addTask {
                    await self.exportReceiptFile(receipt, to: directory)
                }
            }
            var rows = [[String]]()
            for await csvRow in group {
                guard let csvRow else { return nil }
                rows.append(csvRow)
            }
            return [ReceiptSpreadsheetSchema.headers] + rows
        }
    }
    
    /// Exports a receipt's image file and returns its corresponding csv row.
    func exportReceiptFile(_ receipt: Receipt, to directory: URL) async -> [String]? {
        var receiptPath = ""
        var values: [String] { ReceiptSpreadsheetEncoder.values(for: receipt) + [receiptPath] }
        do {
            guard let fileID = receipt.fileID else { return values }
            guard let data = try await googleDriveService.downloadFile(id: fileID) else { return nil }
            let fileName = receipt.fileName.appending(".jpg")
            let fileURL = directory.appending(path: fileName)
            try data.write(to: fileURL)
            receiptPath = "Receipts/\(fileName)"
            return values
        } catch {
            return values
        }
    }
    
    /// Writes the provided receipt rows as a CSV file to the specified directory.
    func writeCSV(rows: [[String]], to directory: URL) throws {
        let csv = rows
            .map { $0.map(csvEscaped).joined(separator: ",") }
            .joined(separator: "\n")
        let url = directory.appending(path: "Receipts.csv")
        try Data(csv.utf8).write(to: url)
    }
    
    /// Escapes a CSV field by wrapping it in quotes and escaping embedded quotes when necessary.
    func csvEscaped(_ value: String) -> String {
        guard value.contains(where: { ",\"\n\r".contains($0) }) else { return value }
        return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
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
    
    func handleUploadFileError(_ error: UploadFileEndpoint.EndpointError) {
        switch error {
        case .parentFolderNotFound:
            ToastManager.shared.show(DefaultToastType.uploadFileFailed)
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
