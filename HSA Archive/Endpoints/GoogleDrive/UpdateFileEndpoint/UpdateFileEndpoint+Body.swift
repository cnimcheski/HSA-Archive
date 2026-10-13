//
//  UpdateFileEndpoint+Body.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/12/26.
//

nonisolated extension UpdateFileEndpoint {
    struct Body: Encodable {
        let trashed: Bool?
        let appProperties: [String: String]?
        
        init(trashed: Bool? = nil, appProperties: [String: String]? = nil) {
            self.trashed = trashed
            self.appProperties = appProperties
        }
    }
}
