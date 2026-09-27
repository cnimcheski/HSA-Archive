//
//  ShapeStyle+Colors.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/12/26.
//

import SwiftUI

/// Provides shared theme coloring throughout the app.
extension ShapeStyle where Self == Color {
    static var accentBackground: some ShapeStyle { .accent.withBackgroundOpacity }
    static var brandSecondaryBackground: some ShapeStyle { .brandSecondary.withBackgroundOpacity }
}

// MARK: - WithBackgroundOpacity

extension ShapeStyle {
    /// Shared background opacity theming throughout the app.
    var withBackgroundOpacity: some ShapeStyle { BackgroundOpacityShapeStyle(base: self) }
}

// MARK: - BackgroundOpacityShapeStyle

/// A shape style that applies a color-scheme-dependent opacity to a base style.
private struct BackgroundOpacityShapeStyle<Base: ShapeStyle>: ShapeStyle {
    private let base: Base
    
    init(base: Base) {
        self.base = base
    }

    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        base.opacity(environment.colorScheme == .light ? 0.1 : 0.2)
    }
}
