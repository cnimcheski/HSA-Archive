//
//  AIClient.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/22/26.
//

import FirebaseAI

protocol AIClient {
    func generate<Request: AIRequest>(
        _ request: Request
    ) async throws(GeminiError) -> Request.Response
}
