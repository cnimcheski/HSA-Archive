//
//  GeminiError.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/31/26.
//

/// Defines all the Error's thrown by Gemini that we want to be able to handle.
enum GeminiError: Error {
    case network
    case rateLimited
    case serverError
    case invalidResponse
    case configuration
    case blockedBySafety
    case unknown
}
