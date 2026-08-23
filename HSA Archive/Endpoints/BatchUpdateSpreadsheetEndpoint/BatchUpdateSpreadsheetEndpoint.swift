//
//  BatchUpdateSpreadsheetEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/15/26.
//

import Networking

nonisolated struct BatchUpdateSpreadsheetEndpoint: Endpoint {
    enum EndpointError: APIError, SpreadsheetFailureConvertible {
        case spreadsheetNotFound
        
        var statusCode: Int {
            switch self {
            case .spreadsheetNotFound:
                404
            }
        }
        
        var message: String? { nil }
        
        var spreadsheetFailureReason: SpreadsheetFailureReason? {
            if case .spreadsheetNotFound = self { return .notFound }
            return nil
        }
    }
    
    var path: String
    var queryParameters: [String: String] = [:]
    var body: Encodable?
    var method: HTTPMethod = .post
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true
    
    init(body: Body, spreadsheetID: String) {
        self.body = body
        path = "\(spreadsheetID):batchUpdate"
    }
}
