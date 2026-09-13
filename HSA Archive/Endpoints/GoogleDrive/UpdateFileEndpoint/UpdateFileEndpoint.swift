//
//  UpdateFileEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/12/26.
//

import Networking

nonisolated struct UpdateFileEndpoint: Endpoint {
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
    var body: Encodable?
    var method: HTTPMethod = .patch
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true
    
    init(fileID: String, body: Body) {
        self.body = body
        path = "drive/v3/files/\(fileID)"
    }
}
