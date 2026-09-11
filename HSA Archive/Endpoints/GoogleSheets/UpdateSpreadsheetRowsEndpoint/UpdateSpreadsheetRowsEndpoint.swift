//
//  UpdateSpreadsheetRowsEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/8/26.
//

import Networking

nonisolated struct UpdateSpreadsheetRowsEndpoint: Endpoint {
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
    var queryParameters: [String: String] = ["valueInputOption": "USER_ENTERED"]
    var body: Encodable?
    var method: HTTPMethod = .put
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true
    
    init(spreadsheetID: String, range: String, values: [[String]]) {
        path = "\(spreadsheetID)/values/\(range)"
        body = ValuesRange(values: values)
    }
}
