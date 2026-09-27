//
//  ListFilesEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/17/26.
//

import Networking

nonisolated struct ListFilesEndpoint: Endpoint {
    var path: String = "drive/v3/files"
    var queryParameters: [String: String]
    var body: Encodable? = nil
    var method: HTTPMethod = .get
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true
    
    init(query: String?, pageToken: String?) {
        queryParameters = [
            "fields": "nextPageToken,files(id)",
            "pageSize": "1000",
            "q": query,
            "pageToken": pageToken
        ].compactMapValues { $0 }
    }
}
