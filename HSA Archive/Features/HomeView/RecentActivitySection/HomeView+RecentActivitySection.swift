//
//  HomeView+RecentActivitySection.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

extension HomeView {
    struct RecentActivitySection: View {
        // TODO: - This is hardcoded temporarily
        let receipts = [Receipt.mock, Receipt.mock, Receipt.mock]
        
        var body: some View {
            Section {
                receiptPreviewList
                viewAllReceiptsButton
            } header: {
                Text("RECENT ACTIVITY")
            }
        }
    }
}

// MARK: - Private Views

private extension HomeView.RecentActivitySection {
    var receiptPreviewList: some View {
        ForEach(receipts) { receipt in
            ReceiptPreview(receipt: receipt)
        }
    }
    
    var viewAllReceiptsButton: some View {
        Button("View all receipts") {
            // TODO: - Fill this in...
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowSeparator(.hidden, edges: .bottom)
    }
}

// MARK: - Previews

#Preview {
    HomeView.RecentActivitySection()
}
