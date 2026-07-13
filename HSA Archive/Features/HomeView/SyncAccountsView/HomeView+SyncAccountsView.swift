//
//  HomeView+SyncAccountsView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

extension HomeView {
    struct SyncAccountsView: View {
        var body: some View {
            HStack(spacing: Theme.Spacing.medium) {
                syncImage
                calloutText
                Spacer()
                chevronImage
            }
            .defaultCardStyle(backgroundColor: .accentBackground)
        }
    }
}

// MARK: - Private Views

private extension HomeView.SyncAccountsView {
    var syncImage: some View {
        Image(systemName: "arrow.2.circlepath")
            .foregroundStyle(.accent)
            .padding(Theme.Spacing.medium)
            .background(.background)
            .clipShape(.circle)
    }
    
    var calloutText: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xxSmall) {
            Text("2 new eligible purchases found")
                .font(.headline)
            DotSeparator(
                leftText: "Target & Amazon",
                rightText: "tap to sync"
            )
            .foregroundStyle(.secondary)
        }
    }
    
    var chevronImage: some View {
        Image(systemName: "chevron.right")
            .foregroundStyle(.accent)
    }
}

// MARK: - Previews

#Preview {
    HomeView.SyncAccountsView()
}
