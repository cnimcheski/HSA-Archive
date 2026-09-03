//
//  ReceiptRepository.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/15/26.
//

import FactoryKit
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
    ) async -> AppendSpreadsheetRowsEndpoint.Response? {
        do {
            guard let imageID = await uploadReceiptImage(fileName: receipt.fileName, uiImage: uiImage) else { return nil }
            guard let response = try await receiptSpreadsheetService.withSpreadsheetRecovery({ spreadsheetID in
                try await googleSheetsService.appendRows(
                    spreadsheetID: spreadsheetID,
                    range: AppConstants.worksheetName,
                    values: [ReceiptSpreadsheetEncoder.encode(receipt, imageID: imageID)]
                )
            }) else { return nil }
            receipts.append(receipt)
            return response
        } catch let error as AppendSpreadsheetRowsEndpoint.EndpointError {
            handleAppendSpreadsheetRowsError(error)
        } catch {
            handleUnknownError()
        }
        return nil
    }
    
    func update(_ receipt: Receipt) async throws {
        // TODO: - Implement this
    }
    
    func delete(_ receipt: Receipt) async throws {
        // TODO: - Implement this
    }
    
    /// Clears all the stored receipt data.
    func clear() {
        receipts = []
        state = .loaded
    }
}

// MARK: - Private Methods

private extension ReceiptRepository {
    /// Fetches all receipt rows, excluding headers, and updates the repository state with the result.
    func fetchAll() async {
        do {
            let values = try await receiptSpreadsheetService.withSpreadsheetRecovery { spreadsheetID in
                try await googleSheetsService.fetchRows(
                    spreadsheetID: spreadsheetID,
                    range: AppConstants.worksheetName + "!A2:Z"
                )
            }
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
}

// MARK: - Private Error Handlers

private extension ReceiptRepository {
    func handleFetchSpreadsheetRowsError(_ error: FetchSpreadsheetRowsEndpoint.EndpointError) {
        switch error {
        case .spreadsheetNotFound:
            ToastManager.shared.show(DefaultToastType.receiptsFetchFailed)
        }
    }
    
    func handleAppendSpreadsheetRowsError(_ error: AppendSpreadsheetRowsEndpoint.EndpointError) {
        switch error {
        case .spreadsheetNotFound:
            ToastManager.shared.show(DefaultToastType.receiptSaveFailed)
        }
    }
    
    func handleUploadFileBodyError(_ error: UploadFileEndpoint.BodyError) {
        switch error {
        case .encodingFailed:
            ToastManager.shared.show(DefaultToastType.fileEncodingFailed)
        }
    }
    
    func handleUnknownError() {
        ToastManager.shared.show(DefaultToastType.unexpectedError)
    }
}
