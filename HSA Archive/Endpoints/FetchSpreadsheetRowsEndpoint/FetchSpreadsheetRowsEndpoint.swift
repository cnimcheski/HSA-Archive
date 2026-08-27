//
//  FetchSpreadsheetRowsEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/14/26.
//

import Networking

nonisolated struct FetchSpreadsheetRowsEndpoint: Endpoint {
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
    var body: Encodable? = nil
    var method: HTTPMethod = .get
    var dateDecodingFormat: DateFormat?
    var requiresAuth: Bool = true
    
    init(spreadsheetID: String, range: String) {
        path = "\(spreadsheetID)/values/\(range)"
    }
}
