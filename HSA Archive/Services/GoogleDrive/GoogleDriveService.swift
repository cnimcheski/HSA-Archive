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
    
    /// Uploads a file to Google Drive.
    func uploadFile(
        name: String,
        mimeType: String,
        data: Data
    ) async throws(UploadFileEndpoint.BodyError) -> UploadFileEndpoint.Response? {
        await apiManager.performRequest(
            for: try UploadFileEndpoint(
                name: name,
                mimeType: mimeType,
                data: data
            )
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
    func createSpreadsheet(name: String) async -> String? {
        guard let response: CreateSpreadsheetEndpoint.Response = await apiManager.performRequest(
            for: CreateSpreadsheetEndpoint(
                body: .init(name: name)
            )
        ) else { return nil }
        return response.id
    }
}
