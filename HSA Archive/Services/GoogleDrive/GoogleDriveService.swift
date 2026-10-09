//
//  GoogleDriveService.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/12/26.
//

import FactoryKit
import Foundation
import Networking

nonisolated final class GoogleDriveService {
    private let apiManager = Container.shared.googleDriveAPIManager()
    private let userDefaultsManager = Container.shared.userDefaultsManager()
    
    /// Lists all files in Drive matching the optional query.
    func listFiles(
        query: String? = nil
    ) async -> [ListFilesEndpoint.Response.DriveFile]? {
        var pageToken: String?
        var files = [ListFilesEndpoint.Response.DriveFile]()
        repeat {
            guard let response: ListFilesEndpoint.Response = await apiManager.performRequest(
                for: ListFilesEndpoint(query: query, pageToken: pageToken)
            ) else { return nil }
            files.append(contentsOf: response.files)
            pageToken = response.nextPageToken
        } while pageToken != nil
        return files
    }
    
    /// Returns the named folder in Drive, or nil if it doesn't exist.
    func findFolder(named name: String) async -> String? {
        let query = """
            name = '\(name)'
            and mimeType = 'application/vnd.google-apps.folder'
            and appProperties has { key = '\(AppConstants.spreadsheetAppPropertyKey)' and value = '\(AppConstants.spreadsheetAppPropertyValue)' }
            and trashed = false
            """
        return await listFiles(query: query)?.first?.id
    }
    
    /// Returns the named folder in Drive, creating it if it doesn't exist.
    func getOrCreateFolder(named name: String, parents: [String] = []) async -> String? {
        guard let folder = await findFolder(named: name)
        else { return await createFolder(name: name, parents: parents)?.id }
        return folder
    }
    
    /// Uploads a file to Google Drive.
    /// - Throws: UploadFileEndpoint.BodyError & UploadFileEndpoint.EndpointError
    func uploadFile(
        name: String,
        mimeType: String,
        parents: [String],
        data: Data
    ) async throws -> UploadFileEndpoint.Response? {
        try await apiManager.performRequest(
            for: try UploadFileEndpoint(
                metadata: .init(name: name, mimeType: mimeType, parents: parents),
                data: data
            )
        )
    }
    
    /// Downloads the file data for the specified Drive file.
    func downloadFile(
        id: String
    ) async throws(DownloadFileEndpoint.EndpointError) -> Data? {
        try await apiManager.performRequest(
            for: DownloadFileEndpoint(fileID: id)
        )
    }
    
    /// Deletes a file from Drive by its ID.
    func deleteFile(
        id: String
    ) async throws(DeleteFileEndpoint.EndpointError) -> EmptyResponse? {
        try await apiManager.performRequest(for: DeleteFileEndpoint(fileID: id))
    }
    
    /// Moves the specified file to the trash.
    func trashFile(
        id: String
    ) async throws(UpdateFileEndpoint.EndpointError) -> UpdateFileEndpoint.Response? {
        try await apiManager.performRequest(
            for: UpdateFileEndpoint(fileID: id, body: .init(trashed: true))
        )
    }
    
    /// Restores the specified file from the trash.
    func untrashFile(
        id: String
    ) async throws(UpdateFileEndpoint.EndpointError) -> UpdateFileEndpoint.Response? {
        try await apiManager.performRequest(
            for: UpdateFileEndpoint(fileID: id, body: .init(trashed: false))
        )
    }
    
    /// Gets the ID of the existing spreadsheet in User Defaults, otherwise fetches it from Drive.
    func existingSpreadsheetID() async -> String? {
        if let spreadsheetID = userDefaultsManager.spreadsheetID { return spreadsheetID }
        return await findExistingSpreadsheetID()
    }
    
    /// Searches Drive for an existing usable spreadsheet and returns the ID if available.
    func findExistingSpreadsheetID() async -> String? {
        guard let response: FindSpreadsheetIDEndpoint.Response = await apiManager.performRequest(
            for: FindSpreadsheetIDEndpoint()
        ) else { return nil }
        return response.files.first?.id
    }
    
    /// Creates a new spreadsheet with the given name and returns its ID.
    func createSpreadsheet(
        name: String,
        parents: [String]?
    ) async throws(CreateSpreadsheetEndpoint.EndpointError) -> String? {
        guard let response: CreateSpreadsheetEndpoint.Response = try await apiManager.performRequest(
            for: CreateSpreadsheetEndpoint(
                body: .init(name: name, parents: parents)
            )
        ) else { return nil }
        return response.id
    }
}

// MARK: Private Methods

nonisolated private extension GoogleDriveService {
    /// Creates a folder in Drive with the app's properties.
    func createFolder(name: String, parents: [String]) async -> CreateFolderEndpoint.Response? {
        await apiManager.performRequest(
            for: CreateFolderEndpoint(
                metadata: .init(
                    name: name,
                    mimeType: "application/vnd.google-apps.folder",
                    parents: parents,
                    appProperties: [
                        AppConstants.spreadsheetAppPropertyKey:
                            AppConstants.spreadsheetAppPropertyValue
                    ]
                )
            )
        )
    }
}
