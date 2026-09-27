//
//  AppGroupBoxStyle.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/16/26.
//

import SwiftUI

extension GroupBoxStyle where Self == AppGroupBoxStyle {
    /// The app's standard group box style.
    static func app(padding: CGFloat, background: AnyShapeStyle) -> AppGroupBoxStyle {
        .init(padding: padding, background: background)
    }
}

struct AppGroupBoxStyle: GroupBoxStyle {
    @Environment(\.appGroupBoxNestingLevel) private var nestingLevel
    @Environment(\.colorScheme) private var colorScheme
    private let padding: CGFloat
    private let background: AnyShapeStyle
    
    init(padding: CGFloat, background: AnyShapeStyle) {
        self.padding = padding
        self.background = background
    }
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.headline)
            configuration.content
        }
        .padding(padding)
        .background(
            nestingLevel.isMultiple(of: 2)
                ? AnyShapeStyle(background)
                : colorScheme == .light
                    ? AnyShapeStyle(.background)
                    : AnyShapeStyle(background),
            in: .rect(cornerRadius: Theme.CornerRadius.large)
        )
        .transformEnvironment(\.appGroupBoxNestingLevel) { $0 += 1 }
    }
}

// MARK: - AppGroupBoxNestingLevelKey

private extension EnvironmentValues {
    /// The current nesting depth of app group boxes.
    var appGroupBoxNestingLevel: Int {
        get { self[AppGroupBoxNestingLevelKey.self] }
        set { self[AppGroupBoxNestingLevelKey.self] = newValue }
    }
}

private struct AppGroupBoxNestingLevelKey: EnvironmentKey {
    static var defaultValue: Int = 0
}
