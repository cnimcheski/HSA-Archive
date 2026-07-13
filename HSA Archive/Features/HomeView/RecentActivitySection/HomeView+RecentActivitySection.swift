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
        let recentActivities = [
            "CVS Pharmacy",
            "Dr Alvarez",
            "Target"
        ]
        
        var body: some View {
            VStack(alignment: .leading, spacing: Theme.Spacing.small) {
                headerView
                recentActivityList
                viewAllReceiptsButton
            }
        }
    }
}

// MARK: - Private Views

private extension HomeView.RecentActivitySection {
    var headerView: some View {
        Text("RECENT ACTIVITY")
            .font(.headline)
            .foregroundStyle(.secondary)
    }
    
    var recentActivityList: some View {
        VStack(spacing: Theme.Spacing.medium) {
            ForEach(recentActivities, id: \.self) { merchant in
                ReceiptPreview(merchant: merchant)
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
    }
}

// MARK: - Previews

#Preview {
    HomeView.RecentActivitySection()
}
