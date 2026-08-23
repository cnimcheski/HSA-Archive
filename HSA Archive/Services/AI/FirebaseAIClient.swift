//
//  FirebaseAIClient.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/23/26.
//

import FactoryKit
import FirebaseAI
import Foundation
import Toast

nonisolated final class FirebaseAIClient: AIClient {
    private let remoteConfigClient = Container.shared.remoteConfigClient()
    
    func generate<Request: AIRequest>(
        _ request: Request
    ) async throws(GeminiError) -> Request.Response? {
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
            guard let geminiError = map(generateContentError: error) else { return nil }
            throw geminiError
        } catch {
            guard let geminiError = map(genericError: error) else { return nil }
            throw geminiError
        }
    }
}

// MARK: - Private Methods

private extension FirebaseAIClient {
    func map(generateContentError: GenerateContentError) -> GeminiError? {
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
    
    func map(genericError: Error) -> GeminiError? {
        let nsError = genericError as NSError
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            ToastManager.shared.show(DefaultToastType.offline)
            return nil
        case 400,
            403,
            404:
            return .configuration
        case 429:
            return .rateLimited
        case 500...599:
            ToastManager.shared.show(DefaultToastType.serverUnavailable)
            return nil
        default:
            return .unknown
        }
    }
}
