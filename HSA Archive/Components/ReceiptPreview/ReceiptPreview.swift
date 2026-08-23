//
//  ReceiptPreview.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

struct ReceiptPreview: View {
    private let receipt: Receipt
    
    init(receipt: Receipt) {
        self.receipt = receipt
    }
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            leadingImage
            descriptionView
            Spacer()
            amountStatusView
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
            Text(64.20, format: AppFormatStyle.Currency.current)
                .font(.headline)
            Badge("Available")
        }
    }
}

// MARK: - Previews

#Preview {
    ReceiptPreview(receipt: .mock)
}
