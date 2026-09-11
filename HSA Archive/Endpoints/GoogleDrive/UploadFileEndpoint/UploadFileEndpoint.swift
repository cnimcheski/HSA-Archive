//
//  UploadFileEndpoint.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/22/26.
//

import Foundation
import Networking

nonisolated struct UploadFileEndpoint: Endpoint {
    enum BodyError: Error {
        case encodingFailed
    }
    
    var path: String = "upload/drive/v3/files"
    var queryParameters: [String: String] = ["uploadType": "multipart"]
    var headers: [String: String]
    var body: Encodable? = nil
    var rawBody: Data?
    var method: HTTPMethod = .post
    var dateDecodingFormat: DateFormat? = nil
    var requiresAuth: Bool = true
    
    init(
        name: String,
        mimeType: String,
        data: Data
    ) throws(BodyError) {
        let boundary = "Boundary-\(UUID().uuidString)"
        let metadata = Metadata(name: name, mimeType: mimeType)
        guard let encodedMetadata = try? JSONEncoder().encode(metadata) else { throw .encodingFailed }
        
        var rawBody = Data()
        rawBody.append("--\(boundary)\r\n")
        rawBody.append("Content-Type: application/json; charset=UTF-8\r\n\r\n")
        rawBody.append(encodedMetadata)
        rawBody.append("\r\n")
        rawBody.append("--\(boundary)\r\n")
        rawBody.append("Content-Type: \(mimeType)\r\n\r\n")
        rawBody.append(data)
        rawBody.append("\r\n")
        rawBody.append("--\(boundary)--\r\n")

        self.headers = ["Content-Type": "multipart/related; boundary=\(boundary)"]
        self.rawBody = rawBody
    }
}
