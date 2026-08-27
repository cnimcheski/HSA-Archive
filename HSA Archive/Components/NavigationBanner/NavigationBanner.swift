//
//  NavigationBanner.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/25/26.
//

import SwiftUI

struct NavigationBanner<C: ShapeStyle>: View {
    private let title: LocalizedStringKey
    private let message: LocalizedStringKey
    private let iconName: String
    private let tint: C
    private let action: () -> Void
    
    init(
        _ title: LocalizedStringKey,
        message: LocalizedStringKey,
        iconName: String,
        tint: C = .accent,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.iconName = iconName
        self.tint = tint
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.medium) {
                leadingIcon
                detailText
                Spacer()
                navigationIndicator
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .defaultCardStyle(backgroundColor: tint.withBackgroundOpacity)
        .listRowSeparator(.hidden)
    }
}

// MARK: - Private Views

private extension NavigationBanner {
    var leadingIcon: some View {
        Image(systemName: iconName)
            .foregroundStyle(tint)
            .padding(Theme.Spacing.medium)
            .background(.background)
            .clipShape(.circle)
    }

    var detailText: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xxSmall) {
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    var navigationIndicator: some View {
        Image(systemName: "chevron.right")
            .foregroundStyle(tint)
    }
}

// MARK: - Previews

#Preview {
    NavigationBanner(
        "2 new eligible purchases found",
        message: "Tap to sync Target & Amazon",
        iconName: "arrow.2.circlepath"
    ) {
        // Do something when the banner is tapped
    }
}
