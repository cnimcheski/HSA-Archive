//
//  AppendSpreadsheetRowsEndpoint+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/14/26.
//

nonisolated extension AppendSpreadsheetRowsEndpoint {
    struct Response: Decodable {
        let spreadsheetID: String
        let tableRange: String?
        let updates: Updates?
        
        private enum CodingKeys: String, CodingKey {
            case spreadsheetID = "spreadsheetId"
            case tableRange
            case updates
        }
    }
}

// MARK: - Response+Updates

nonisolated extension AppendSpreadsheetRowsEndpoint.Response {
    struct Updates: Decodable {
        let spreadsheetID: String
        let updatedRange: String?
        let updatedRows: Int?
        let updatedColumns: Int?
        let updatedCells: Int?
        
        private enum CodingKeys: String, CodingKey {
            case spreadsheetID = "spreadsheetId"
            case updatedRange
            case updatedRows
            case updatedColumns
            case updatedCells
        }
    }
}
