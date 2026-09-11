//
//  CreateSpreadsheetEndpoint+Body.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/13/26.
//

nonisolated extension CreateSpreadsheetEndpoint {
    struct Body: Encodable {
        let name: String
        let mimeType: String = "application/vnd.google-apps.spreadsheet"
        let appProperties: [String: String]?
        
        /// Sets the `appProperties` to have the app tag by default.
        init(
            name: String,
            appProperties: [String: String]? = [
                AppConstants.spreadsheetAppPropertyKey: AppConstants.spreadsheetAppPropertyValue
            ]
        ) {
            self.name = name
            self.appProperties = appProperties
        }
    }
}
