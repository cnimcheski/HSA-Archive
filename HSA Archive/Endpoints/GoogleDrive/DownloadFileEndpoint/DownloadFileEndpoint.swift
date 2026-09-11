//
//  DownloadFileEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/7/26.
//

import Networking

nonisolated struct DownloadFileEndpoint: Endpoint {
    enum EndpointError: APIError {
        case notFound
        
        var statusCode: Int {
            switch self {
            case .notFound:
                404
            }
        }
        
        var message: String? { nil }
    }
    
    var path: String
    var queryParameters: [String: String] = ["alt": "media"]
    var body: Encodable?
    var method: Networking.HTTPMethod = .get
    var dateDecodingFormat: Networking.DateFormat? = nil
    var requiresAuth: Bool = true
    
    init(fileID: String) {
        path = "drive/v3/files/\(fileID)"
    }
}
