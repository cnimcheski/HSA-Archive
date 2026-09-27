//
//  AppGroupBox.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/16/26.
//

import SwiftUI

/// A `GroupBox` that applies the app's standard group box style.
struct AppGroupBox<Content: View, Label: View, Style: ShapeStyle>: View {
    private let content: Content
    private let label: Label
    private let padding: CGFloat
    private let background: Style
    
    /// Creates an app group box with custom content and a custom label.
    init(
        padding: CGFloat = Theme.Spacing.large,
        background: Style = .regularMaterial,
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label
    ) {
        self.content = content()
        self.label = label()
        self.padding = padding
        self.background = background
    }
    
    /// Creates a group box with a localized text label.
    init(
        _ titleKey: LocalizedStringKey,
        padding: CGFloat = Theme.Spacing.large,
        background: Style = .regularMaterial,
        @ViewBuilder content: () -> Content
    ) where Label == Text {
        self.init(
            padding: padding,
            background: background,
            content: content,
            label: { Text(titleKey) }
        )
    }
    
    /// Creates a group box without a label.
    init(
        padding: CGFloat = Theme.Spacing.large,
        background: Style = .regularMaterial,
        @ViewBuilder content: () -> Content
    ) where Label == EmptyView {
        self.init(
            padding: padding,
            background: background,
            content: content,
            label: { EmptyView() }
        )
    }
    
    var body: some View {
        GroupBox {
            content
        } label: {
            label
        }
        .groupBoxStyle(.app(padding: padding, background: .init(background)))
    }
}

// MARK: - Previews

#Preview {
    AppGroupBox("Header") {
        Text("Body")
    }
}
