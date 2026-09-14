//
//  Badge.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

struct Badge<S: ShapeStyle>: View {
    private let content: String
    private let color: S
    private let isLoading: Bool
    
    init(
        _ content: String,
        color: S = .brandSecondary,
        isLoading: Bool
    ) {
        self.content = content
        self.color = color
        self.isLoading = isLoading
    }
    
    var body: some View {
        Text(content)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(isLoading ? AnyShapeStyle(.primary) : AnyShapeStyle(color))
            .padding(.vertical, Theme.Spacing.xxSmall)
            .padding(.horizontal, Theme.Spacing.small)
            .background(isLoading ? AnyShapeStyle(.secondary.withBackgroundOpacity) : AnyShapeStyle(color.withBackgroundOpacity))
            .clipShape(.rect(cornerRadius: Theme.CornerRadius.large))
    }
}

// MARK: - Previews

#Preview {
    Badge("Available", isLoading: false)
    Badge("Available", isLoading: true)
}
