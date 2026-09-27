//
//  Metadata.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/20/26.
//

nonisolated struct Metadata: Encodable {
    let name: String
    let mimeType: String
    let parents: [String]?
    let appProperties: [String: String]?
    
    /// Sets the `appProperties` to have the app tag by default.
    init(
        name: String,
        mimeType: String,
        parents: [String]? = nil,
        appProperties: [String: String]? = [
            AppConstants.spreadsheetAppPropertyKey: AppConstants.spreadsheetAppPropertyValue
        ]
    ) {
        self.name = name
        self.mimeType = mimeType
        self.parents = parents
        self.appProperties = appProperties
    }
}
