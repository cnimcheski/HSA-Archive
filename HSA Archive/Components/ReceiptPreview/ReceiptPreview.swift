//
//  ReceiptPreview.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

struct ReceiptPreview: View {
    private let receipt: Receipt
    private let action: () -> Void
    
    init(receipt: Receipt, action: @escaping () -> Void) {
        self.receipt = receipt
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.medium) {
                leadingImage
                descriptionView
                Spacer()
                amountStatusView
            }
        }
    }
}

// MARK: - Private Views

private extension ReceiptPreview {
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
                Text(receipt.transactionDate.formatted(.dateTime.month(.abbreviated).day()))
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
            Badge("Reimbursed", color: .accentColor)
        } else {
            Badge("Available")
        }
    }
}

// MARK: - Previews

#Preview {
    List {
        ReceiptPreview(receipt: .mock()) {
            // Do something when the receipt is tapped
        }
    }
    .listStyle(.plain)
}
