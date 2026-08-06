//
//  AIRequest.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/26/26.
//

import FirebaseAI

protocol AIRequest {
    associatedtype Response: Decodable, AIResponse
    
    var systemInstruction: String { get }
    var prompt: String { get }
    var generationConfig: GenerationConfig { get }
}

extension AIRequest {
    var generationConfig: GenerationConfig {
        .init(
            responseMIMEType: "application/json",
            responseSchema: Response.schema
        )
    }
}
