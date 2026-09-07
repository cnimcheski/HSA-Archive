//
//  AppButton+Style.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/7/26.
//

import SwiftUI

nonisolated extension AppButton {
    enum Style {
        case primary
        case secondary
        
        var buttonStyle: AnyPrimitiveButtonStyle {
            switch self {
            case .primary:
                .init(.borderedProminent)
            case .secondary:
                .init(.bordered)
            }
        }
    }
}

// MARK: - AnyPrimitiveButtonStyle

/// A type-erased wrapper for a `PrimitiveButtonStyle`.
struct AnyPrimitiveButtonStyle: PrimitiveButtonStyle {
    private let _makeBody: (Configuration) -> AnyView

    init<S: PrimitiveButtonStyle>(_ style: S) {
        self._makeBody = { AnyView(style.makeBody(configuration: $0)) }
    }

    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}
