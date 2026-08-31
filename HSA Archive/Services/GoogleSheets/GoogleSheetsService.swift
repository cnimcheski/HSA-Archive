//
//  GoogleSheetsService.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/12/26.
//

import FactoryKit
import Networking

nonisolated final class GoogleSheetsService {
    private let apiManager = Container.shared.googleSheetsAPIManager()
    
    /// Fetches a spreadsheets details by its ID.
    func fetchSpreadsheet(
        spreadsheetID: String
    ) async throws(FetchSpreadsheetEndpoint.EndpointError) -> FetchSpreadsheetEndpoint.Response? {
        try await apiManager.performRequest(
            for: FetchSpreadsheetEndpoint(spreadsheetID: spreadsheetID)
        )
    }
    
    /// Fetches the cell values for the given range in a spreadsheet.
    /// Throws an `APIManagerError` so callers can react to any error in the UI.
    /// - Note: Callers will need to remove headers from the range if necessary.
    func fetchRows(
        spreadsheetID: String,
        range: String
    ) async throws(APIManagerError) -> [[String]] {
        let response: FetchSpreadsheetRowsEndpoint.Response = try await apiManager.performThrowingRequest(
            for: FetchSpreadsheetRowsEndpoint(spreadsheetID: spreadsheetID, range: range)
        )
        return response.values ?? []
    }
    
    /// Appends one or more rows to the end of the table defined by the given range.
    func appendRows(
        spreadsheetID: String,
        range: String,
        values: [[String]]
    ) async throws(AppendSpreadsheetRowsEndpoint.EndpointError) -> AppendSpreadsheetRowsEndpoint.Response? {
        try await apiManager.performRequest(
            for: AppendSpreadsheetRowsEndpoint(
                body: .init(values: values),
                spreadsheetID: spreadsheetID,
                range: range
            )
        )
    }
    
    /// Applies one or more updates to a spreadsheet.
    func batchUpdate(
        spreadsheetID: String,
        requests: [BatchUpdateSpreadsheetEndpoint.Body.Request]
    ) async throws(BatchUpdateSpreadsheetEndpoint.EndpointError) -> BatchUpdateSpreadsheetEndpoint.Response? {
        try await Container.shared.googleSheetsAPIManager().performRequest(
            for: BatchUpdateSpreadsheetEndpoint(
                body: .init(requests: requests),
                spreadsheetID: spreadsheetID
            )
        )
    }
    
    func updateRows() async throws {
        // TODO: - Implement this
    }
    
    func deleteRows() async throws {
        // TODO: - Implement this
    }
}
