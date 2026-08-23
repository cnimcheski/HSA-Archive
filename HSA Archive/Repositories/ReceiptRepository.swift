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
    private let googleDriveService = Container.shared.googleDriveService()
    private let googleSheetsService = Container.shared.googleSheetsService()
    private let receiptSpreadsheetService = Container.shared.receiptSpreadsheetService()
    
    private(set) var receipts = [Receipt]()
    
    func fetchAll() async throws -> [Receipt] {
        // TODO: - Implement this
        return [] // TODO: - Placeholder for now...
    }
    
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
                    values: [ReceiptSpreadsheetRow(receipt: receipt, imageID: imageID).values]
                )
            }) else { return nil }
            receipts.insert(receipt, at: 0)
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
}

// MARK: - Private Methods

private extension ReceiptRepository {
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
