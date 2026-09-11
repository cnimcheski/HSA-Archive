//
//  UploadFileEndpoint+Metadata.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/22/26.
//

nonisolated extension UploadFileEndpoint {
    struct Metadata: Encodable {
        let name: String
        let mimeType: String
    }
}
