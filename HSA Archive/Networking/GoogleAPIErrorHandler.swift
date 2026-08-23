//
//  GoogleAPIErrorHandler.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/14/26.
//

import Networking
import Toast

nonisolated struct GoogleAPIErrorHandler: APIErrorHandling {
    enum APIGlobalError: APIError {
        case permissionDenied
        case rateLimited
        
        var statusCode: Int {
            switch self {
            case .permissionDenied:
                403
            case .rateLimited:
                429
            }
        }
        
        var message: String? { nil }
    }
    
    func handleAPIGlobalError<T>(
        _ error: APIGlobalError,
        retry: @escaping () async throws -> T
    ) async throws -> T? where T: Decodable {
        switch error {
        case .permissionDenied:
            await ToastManager.shared.show(DefaultToastType.spreadsheetPermissionDenied)
        case .rateLimited:
            await ToastManager.shared.show(DefaultToastType.googleRateLimited)
        }
        return nil
    }
    
    func handleGlobalConnectionError<T: Decodable>(
        retry: @escaping () async throws -> T
    ) async throws -> T? {
        await ToastManager.shared.show(DefaultToastType.offline)
        return nil
    }
    
    func handleGlobalServerError<T: Decodable>(
        retry: @escaping () async throws -> T
    ) async throws -> T? {
        await ToastManager.shared.show(DefaultToastType.serverUnavailable)
        return nil
    }
}
