//
//  AdaptiveBadge.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/5/26.
//

import SwiftUI

extension View {
    /// Adds a `ToolbarItem` badge using the native modifier when available, with a custom fallback for earlier iOS versions.
    /// - Note: The tint is provided here to ensure consistent styling across the native and custom badge implementations.
    /// - Note: A `nil` tint defaults to .accent before iOS 26 and leaves the system tint unchanged on iOS 26+.
    func adaptiveBadge(_ count: Int, tint: Color? = nil) -> some View {
        modifier(AdaptiveBadge(count: count, tint: tint))
    }
}

private struct AdaptiveBadge: ViewModifier {
    private let count: Int
    private let tint: Color?
    
    init(count: Int, tint: Color?) {
        self.count = count
        self.tint = tint
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .tint(tint)
                .badge(count)
        } else {
            content
                .buttonStyle(ToolbarButtonStyle(tint: tint ?? .accent))
                .overlay(alignment: .topTrailing) {
                    if count > 0 {
                        Text(String(count))
                            .font(.caption)
                            .padding(5)
                            .background(.red, in: .circle)
                            .offset(x: 10, y: -14)
                    }
                }
        }
    }
}

// MARK: - ToolbarButtonStyle

/// Preserves the toolbar button appearance while applying the badge tint on earlier iOS versions.
private struct ToolbarButtonStyle: ButtonStyle {
    private let tint: Color
    
    init(tint: Color) {
        self.tint = tint
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(tint)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
