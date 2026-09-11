//
//  ReceiptReviewView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/19/26.
//

import Dialogs
import SwiftUI

struct ReceiptReviewView: View {
    @Bindable private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .navigationTitle("Review Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    saveButton
                }
            }
            .interactiveDismissDisabled()
            .animation(.easeInOut, value: viewModel.displayedReceipt.isReimbursed.wrappedValue)
            .alert(viewModel: $viewModel.alertViewModel)
            .onFirstTask(viewModel.onAppear)
    }
}

// MARK: - Private Views

private extension ReceiptReviewView {
    var content: some View {
        List {
            previewImage
            errorBanner
            merchantField
            descriptionField
            amountField
            transactionDatePicker
            categoryMenu
            isReimbursedToggle
            if viewModel.displayedReceipt.isReimbursed.wrappedValue {
                reimbursementDatePicker
            }
            notesField
        }
        .listStyle(.plain)
    }
    
    var previewImage: some View {
        Button(action: viewModel.showFullImageView) {
            PreviewImage(imageState: viewModel.imageState)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    var errorBanner: some View {
        if let errorBannerViewModel = viewModel.errorBannerViewModel {
            ErrorBanner(viewModel: errorBannerViewModel)
        }
    }
    
    var merchantField: some View {
        AppTextField(
            "Merchant",
            placeholder: "Merchant name...",
            text: viewModel.displayedReceipt.merchant,
            isLoading: viewModel.isExtractingReceiptDetails
        )
    }
    
    var descriptionField: some View {
        AppTextField(
            "Description",
            placeholder: "Brief description...",
            text: viewModel.displayedReceipt.description,
            isLoading: viewModel.isExtractingReceiptDetails
        )
    }
    
    var amountField: some View {
        AppTextField(
            "Amount",
            placeholder: "$0.00",
            value: viewModel.displayedReceipt.amount,
            format: AppFormatStyle.Currency.current,
            isLoading: viewModel.isExtractingReceiptDetails
        )
        .keyboardType(.decimalPad)
    }
    
    var transactionDatePicker: some View {
        AppDatePicker(
            "Transaction Date",
            selection: viewModel.displayedReceipt.transactionDate,
            isLoading: viewModel.isExtractingReceiptDetails
        )
    }
    
    var categoryMenu: some View {
        SearchableMenu(
            AppConstants.categoryPrompt,
            selection: viewModel.displayedReceipt.category.wrappedValue.selection,
            isLoading: viewModel.isExtractingReceiptDetails,
            action: viewModel.showCategorySelectionView
        )
    }
    
    var isReimbursedToggle: some View {
        AppToggle(
            "Reimbursed",
            isOn: viewModel.displayedReceipt.isReimbursed,
            isLoading: viewModel.isExtractingReceiptDetails
        )
    }
    
    var reimbursementDatePicker: some View {
        AppDatePicker(
            "Reimbursed On",
            selection: viewModel.displayedReceipt.reimbursementDate ?? Date.now,
            isLoading: viewModel.isExtractingReceiptDetails
        )
    }
    
    var notesField: some View {
        AppTextField(
            "Notes",
            placeholder: "Add notes...",
            text: viewModel.displayedReceipt.notes,
            isLoading: viewModel.isExtractingReceiptDetails
        )
    }
    
    var cancelButton: some View {
        Button("Cancel", systemImage: "xmark") {
            viewModel.dismiss()
        }
    }
    
    var saveButton: some View {
        Button("Save", systemImage: "checkmark") {
            Task {
                await viewModel.save()
            }
        }
        .disabled(viewModel.isSaveDisabled)
    }
}

// MARK: - Previews

#Preview {
    Text("Placeholder")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                ReceiptReviewView(
                    viewModel: .init(
                        uiImage: .init(systemName: "person.crop.rectangle.fill")!
                    )
                )
            }
        }
}
