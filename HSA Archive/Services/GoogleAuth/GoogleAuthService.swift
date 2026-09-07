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
    
    private let isSignedInState = CurrentValueAsyncStream(true)
    
    var isSignedIn: Bool {
        isSignedInState.value
    }
    
    var isSignedInValues: AsyncStream<Bool> {
        isSignedInState.values
    }
    
    private var currentUser: GIDGoogleUser? {
        get async {
            if let restorationTask { _ = try? await restorationTask.value }
            return GIDSignIn.sharedInstance.currentUser
        }
    }
    
    private var restorationTask: Task<GIDGoogleUser?, Error>?
    
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
            try await GIDSignIn.sharedInstance.restorePreviousSignIn()
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
            isSignedInState.send(true)
            return response
        } catch let error as GIDSignInError where error.code == .canceled {
            return nil
        } catch {
            handleSignInError()
            return nil
        }
    }

    // TODO: - Use this sign out method in the profile tab Sign Out button
    @MainActor
    func signOut() {
        isSignedInState.send(false)
        GIDSignIn.sharedInstance.signOut()
    }
}

// MARK: - Private Methods

nonisolated private extension GoogleAuthService {
    @MainActor
    func handleSignInError() {
        ToastManager.shared.show(DefaultToastType.googleSignInFailed)
    }
}

// MARK: - APIAuthenticator Conformance

nonisolated extension GoogleAuthService: APIAuthenticator {
    func getAccessToken() async throws -> String {
        guard let currentUser = await currentUser else { throw URLError(.userAuthenticationRequired) }
        return try await currentUser.refreshTokensIfNeeded().accessToken.tokenString
    }
    
    func refreshAccessToken() async throws {
        guard let currentUser = await currentUser else { throw URLError(.userAuthenticationRequired) }
        try await currentUser.refreshTokensIfNeeded()
    }
}
