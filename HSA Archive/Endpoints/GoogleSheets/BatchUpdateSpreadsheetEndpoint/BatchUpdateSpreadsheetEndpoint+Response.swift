//
//  BatchUpdateSpreadsheetEndpoint+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/16/26.
//

nonisolated extension BatchUpdateSpreadsheetEndpoint {
    struct Response: Decodable {
        let spreadsheetID: String
        let replies: [Reply]
        
        private enum CodingKeys: String, CodingKey {
            case spreadsheetID = "spreadsheetId"
            case replies
        }
    }
}

// MARK: - Response+Reply

nonisolated extension BatchUpdateSpreadsheetEndpoint.Response {
    struct Reply: Decodable {
        let addSheet: AddSheetResponse?
        let deleteSheet: DeleteSheetResponse?
    }
}

// MARK: - Response+Reply+AddSheetResponse

nonisolated extension BatchUpdateSpreadsheetEndpoint.Response.Reply {
    struct AddSheetResponse: Decodable {
        let properties: Properties
    }
}

nonisolated extension BatchUpdateSpreadsheetEndpoint.Response.Reply.AddSheetResponse {
    struct Properties: Decodable {
        let sheetID: Int
        let title: String
        
        private enum CodingKeys: String, CodingKey {
            case sheetID = "sheetId"
            case title
        }
    }
}

// MARK: - Response+Reply+DeleteSheetResponse

nonisolated extension BatchUpdateSpreadsheetEndpoint.Response.Reply {
    struct DeleteSheetResponse: Decodable {}
}
