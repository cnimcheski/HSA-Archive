//
//  ReceiptPreview.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

struct ReceiptPreview: View {
    private let receipt: Receipt
    private let isLoading: Bool
    private let action: () -> Void
    
    init(receipt: Receipt, isLoading: Bool, action: @escaping () -> Void) {
        self.receipt = receipt
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        content
            .redactedShimmer(isShimmering: isLoading)
            .receiptSwipeActions(receipt: receipt)
    }
}

// MARK: - Private Views

private extension ReceiptPreview {
    var content: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.medium) {
                leadingImage
                descriptionView
                Spacer()
                amountStatusView
            }
        }
    }
    
    var leadingImage: some View {
        Image(systemName: receipt.category.systemImage)
            .foregroundStyle(.accent)
            .defaultCardStyle(backgroundColor: .accentBackground)
    }
    
    var descriptionView: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text(receipt.merchant)
                .font(.headline)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.xxSmall) {
                Text(receipt.transactionDate, format: .dateTime.month(.abbreviated).day())
                Text(receipt.category.rawValue)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
    
    var amountStatusView: some View {
        VStack(alignment: .trailing) {
            Text(receipt.amount, format: AppFormatStyle.Currency.current)
                .font(.headline)
            Spacer()
            reimbursementBadge
        }
    }
    
    @ViewBuilder
    var reimbursementBadge: some View {
        if receipt.isReimbursed {
            Badge("Reimbursed", color: .accent, isLoading: isLoading)
        } else {
            Badge("Available", isLoading: isLoading)
        }
    }
}

// MARK: - Previews

#Preview {
    List {
        ReceiptPreview(receipt: .mock(), isLoading: false) {
            // Do something when the receipt is tapped
        }
        ReceiptPreview(receipt: .mock(), isLoading: true) {
            // Do something when the receipt is tapped
        }
    }
    .listStyle(.plain)
}
