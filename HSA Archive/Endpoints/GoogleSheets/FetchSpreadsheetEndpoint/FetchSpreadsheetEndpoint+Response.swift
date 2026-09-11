//
//  FetchSpreadsheetEndpoint+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/17/26.
//

nonisolated extension FetchSpreadsheetEndpoint {
    struct Response: Decodable {
        let sheets: [Sheet]
    }
}

// MARK: - Response+Sheet

nonisolated extension FetchSpreadsheetEndpoint.Response {
    struct Sheet: Decodable {
        let properties: Properties
    }
}

nonisolated extension FetchSpreadsheetEndpoint.Response.Sheet {
    struct Properties: Decodable {
        let sheetID: Int
        let title: String
        
        private enum CodingKeys: String, CodingKey {
            case sheetID = "sheetId"
            case title
        }
    }
}
