//
//  CreateSpreadsheetEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/13/26.
//

import Networking

nonisolated struct CreateSpreadsheetEndpoint: Endpoint {
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
