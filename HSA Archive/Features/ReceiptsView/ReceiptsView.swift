//
//  ReceiptsView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import Dialogs
import FactoryKit
import SwiftUI

struct ReceiptsView: View {
    @InjectedObservable(\.googleAuthService) private var googleAuthService
    @InjectedObservable(\.receiptRepository) private var receiptRepository
    @Bindable private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .navigationTitle("Receipts")
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !receiptRepository.failedRows.isEmpty {
                        invalidReceiptsButton
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    filtersButton
                    uploadReceiptButton
                }
            }
            .refreshable(action: receiptRepository.refreshReceipts)
    }
}

// MARK: - Private Views

private extension ReceiptsView {
    var content: some View {
        List {
            receiptsContent
        }
        .listStyle(.plain)
        .overlay { overlayContent }
    }
    
    @ViewBuilder
    var receiptsContent: some View {
        if viewModel.filters.sortingOption.groupsByMonth {
            groupedReceipts
        } else {
            flatReceipts
        }
    }
    
    var groupedReceipts: some View {
        ForEach(viewModel.receiptSections) { section in
            Section {
                ForEach(section.receipts) { receipt in
                    receiptRow(receipt)
                }
            } header: {
                Text(section.title)
                    .redactedShimmer(isShimmering: receiptRepository.isLoading)
            }
        }
    }
    
    var flatReceipts: some View {
        ForEach(viewModel.filteredReceipts) { receipt in
            receiptRow(receipt)
        }
    }
    
    func receiptRow(_ receipt: Receipt) -> some View {
        ReceiptPreview(receipt: receipt) {
            viewModel.showReceiptReview(receipt)
        }
        .redactedShimmer(isShimmering: receiptRepository.isLoading)
    }
    
    @ViewBuilder
    var overlayContent: some View {
        if receiptRepository.hasError {
            DataLoadingErrorView()
        } else if !receiptRepository.isLoading && receiptRepository.sortedReceipts.isEmpty {
            NoReceiptsView()
        } else if viewModel.receiptSections.isEmpty {
            filteredReceiptsEmptyView
        }
    }
    
    @ViewBuilder
    var filteredReceiptsEmptyView: some View {
        if viewModel.searchText.isEmpty {
            ContentUnavailableView(
                "No Receipts Found",
                systemImage: "line.3.horizontal.decrease.circle",
                description: Text("Try adjusting your filters.")
            )
        } else {
            ContentUnavailableView.search(text: viewModel.searchText)
        }
    }
    
    var invalidReceiptsButton: some View {
        InvalidReceiptsButton(
            count: receiptRepository.failedRows.count,
            action: viewModel.showInvalidReceipts
        )
    }
    
    @ViewBuilder
    var filtersButton: some View {
        if googleAuthService.isSignedIn {
            Button(
                "Filter and sort",
                systemImage: "line.3.horizontal.decrease",
                action: viewModel.showFiltersView
            )
            .adaptiveBadge(viewModel.filters.activeFilterCount)
        }
    }
    
    var uploadReceiptButton: some View {
        Button(
            "Scan a receipt",
            systemImage: "plus",
            action: viewModel.showUploadReceiptConfirmationDialog
        )
        .confirmationDialog(viewModel: $viewModel.confirmationDialogViewModel)
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        ReceiptsView(viewModel: .init())
    }
}
