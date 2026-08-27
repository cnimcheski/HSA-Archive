//
//  GoogleAuthService.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/11/26.
//

import FactoryKit
import GoogleSignIn
import Networking
import Toast

nonisolated final class GoogleAuthService {
    private let userDefaultsManager = Container.shared.userDefaultsManager()
    
    /// Covers Drive + Sheets API access only for files creates by this app or the user opens with the app.
    private let scopes = ["https://www.googleapis.com/auth/drive.file"]

    var isSignedIn: Bool {
        get async {
            await currentUser != nil
        }
    }
    
    private var currentUser: GIDGoogleUser? {
        get async {
            guard let restorationTask else { return GIDSignIn.sharedInstance.currentUser }
            return try? await restorationTask.value
        }
    }
    
    private var restorationTask: Task<GIDGoogleUser?, Error>?
    
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
            return response
        } catch let error as GIDSignInError where error.code == .canceled {
            return nil
        } catch {
            handleSignInError()
            return nil
        }
    }

    // TODO: - Use this sign out method in the profile tab Sign Out button
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        userDefaultsManager.clearSpreadsheetID()
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
