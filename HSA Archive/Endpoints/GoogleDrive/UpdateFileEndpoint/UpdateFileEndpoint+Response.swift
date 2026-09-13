//
//  UpdateFileEndpoint+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/12/26.
//

nonisolated extension UpdateFileEndpoint {
    struct Response: Decodable {
        let id: String
        let name: String
        let mimeType: String
        let kind: String
    }
}
