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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    uploadReceiptButton
                }
                ToolbarItem(placement: .topBarLeading) {
                    if !receiptRepository.failedRows.isEmpty {
                        invalidReceiptsButton
                    }
                }
            }
            .refreshable(action: receiptRepository.refreshReceipts)
    }
}

// MARK: - Private Views

private extension HomeView {
    var content: some View {
        List {
            if !receiptRepository.hasError {
                Overview(receipts: receiptRepository.sortedReceipts, isLoading: receiptRepository.isLoading)
                if !googleAuthService.isSignedIn {
                    signInBanner
                }
                recentActivitySection
            }
        }
        .listStyle(.plain)
        .overlay {
            if receiptRepository.hasError {
                DataLoadingErrorView()
            }
        }
    }
    
    var signInBanner: some View {
        NavigationBanner(
            "Browsing as a guest",
            message: "Sign in to save receipts and see your balance",
            iconName: "person",
            action: viewModel.showSignInView
        )
    }
    
    var recentActivitySection: some View {
        RecentActivitySection(
            recentReceipts: viewModel.recentReceipts,
            showViewAllButton: viewModel.shouldShowViewAllReceiptsButton,
            isLoading: receiptRepository.isLoading,
            onReceiptSelected: viewModel.showReceiptReview
        )
    }
    
    var uploadReceiptButton: some View {
        Button(
            "Scan a receipt",
            systemImage: "plus",
            action: viewModel.showUploadReceiptConfirmationDialog
        )
        .confirmationDialog(viewModel: $viewModel.confirmationDialogViewModel)
    }
    
    var invalidReceiptsButton: some View {
        InvalidReceiptsButton(
            count: receiptRepository.failedRows.count,
            action: viewModel.showInvalidReceipts
        )
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        HomeView(viewModel: .init())
    }
}
