//
//  AppSession.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/30/26.
//

import FactoryKit

/// Manages app level state and data in response to the user's authentication state.
final class AppSession {
    private let googleAuthService = Container.shared.googleAuthService()
    private let receiptRepository = Container.shared.receiptRepository()
    private let userDefaultsManager = Container.shared.userDefaultsManager()
    
    private var authObservationTask: Task<Void, Never>?
    
    init() {
        observeAuthChanges()
    }
}

// MARK: - Private Methods

private extension AppSession {
    /// Observes auth state changes and updates the app session accordingly.
    func observeAuthChanges() {
        authObservationTask = Task {
            for await isSignedIn in googleAuthService.isSignedInValues {
                await handleAuthChange(isSignedIn)
            }
        }
    }
    
    /// Handles authentication state changes by loading or clearing the user's app data.
    func handleAuthChange(_ isSignedIn: Bool) async {
        if isSignedIn {
            await loadUserData()
        } else {
            clearUserData()
        }
    }
    
    /// Loads the authenticated user's data into the app session.
    func loadUserData() async {
        await receiptRepository.loadReceipts()
    }
    
    /// Clears the authenticated user's data from the app session.
    func clearUserData() {
        // TODO: - Is there anything else that needs to happen when user becomes unauthenticated?
        receiptRepository.clear()
        userDefaultsManager.clearSpreadsheetID()
    }
}
