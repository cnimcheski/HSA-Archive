//
//  CreateSpreadsheetEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/13/26.
//

import Networking

nonisolated struct CreateSpreadsheetEndpoint: Endpoint {
    enum EndpointError: APIError, FolderFailureConvertible {
        case parentFolderNotFound
        
        var statusCode: Int {
            switch self {
            case .parentFolderNotFound:
                404
            }
        }
        
        var message: String? { nil }
        
        var folderFailureReason: FolderFailureReason? {
            switch self {
            case .parentFolderNotFound:
                .notFound
            }
        }
    }
    
    var path: String = "drive/v3/files"
    var queryParameters: [String: String] = [:]
    var body: Encodable?
    var method: HTTPMethod = .post
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true
    
    init(body: Body) {
        self.body = body
    }
}
