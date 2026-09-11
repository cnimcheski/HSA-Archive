//
//  FindSpreadsheetIDEndpoint+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/14/26.
//

nonisolated extension FindSpreadsheetIDEndpoint {
    struct Response: Decodable {
        let files: [File]
    }
}

// MARK: - Response+File

nonisolated extension FindSpreadsheetIDEndpoint.Response {
    struct File: Decodable {
        let id: String
        let name: String?
    }
}
