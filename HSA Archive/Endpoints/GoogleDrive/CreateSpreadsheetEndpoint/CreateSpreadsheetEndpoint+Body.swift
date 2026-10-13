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
        let parents: [String]?
        
        /// Sets the `appProperties` to have the app tag and current schema version by default.
        init(
            name: String,
            appProperties: [String: String]? = [
                AppConstants.spreadsheetAppPropertyKey: AppConstants.spreadsheetAppPropertyValue,
                AppConstants.schemaVersionAppPropertyKey: String(ReceiptSpreadsheetSchema.currentVersion)
            ],
            parents: [String]? = nil
        ) {
            self.name = name
            self.appProperties = appProperties
            self.parents = parents
        }
    }
}
