//
//  FirebaseAIClient.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/23/26.
//

import FactoryKit
import FirebaseAI
import Foundation

nonisolated final class FirebaseAIClient: AIClient {
    private let remoteConfigClient = Container.shared.remoteConfigClient()
    
    func generate<Request: AIRequest>(
        _ request: Request
    ) async throws(GeminiError) -> Request.Response {
        let model = FirebaseAI
            .firebaseAI(backend: .googleAI())
            .generativeModel(
                modelName: remoteConfigClient.modelName,
                generationConfig: request.generationConfig,
                systemInstruction: .init(role: "system", parts: request.systemInstruction)
            )
        do {
            let response = try await model.generateContent(request.prompt)
            guard let text = response.text else { throw GeminiError.invalidResponse }
            Debug.log("request: \(request), responseText: \(text)", category: .ai)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(.iso8601DateOnly)
            return try decoder.decode(Request.Response.self, from: Data(text.utf8))
        } catch GeminiError.invalidResponse {
            throw .invalidResponse
        } catch is DecodingError {
            throw .invalidResponse
        } catch let error as GenerateContentError {
            throw map(generateContentError: error)
        } catch {
            throw map(genericError: error)
        }
    }
}

// MARK: - Private Methods

private extension FirebaseAIClient {
    func map(generateContentError: GenerateContentError) -> GeminiError {
        switch generateContentError {
        case let .internalError(underlying):
            map(genericError: underlying)
        case let .promptImageContentError(underlying):
            map(genericError: underlying)
        case .promptBlocked:
            .blockedBySafety
        case .responseStoppedEarly:
            .invalidResponse
        }
    }
    
    func map(genericError: Error) -> GeminiError {
        let nsError = genericError as NSError
        return switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            .network
        case 400,
            403,
            404:
            .configuration
        case 429:
            .rateLimited
        case 500...599:
            .serverError
        default:
            .unknown
        }
    }
}
