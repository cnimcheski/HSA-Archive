//
//  FindSpreadsheetIDEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/14/26.
//

import Networking

nonisolated struct FindSpreadsheetIDEndpoint: Endpoint {
    var path: String = "drive/v3/files"
    var queryParameters: [String: String]
    var body: Encodable? = nil
    var method: HTTPMethod = .get
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true
    
    init() {
        let query = [
            "appProperties has { key = '\(AppConstants.spreadsheetAppPropertyKey)' and value = '\(AppConstants.spreadsheetAppPropertyValue)' }",
            "mimeType = 'application/vnd.google-apps.spreadsheet'",
            "trashed = false"
        ].joined(separator: " and ")
        queryParameters = [
            "q": query,
            "spaces": "drive",
            "fields": "files(id,name)",
            "pageSize": "1",
            "orderBy": "createdTime asc"
        ]
    }
}
