//
//  CreateSpreadsheetEndpoint+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/13/26.
//

nonisolated extension CreateSpreadsheetEndpoint {
    struct Response: Decodable {
        let kind: String
        let id: String
        let name: String
        let mimeType: String
    }
}
