//
//  DeleteFileEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/18/26.
//

import Networking

/// - Note: Only returns a 204 status code with no response on success. Use an `EmptyResponse` for the response type.
nonisolated struct DeleteFileEndpoint: Endpoint {
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
    var queryParameters: [String: String] = [:]
    var body: Encodable? = nil
    var method: HTTPMethod = .delete
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true
    
    init(fileID: String) {
        path = "drive/v3/files/\(fileID)"
    }
}
