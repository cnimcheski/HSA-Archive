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
    @InjectedObservable(\.receiptRepository) private var receiptRepository
    @Bindable private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .navigationTitle("Receipts")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
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
    
    var receiptsContent: some View {
        ForEach(viewModel.receiptSections) { section in
            Section {
                ForEach(section.receipts) { receipt in
                    ReceiptPreview(receipt: receipt) {
                        // TODO: - Add an action...
                    }
                    .redactedShimmer(isShimmering: receiptRepository.isLoading)
                }
            } header: {
                Text(section.title)
                    .redactedShimmer(isShimmering: receiptRepository.isLoading)
            }
        }
    }
    
    @ViewBuilder
    var overlayContent: some View {
        if receiptRepository.hasError {
            DataLoadingErrorView()
        } else if !receiptRepository.isLoading && receiptRepository.sortedReceipts.isEmpty {
            NoReceiptsView()
        } else if viewModel.receiptSections.isEmpty {
            // TODO: - As filters are added, this may need to change
            // TODO: - There also seems to be an error when the search text is cleared
            ContentUnavailableView.search
        }
    }
    
    var invalidReceiptsButton: some View {
        InvalidReceiptsButton(
            count: receiptRepository.failedRows.count,
            action: viewModel.showInvalidReceipts
        )
    }
    
    var filtersButton: some View {
        Button {
            viewModel.showFiltersView()
        } label: {
            Label("Filter and sort", systemImage: "line.3.horizontal.decrease")
        }
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
        ReceiptsView(viewModel: .init())
    }
}
