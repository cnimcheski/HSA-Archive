//
//  ListFilesEndpoint+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/17/26.
//

nonisolated extension ListFilesEndpoint {
    struct Response: Decodable {
        let nextPageToken: String?
        let files: [DriveFile]
    }
}

// MARK: - DriveFile

nonisolated extension ListFilesEndpoint.Response {
    struct DriveFile: Decodable {
        let id: String
    }
}
