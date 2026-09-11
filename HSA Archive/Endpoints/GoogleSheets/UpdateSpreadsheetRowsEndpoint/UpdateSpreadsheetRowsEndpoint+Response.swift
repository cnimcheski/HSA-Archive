//
//  UpdateSpreadsheetRowsEndpoint+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/8/26.
//

nonisolated extension UpdateSpreadsheetRowsEndpoint {
    struct Response: Decodable {
        let spreadsheetID: String
        let updatedRange: String
        let updatedRows: Int
        let updatedColumns: Int
        let updatedCells: Int
        
        private enum CodingKeys: String, CodingKey {
            case spreadsheetID = "spreadsheetId"
            case updatedRange
            case updatedRows
            case updatedColumns
            case updatedCells
        }
    }
}
