//
//  FetchSpreadsheetRowsEndpoint+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/14/26.
//

nonisolated extension FetchSpreadsheetRowsEndpoint {
    struct Response: Decodable {
        let range: String
        let majorDimension: String
        let values: [[String]]?
    }
}
