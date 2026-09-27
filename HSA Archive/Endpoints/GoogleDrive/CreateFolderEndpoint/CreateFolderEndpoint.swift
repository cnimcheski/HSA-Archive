//
//  CreateFolderEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/20/26.
//

import Networking

nonisolated struct CreateFolderEndpoint: Endpoint {
    var path: String = "drive/v3/files"
    var queryParameters: [String: String] = ["fields": "id"]
    var body: Encodable? = nil
    var method: HTTPMethod = .post
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true

    init(metadata: Metadata) {
        self.body = metadata
    }
}
