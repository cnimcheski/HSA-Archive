//
//  CreateFolderEndpoint+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/21/26.
//

nonisolated extension CreateFolderEndpoint {
    struct Response: Decodable {
        let id: String
    }
}
