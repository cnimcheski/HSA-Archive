//
//  GetFileEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 10/9/26.
//

import Networking

nonisolated struct GetFileEndpoint: Endpoint {
    enum EndpointError: APIError, SpreadsheetFailureConvertible {
        case notFound
        
        var statusCode: Int {
            switch self {
            case .notFound:
                404
            }
        }
        
        var message: String? { nil }
        
        var spreadsheetFailureReason: SpreadsheetFailureReason? {
            if case .notFound = self { return .notFound }
            return nil
        }
    }
    
    var path: String
    var queryParameters: [String: String] = ["fields": "name,mimeType,parents,appProperties"]
    var body: Encodable? = nil
    var method: HTTPMethod = .get
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true

    init(fileID: String) {
        path = "drive/v3/files/\(fileID)"
    }
}
