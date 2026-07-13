//
//  Badge.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

struct Badge: View {
    private let content: String
    private let color: Color
    
    init(
        _ content: String,
        color: Color = .brandSecondary
    ) {
        self.content = content
        self.color = color
    }
    
    var body: some View {
        Text(content)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundStyle(color)
            .padding(.vertical, Theme.Spacing.xxSmall)
            .padding(.horizontal, Theme.Spacing.small)
            .background(color.withBackgroundOpacity)
            .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
    }
}

// MARK: - Previews

#Preview {
    Badge("Available")
}
