//
//  ReceiptSpreadsheetService.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/18/26.
//

import FactoryKit
import Toast

final class ReceiptSpreadsheetService {
    private let googleDriveService = Container.shared.googleDriveService()
    private let googleSheetsService = Container.shared.googleSheetsService()
    private let userDefaultsManager = Container.shared.userDefaultsManager()
    
    /// Loads the given folder ID from user defaults or Drive and caches it locally.
    func loadFolderID(_ folder: Folder) async -> String? {
        if let folderID = folder.id { return folderID }
        guard let folderID = await googleDriveService.findFolder(named: folder.name) else { return nil }
        folder.set(id: folderID)
        return folderID
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
    
    /// Runs an operation against the given folder, recovering the folder if necessary.
    /// Uses the folder's existing ID when available. If the ID is missing or the folder is no longer found,
    /// recovers the folder hierarchy and retries using the recovered ID.
    /// When a new folder is recovered, `onNewFolder` can be used to perform a different operation
    /// against the new folder ID.
    ///
    /// - Parameters:
    ///   - folder: The folder to perform the operation against.
    ///   - operation: The operation to perform using the folder ID.
    ///   - onNewFolder: An optional operation to perform when the folder is recovered. Defaults to `operation`.
    /// - Returns: The id of the given folder.
    /// - Throws: `ReceiptSpreadsheetError.folderNotFound` if recovery fails, otherwise whatever
    ///  `operation` or `onNewFolder` throws.
    func withFolderRecovery<T>(
        _ folder: Folder,
        _ operation: @escaping (String) async throws -> T,
        onNewFolder: ((String) async throws -> T)? = nil
    ) async throws -> T {
        let onNewFolder = onNewFolder ?? operation
        guard let folderID = folder.id
        else { return try await handleFolderRecovery(folder, onNewFolder: onNewFolder) }
        do {
            return try await operation(folderID)
        } catch {
            guard let error = error as? FolderFailureConvertible, error.folderFailureReason == .notFound
            else { throw error }
            return try await handleFolderRecovery(folder, onNewFolder: onNewFolder)
        }
    }
}

// MARK: - Private Methods

private extension ReceiptSpreadsheetService {
    /// Creates and configures the app's spreadsheet with the required worksheet and header row.
    func setupSpreadsheet() async -> AppendSpreadsheetRowsEndpoint.Response? {
        guard let spreadsheetID = await createSpreadsheet() else { return nil }
        do {
            guard try await renameFirstSheet(spreadsheetID: spreadsheetID) != nil else { return nil }
            guard let response = try await addHeaderRow(spreadsheetID: spreadsheetID) else { return nil }
            userDefaultsManager.setSpreadsheetID(spreadsheetID)
            return response
        } catch {
            handleSetupSpreadsheetFailure()
            return nil
        }
    }
    
    /// Creates an app receipt spreadsheet.
    func createSpreadsheet() async -> String? {
        do {
            return try await withFolderRecovery(.archive) { folderID in
                try await self.googleDriveService.createSpreadsheet(
                    name: AppConstants.spreadsheetTitle,
                    parents: [folderID]
                )
            }
        } catch let error as CreateSpreadsheetEndpoint.EndpointError {
            handleCreateSpreadsheetError(error)
        } catch {
            handleUnknownError()
        }
        return nil
    }
    
    /// Finds the first sheet and renames it to the app's worksheet name.
    func renameFirstSheet(
        spreadsheetID: String
    ) async throws -> BatchUpdateSpreadsheetEndpoint.Response? {
        guard let sheetID = try await googleSheetsService.fetchFirstSheetID(spreadsheetID: spreadsheetID) else { return nil }
        return try await updateSheetName(spreadsheetID: spreadsheetID, sheetID: sheetID)
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
        let hadStoredSpreadsheetID = userDefaultsManager.spreadsheetID != nil
        userDefaultsManager.clearSpreadsheetID()
        if let spreadsheetID = await googleDriveService.findExistingSpreadsheetID() {
            userDefaultsManager.setSpreadsheetID(spreadsheetID)
            return .existing(spreadsheetID)
        } else {
            guard let response = await setupSpreadsheet() else { return nil }
            userDefaultsManager.clearReceiptsFolderID()
            let toastType = hadStoredSpreadsheetID
                ? DefaultToastType.spreadsheetRecreated
                : DefaultToastType.spreadsheetCreated
            ToastManager.shared.show(toastType)
            return .new(response.spreadsheetID)
        }
    }
    
    /// Recovers the folder and its hierarchy and performs an operation using the recovered folder ID.
    func handleFolderRecovery<T>(
        _ folder: Folder,
        onNewFolder: (String) async throws -> T
    ) async throws -> T {
        let folderID = try await recoverFolderHierarchy(folder)
        return try await onNewFolder(folderID)
    }
    
    /// Recovers a folder and recursively recovers any required parent folders.
    func recoverFolderHierarchy(_ folder: Folder) async throws -> String {
        let parentID: String?
        if let parent = folder.parent {
            parentID = try await recoverFolderHierarchy(parent)
        } else {
            parentID = nil
        }
        guard let folderID = await recoverFolder(folder, parentID: parentID)
        else { throw ReceiptSpreadsheetError.folderNotFound }
        return folderID
    }
    
    /// Recovers the specified folder by finding an existing one or creating a new one, otherwise returns nil.
    func recoverFolder(_ folder: Folder, parentID: String? = nil) async -> String? {
        folder.clearID()
        guard let folderID = await googleDriveService.getOrCreateFolder(
            named: folder.name,
            parents: [parentID].compactMap { $0 }
        )
        else { return nil }
        folder.set(id: folderID)
        return folderID
    }
}

// MARK: - Private Error Handlers

private extension ReceiptSpreadsheetService {
    func handleSetupSpreadsheetFailure() {
        ToastManager.shared.show(DefaultToastType.spreadsheetSetupFailed)
    }
    
    func handleCreateSpreadsheetError(_ error: CreateSpreadsheetEndpoint.EndpointError) {
        switch error {
        case .parentFolderNotFound:
            ToastManager.shared.show(DefaultToastType.spreadsheetSetupFailed)
        }
    }
    
    func handleUnknownError() {
        ToastManager.shared.show(DefaultToastType.unexpectedError)
    }
}
