//
//  ReceiptPreview.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

struct ReceiptPreview: View {
    // TODO: - Maybe add like a Category enum or something that changes the systemImage as well
    // TODO: - Add inputs for all hardcoded things
    private let merchant: String
    
    init(merchant: String) {
        self.merchant = merchant
    }
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            leadingImage
            descriptionView
            Spacer()
            amountStatusView
        }
        .defaultCardStyle()
    }
}

// MARK: - Private Views

private extension ReceiptPreview {
    var leadingImage: some View {
        Image(systemName: "receipt")
            .foregroundStyle(.accent)
            .defaultCardStyle(backgroundColor: .accentBackground)
    }
    
    var descriptionView: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xSmall) {
            Text(merchant)
                .font(.headline)
            
            DotSeparator(
                leftText: "July 8",
                rightText: "Prescription"
            )
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
    ReceiptPreview(merchant: "Target")
}
