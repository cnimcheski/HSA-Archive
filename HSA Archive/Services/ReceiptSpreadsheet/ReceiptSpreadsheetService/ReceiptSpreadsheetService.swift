//
//  ReceiptSpreadsheetService.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/18/26.
//

import FactoryKit
import Toast

nonisolated final class ReceiptSpreadsheetService {
    private let googleDriveService = Container.shared.googleDriveService()
    private let googleSheetsService = Container.shared.googleSheetsService()
    private let userDefaultsManager = Container.shared.userDefaultsManager()
    
    /// Creates and configures the app's spreadsheet with the required worksheet and header row.
    func setupSpreadsheet() async -> AppendSpreadsheetRowsEndpoint.Response? {
        guard let spreadsheetID = await createSpreadsheet() else { return nil }
        do {
            guard try await renameFirstSheet(spreadsheetID: spreadsheetID) != nil else { return nil }
            guard let response = try await addHeaderRow(spreadsheetID: spreadsheetID) else { return nil }
            userDefaultsManager.setSpreadsheetID(spreadsheetID)
            return response
        } catch {
            await handleSetupSpreadsheetFailure()
            return nil
        }
    }
    
    /// Runs a Sheets operation using the stored spreadsheet ID.
    /// If the spreadsheet can't be found, recovers an existing spreadsheet or creates a new one,
    /// then runs the appropriate operation against the recovered spreadsheet ID.
    ///
    /// - Parameters:
    ///   - operation: The API call to perform against the current spreadsheet ID.
    ///   - onNewSpreadsheet: What to run against a newly created spreadsheet, defaults to `operation` when nil.
    /// - Returns: The result of whichever closure ends up running.
    /// - Throws: `ReceiptSpreadsheetError.spreadsheetNotFound` if recovery fails, otherwise
    ///   whatever `operation` or `onNewSpreadsheet` throws.
    func withSpreadsheetRecovery<T>(
        _ operation: @escaping (String) async throws -> T,
        onNewSpreadsheet: ((String) async throws -> T)? = nil
    ) async throws -> T {
        let onNewSpreadsheet = onNewSpreadsheet ?? operation
        guard let spreadsheetID = userDefaultsManager.spreadsheetID else {
            return try await handleSpreadsheetRecovery(operation, onNewSpreadsheet: onNewSpreadsheet)
        }
        do {
            return try await operation(spreadsheetID)
        } catch {
            guard let error = error as? SpreadsheetFailureConvertible, error.spreadsheetFailureReason == .notFound else { throw error }
            return try await handleSpreadsheetRecovery(operation, onNewSpreadsheet: onNewSpreadsheet)
        }
    }
}

// MARK: - Private Methods

nonisolated private extension ReceiptSpreadsheetService {
    /// Creates an app receipt spreadsheet.
    func createSpreadsheet() async -> String? {
        await googleDriveService.createSpreadsheet(
            name: AppConstants.spreadsheetTitle
        )
    }
    
    /// Finds the first sheet and renames it to the app's worksheet name.
    func renameFirstSheet(
        spreadsheetID: String
    ) async throws -> BatchUpdateSpreadsheetEndpoint.Response? {
        guard let sheetID = try await fetchFirstSheetID(spreadsheetID: spreadsheetID) else { return nil }
        return try await updateSheetName(spreadsheetID: spreadsheetID, sheetID: sheetID)
    }
    
    /// Fetches the ID of the first sheet in the given spreadsheet.
    func fetchFirstSheetID(
        spreadsheetID: String
    ) async throws(FetchSpreadsheetEndpoint.EndpointError) -> Int? {
        try await googleSheetsService.fetchSpreadsheet(
            spreadsheetID: spreadsheetID
        )?.sheets.first?.properties.sheetID
    }
    
    /// Updates the given sheet's name to the app's worksheet name.
    func updateSheetName(
        spreadsheetID: String,
        sheetID: Int
    ) async throws(BatchUpdateSpreadsheetEndpoint.EndpointError) -> BatchUpdateSpreadsheetEndpoint.Response? {
        try await googleSheetsService.batchUpdate(
            spreadsheetID: spreadsheetID,
            requests: [
                .updateSheetProperties(
                    .init(
                        properties: .init(sheetID: sheetID, title: AppConstants.worksheetName),
                        fields: "title"
                    )
                )
            ]
        )
    }
    
    /// Adds a header row to the apps spreadsheet.
    func addHeaderRow(
        spreadsheetID: String
    ) async throws(AppendSpreadsheetRowsEndpoint.EndpointError) -> AppendSpreadsheetRowsEndpoint.Response? {
        try await googleSheetsService.appendRows(
            spreadsheetID: spreadsheetID,
            range: AppConstants.worksheetName,
            values: [ReceiptSpreadsheetSchema.headers]
        )
    }
}

// MARK: - Main Actor Private Error Handlers

private extension ReceiptSpreadsheetService {
    /// Shows a toast indicating that spreadsheet setup failed.
    func handleSetupSpreadsheetFailure() {
        ToastManager.shared.show(DefaultToastType.spreadsheetSetupFailed)
    }
    
    /// Runs the appropriate operation for the recovered spreadsheet.
    func handleSpreadsheetRecovery<T>(
        _ operation: @escaping (String) async throws -> T,
        onNewSpreadsheet: (String) async throws -> T
    ) async throws -> T {
        guard let recovery = await recoverSpreadsheet() else { throw ReceiptSpreadsheetError.spreadsheetNotFound }
        return switch recovery {
        case let .existing(spreadsheetID):
            try await operation(spreadsheetID)
        case let .new(spreadsheetID):
            try await onNewSpreadsheet(spreadsheetID)
        }
    }
    
    /// Recovers the spreadsheet by finding an existing one or creating a new one, otherwise returns nil.
    func recoverSpreadsheet() async -> SpreadsheetRecoveryResult? {
        userDefaultsManager.clearSpreadsheetID()
        if let spreadsheetID = await googleDriveService.findExistingSpreadsheetID() {
            userDefaultsManager.setSpreadsheetID(spreadsheetID)
            return .existing(spreadsheetID)
        } else {
            guard let response = await setupSpreadsheet() else { return nil }
            ToastManager.shared.show(DefaultToastType.spreadsheetRecreated)
            return .new(response.spreadsheetID)
        }
    }
}
