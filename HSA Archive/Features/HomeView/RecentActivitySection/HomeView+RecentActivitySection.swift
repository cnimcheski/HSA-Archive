//
//  HomeView+RecentActivitySection.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

extension HomeView {
    struct RecentActivitySection: View {
        private let recentReceipts: [Receipt]
        private let showViewAllButton: Bool
        private let onReceiptSelected: (Receipt) -> Void
        
        init(
            recentReceipts: [Receipt],
            showViewAllButton: Bool,
            onReceiptSelected: @escaping (Receipt) -> Void
        ) {
            self.recentReceipts = recentReceipts
            self.showViewAllButton = showViewAllButton
            self.onReceiptSelected = onReceiptSelected
        }
        
        var body: some View {
            Section {
                receiptPreviewList
                if showViewAllButton {
                    viewAllReceiptsButton
                }
            } header: {
                Text("RECENT ACTIVITY")
            }
        }
    }
}

// MARK: - Private Views

private extension HomeView.RecentActivitySection {
    var receiptPreviewList: some View {
        ForEach(recentReceipts) { receipt in
            ReceiptPreview(receipt: receipt) {
                onReceiptSelected(receipt)
            }
        }
    }
    
    var viewAllReceiptsButton: some View {
        Button("View all receipts") {
            // TODO: - Fill this in...
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .center)
        .buttonStyle(.plain)
        .listRowSeparator(.hidden, edges: .bottom)
    }
}

// MARK: - Previews

#Preview {
    HomeView.RecentActivitySection(
        recentReceipts: [.mock, .mock, .mock],
        showViewAllButton: true
    ) { receipt in
        // Do something with the selected receipt
    }
}
