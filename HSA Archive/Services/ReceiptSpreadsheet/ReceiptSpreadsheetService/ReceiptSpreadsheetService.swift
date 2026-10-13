//
//  ReceiptSpreadsheetService.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/18/26.
//

import FactoryKit
import Networking
import Observation
import Toast

@Observable
final class ReceiptSpreadsheetService {
    enum SchemaMigrationError: Error {
        case unsupportedVersion(Int)
        case noSchemaVersionFound
    }
    
    private let googleDriveService = Container.shared.googleDriveService()
    private let googleSheetsService = Container.shared.googleSheetsService()
    private let userDefaultsManager = Container.shared.userDefaultsManager()
    
    private(set) var requiresAppUpdate = false
    
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
    
    /// Ensures the app spreadsheet uses the current schema version, migrating it if necessary.
    /// Returns the current schema version.
    /// - Throws: `APIManagerError` and `SchemaMigrationError`.
    func ensureCurrentSchema(for spreadsheetID: String) async throws -> Int {
        let currentVersion = ReceiptSpreadsheetSchema.currentVersion
        if userDefaultsManager.spreadsheetSchemaVersion == currentVersion { return currentVersion }
        do {
            let storedVersion = try await self.getSchemaVersion(spreadsheetID: spreadsheetID)
            try await self.migrateSchema(from: storedVersion, spreadsheetID: spreadsheetID)
            try await self.setSchemaVersion(currentVersion, spreadsheetID: spreadsheetID)
            return currentVersion
        } catch let error as SchemaMigrationError {
            requiresAppUpdate = true
            throw error
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
                let spreadsheetID = try await self.googleDriveService.createSpreadsheet(
                    name: AppConstants.spreadsheetTitle,
                    parents: [folderID]
                )
                self.userDefaultsManager.setSpreadsheetSchemaVersion(ReceiptSpreadsheetSchema.currentVersion)
                return spreadsheetID
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
    
    /// Returns the spreadsheet's schema version, or `nil` if unavailable.
    /// - Throws: `APIManagerError` and `SchemaMigrationError`.
    func getSchemaVersion(spreadsheetID: String) async throws -> Int {
        let file = try await googleDriveService.getFile(for: spreadsheetID)
        guard let value = file.appProperties?[AppConstants.schemaVersionAppPropertyKey].flatMap(Int.init)
        else { throw SchemaMigrationError.noSchemaVersionFound }
        return value
    }
    
    /// Updates the spreadsheet's schema version, returning the new version or `nil` if the update fails.
    func setSchemaVersion(_ schemaVersion: Int, spreadsheetID: String) async throws(APIManagerError) {
        _ = try await googleDriveService.updateAppProperties(
            [
                AppConstants.spreadsheetAppPropertyKey: AppConstants.spreadsheetAppPropertyValue,
                AppConstants.schemaVersionAppPropertyKey: String(schemaVersion)
            ],
            fileID: spreadsheetID
        )
        userDefaultsManager.setSpreadsheetSchemaVersion(schemaVersion)
    }
}

// MARK: - Schema Migration Methods

private extension ReceiptSpreadsheetService {
    /// Migrates from an old stored schema version to latest.
    /// When adding new schema version, simply add a case to the version switch statement and create the
    /// associated `migrateToVersionX` method.
    /// - Note: Migrations are handled sequentially. Rather than needing to handle migrating from version 1->3 directly,
    /// we go from 1->2 then 2->3. This ensures we only have to add a single migration case from x-1->x.
    func migrateSchema(from storedVersion: Int, spreadsheetID: String) async throws(SchemaMigrationError) {
        let currentVersion = ReceiptSpreadsheetSchema.currentVersion
        if storedVersion == currentVersion { return }
        if storedVersion > currentVersion { throw SchemaMigrationError.unsupportedVersion(storedVersion) }
        for version in (storedVersion + 1)...currentVersion {
            switch version {
            default: throw SchemaMigrationError.unsupportedVersion(version)
            }
        }
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
