//
//  FetchSpreadsheetEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/17/26.
//

import Networking

nonisolated struct FetchSpreadsheetEndpoint: Endpoint {
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
    var queryParameters: [String: String] = ["fields": "sheets.properties"]
    var body: Encodable? = nil
    var method: HTTPMethod = .get
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true
    
    init(spreadsheetID: String) {
        path = spreadsheetID
    }
}
