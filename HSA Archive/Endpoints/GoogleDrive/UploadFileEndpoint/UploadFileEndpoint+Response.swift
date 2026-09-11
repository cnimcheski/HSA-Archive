//
//  UploadFileEndpoint+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/22/26.
//

nonisolated extension UploadFileEndpoint {
    struct Response: Decodable {
        let id: String
    }
}
