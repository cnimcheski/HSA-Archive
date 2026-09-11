//
//  AppendSpreadsheetRowsEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/13/26.
//

import Networking

nonisolated struct AppendSpreadsheetRowsEndpoint: Endpoint {
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
    var queryParameters: [String: String] = [
        "valueInputOption": "USER_ENTERED",
        "insertDataOption": "INSERT_ROWS"
    ]
    var body: Encodable?
    var method: HTTPMethod = .post
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true
    
    init(
        body: ValuesRange,
        spreadsheetID: String,
        range: String
    ) {
        self.body = body
        path = "\(spreadsheetID)/values/\(range):append"
    }
}
