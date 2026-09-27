//
//  GoogleAuthService.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/11/26.
//

import FactoryKit
import FirebaseCore
import GoogleSignIn
import Networking
import Toast

@Observable
nonisolated final class GoogleAuthService {
    private let userDefaultsManager = Container.shared.userDefaultsManager()
    
    /// Covers Drive + Sheets API access only for files creates by this app or the user opens with the app.
    private let scopes = ["https://www.googleapis.com/auth/drive.file"]
    
    private let authStateStream = CurrentValueAsyncStream(AuthState.restoring)
    
    var authState: AuthState {
        authStateStream.value
    }
    
    var authStateValues: AsyncStream<AuthState> {
        authStateStream.values
    }
    
    private var restorationTask: Task<GIDGoogleUser?, Never>?
    
    /// Configures Google Sign In and its App Check provider.
    func configure() {
        #if targetEnvironment(simulator)
        if let apiKey = FirebaseApp.app()?.options.apiKey {
            GIDSignIn.sharedInstance.configureDebugProvider(withAPIKey: apiKey)
        }
        #else
        GIDSignIn.sharedInstance.configure()
        #endif
    }
    
    /// Restores the user's previous Google Sign In session.
    func restorePreviousSignIn() {
        guard restorationTask == nil else { return }
        restorationTask = Task {
            guard let currentUser = try? await GIDSignIn.sharedInstance.restorePreviousSignIn() else {
                authStateStream.send(.signedOut)
                return nil
            }
            authStateStream.send(.signedIn(currentUser))
            return currentUser
        }
    }

    /// Attempts to sign the user in with Google and returns the `GIDSignInResult` if possible, nil if failed.
    @MainActor
    func signIn() async -> GIDSignInResult? {
        do {
            guard let viewController = UIApplication.shared.getTopViewController() else {
                handleSignInError()
                return nil
            }
            let response = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: viewController,
                hint: nil,
                additionalScopes: scopes
            )
            authStateStream.send(.signedIn(response.user))
            return response
        } catch let error as GIDSignInError where error.code == .canceled {
            return nil
        } catch {
            handleSignInError()
            return nil
        }
    }

    @MainActor
    func signOut() {
        authStateStream.send(.signedOut)
        GIDSignIn.sharedInstance.signOut()
    }
}

// MARK: - Private Methods

nonisolated private extension GoogleAuthService {
    /// Returns the authenticated user after waiting for sign-in restoration to complete.
    func authenticatedUser() async throws -> GIDGoogleUser {
        if let restorationTask { _ = await restorationTask.value }
        guard let currentUser = authState.currentUser else { throw URLError(.userAuthenticationRequired) }
        return currentUser
    }
    
    @MainActor
    func handleSignInError() {
        ToastManager.shared.show(DefaultToastType.googleSignInFailed)
    }
}

// MARK: - APIAuthenticator Conformance

nonisolated extension GoogleAuthService: APIAuthenticator {
    func getAccessToken() async throws -> String {
        let currentUser = try await authenticatedUser()
        return try await currentUser.refreshTokensIfNeeded().accessToken.tokenString
    }
    
    func refreshAccessToken() async throws {
        let currentUser = try await authenticatedUser()
        try await currentUser.refreshTokensIfNeeded()
    }
}
