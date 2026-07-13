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
    var withBackgroundOpacity: some ShapeStyle { opacity(0.1) }
}
