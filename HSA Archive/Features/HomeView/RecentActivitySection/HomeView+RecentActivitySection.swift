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
        private let isLoading: Bool
        private let viewAllReceipts: () -> Void
        private let onReceiptSelected: (Receipt) -> Void
        
        init(
            recentReceipts: [Receipt],
            showViewAllButton: Bool,
            isLoading: Bool,
            viewAllReceipts: @escaping () -> Void,
            onReceiptSelected: @escaping (Receipt) -> Void
        ) {
            self.recentReceipts = recentReceipts
            self.showViewAllButton = showViewAllButton
            self.isLoading = isLoading
            self.viewAllReceipts = viewAllReceipts
            self.onReceiptSelected = onReceiptSelected
        }
        
        var body: some View {
            Section {
                if recentReceipts.isEmpty {
                    noRecentReceiptsView
                } else {
                    receiptPreviewList
                }
                if showViewAllButton {
                    viewAllReceiptsButton
                }
            } header: {
                Text("Recent Activity")
            }
        }
    }
}

// MARK: - Private Views

private extension HomeView.RecentActivitySection {
    var noRecentReceiptsView: some View {
        NoReceiptsView()
            .listRowSeparator(.hidden)
    }
    
    var receiptPreviewList: some View {
        ForEach(recentReceipts) { receipt in
            ReceiptPreview(receipt: receipt, isLoading: isLoading) {
                onReceiptSelected(receipt)
            }
        }
    }
    
    var viewAllReceiptsButton: some View {
        Button("View all receipts", action: viewAllReceipts)
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .buttonStyle(.plain)
            .listRowSeparator(.hidden, edges: .bottom)
    }
}

// MARK: - Previews

#Preview {
    let recentReceiptMocks = [
        Receipt.mock(),
        Receipt.mock(amount: 22.45, reimbursementDate: .now),
        Receipt.mock(merchant: "Walmart", category: .laboratory)
    ]
    List {
        HomeView.RecentActivitySection(
            recentReceipts: recentReceiptMocks,
            showViewAllButton: true,
            isLoading: false,
            viewAllReceipts: {
                // Do something when view all receipts button is pressed
            },
            onReceiptSelected: { receipt in
                // Do something with the selected receipt
            }
        )
        HomeView.RecentActivitySection(
            recentReceipts: recentReceiptMocks,
            showViewAllButton: true,
            isLoading: true,
            viewAllReceipts: {
                // Do something when view all receipts button is pressed
            },
            onReceiptSelected: { receipt in
                // Do something with the selected receipt
            }
        )
    }
    .listStyle(.plain)
}
