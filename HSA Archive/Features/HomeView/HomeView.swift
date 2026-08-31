//
//  HomeView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import Dialogs
import FactoryKit
import SwiftUI

struct HomeView: View {
    @InjectedObservable(\.googleAuthService) private var googleAuthService
    @InjectedObservable(\.receiptRepository) private var receiptRepository
    @Bindable private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .navigationTitle("HSA Archive")
            .toolbar { uploadReceiptButton }
            .refreshable(action: receiptRepository.refreshReceipts)
    }
}

// MARK: - Private Views

private extension HomeView {
    @ViewBuilder
    var content: some View {
        if receiptRepository.hasError {
            errorView
        } else {
            listContent
        }
    }
    
    var errorView: some View {
        ScrollView {
            ContentUnavailableView(
                "Something Went Wrong",
                systemImage: "exclamationmark.triangle",
                description: Text("There was an error loading your data. Please try again.")
            )
            .containerRelativeFrame(.vertical)
        }
    }
    
    var listContent: some View {
        List {
            Overview(receipts: receiptRepository.sortedReceipts, isLoading: receiptRepository.isLoading)
            if !googleAuthService.isSignedIn {
                signInBanner
            }
            if viewModel.failedRows.count > 0 {
                invalidReceiptsBanner
            }
            recentActivitySection
        }
        .listStyle(.plain)
    }
    
    var signInBanner: some View {
        NavigationBanner(
            "Browsing as a guest",
            message: "Sign in to save receipts and see your balance",
            iconName: "person",
            action: viewModel.showSignInView
        )
    }
    
    var invalidReceiptsBanner: some View {
        NavigationBanner(
            "^[\(viewModel.failedRows.count) receipt row](inflect: true) couldn't be read",
            message: "Tap to review the failed rows",
            iconName: "exclamationmark.triangle",
            tint: .red,
            action: viewModel.showInvalidReceipts
        )
    }
    
    var recentActivitySection: some View {
        RecentActivitySection(
            recentReceipts: viewModel.recentReceipts,
            showViewAllButton: viewModel.shouldShowViewAllReceiptsButton,
            isLoading: receiptRepository.isLoading,
            onReceiptSelected: viewModel.onReceiptSelected
        )
    }
    
    var uploadReceiptButton: some View {
        Button {
            viewModel.showUploadReceiptConfirmationDialog()
        } label: {
            Label("Scan a receipt", systemImage: "plus")
        }
        .confirmationDialog(viewModel: $viewModel.confirmationDialogViewModel)
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        HomeView(viewModel: .init())
    }
}
