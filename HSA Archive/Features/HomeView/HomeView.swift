//
//  HomeView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import Dialogs
import SwiftUI

struct HomeView: View {
    @Bindable private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .navigationTitle("HSA Archive")
            .toolbar { uploadReceiptButton }
            .onFirstTask(viewModel.fetchReceipts)
    }
}

// MARK: - Private Views

private extension HomeView {
    var content: some View {
        List {
            Overview()
            if viewModel.failedRows.count > 0 {
                invalidReceiptsBanner
            }
            recentActivitySection
        }
        .listStyle(.plain)
    }
    
    var invalidReceiptsBanner: some View {
        NavigationBanner(
            "^[\(viewModel.failedRows.count) receipt row](inflect: true) couldn't be read",
            message: "Tap to review the failed rows",
            iconName: "exclamationmark.triangle",
            tint: .red,
            action: viewModel.showInvalidReceipts
        )
        .listRowSeparator(.hidden)
    }
    
    var recentActivitySection: some View {
        RecentActivitySection(
            recentReceipts: viewModel.recentReceipts,
            showViewAllButton: viewModel.shouldShowViewAllReceiptsButton,
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
