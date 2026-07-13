//
//  DefaultCardStyle.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

extension View {
    /// Defines a reusable default card styling throughout the app.
    func defaultCardStyle<C>(
        backgroundColor: C = .background,
        padding: CGFloat = Theme.Spacing.large
    ) -> some View where C: ShapeStyle {
        modifier(DefaultCardStyleModifier(backgroundColor: backgroundColor, padding: padding))
    }
}

struct DefaultCardStyleModifier<C: ShapeStyle>: ViewModifier {
    private let backgroundColor: C
    private let padding: CGFloat
    
    init(backgroundColor: C, padding: CGFloat) {
        self.backgroundColor = backgroundColor
        self.padding = padding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                    .fill(backgroundColor)
                    .shadow(color: .secondary.opacity(0.5), radius: 2)
            )
    }
}
