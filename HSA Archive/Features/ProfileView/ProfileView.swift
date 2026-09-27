//
//  ProfileView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/13/26.
//

import Dialogs
import FactoryKit
import GoogleSignIn
import SwiftUI

struct ProfileView: View {
    @Bindable private var viewModel: ViewModel
    @Environment(\.openURL) private var openURL
    @InjectedObservable(\.googleAuthService) private var googleAuthService
    @InjectedObservable(\.userDefaultsManager) private var userDefaultsManager
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .navigationTitle("Profile")
            .alert(viewModel: $viewModel.alertViewModel)
    }
}

// MARK: - Private Views

private extension ProfileView {
    var content: some View {
        List {
            accountHeader
            preferencesSection
            legalSection
            if googleAuthService.authState.isSignedIn {
                archiveSection
                accountSection
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Private Views

private extension ProfileView {
    var accountHeader: some View {
        AccountHeader(
            profile: googleAuthService.authState.currentUser?.profile,
            onSignIn: viewModel.showSignInView
        )
    }
    
    var preferencesSection: some View {
        Section {
            AppToggle(
                "AI receipt extraction",
                isOn: $userDefaultsManager.isAIReceiptExtractionEnabled,
                foregroundStyle: .primary
            )
        } header: {
            Text("Preferences")
        }
    }
    
    var legalSection: some View {
        Section {
            ListNavigationButton("Privacy policy", type: .externalLink) {
                // TODO: - Use openURL to push to web privacy policy
            }
            ListNavigationButton("Terms of use", type: .externalLink) {
                // TODO: - Use openURL to push to web terms of use
            }
        } header: {
            Text("Legal")
        }
    }
    
    var archiveSection: some View {
        Section {
            if let spreadsheetURL = viewModel.spreadsheetURL {
                ListNavigationButton("Open spreadsheet", type: .externalLink) {
                    openURL(spreadsheetURL)
                }
            }
            if let receiptsFolderURL = viewModel.receiptsFolderURL {
                ListNavigationButton("Open receipt folder", type: .externalLink) {
                    openURL(receiptsFolderURL)
                }
            }
            ListLoadingRow(
                title: "Export receipts",
                loadingTitle: "Exporting receipts...",
                isLoading: viewModel.isExportingReceipts
            ) {
                Task {
                    await viewModel.exportReceipts()
                }
            }
        } header: {
            Text("Archive")
        }
    }
    
    var accountSection: some View {
        Section {
            Button("Sign out", action: googleAuthService.signOut)
            ListLoadingRow(
                title: "Delete account",
                loadingTitle: "Deleting account...",
                role: .destructive,
                isLoading: viewModel.isDeletingAccount,
                action: viewModel.confirmDeleteAccount
            )
        } header: {
            Text("Account")
        }
        .disabled(viewModel.isDeletingAccount)
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        ProfileView(viewModel: .init())
    }
}
