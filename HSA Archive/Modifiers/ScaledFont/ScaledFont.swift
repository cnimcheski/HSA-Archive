//
//  ScaledFont.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

extension View {
    /// Extra Large Title with size 46, adapting to dynamic text size.
    func xLargeTitle() -> some View {
        modifier(ScaledFontModifier(size: 46))
    }
    
    /// Extra Extra Large Title with size 60, adapting to dynamic text size.
    func xxLargeTitle() -> some View {
        modifier(ScaledFontModifier(size: 60))
    }
}

/// Provides a system Font with a given size relative to a given `TextStyle` that scales with Dynamic Text size.
private struct ScaledFontModifier: ViewModifier {
    @ScaledMetric private var size: CGFloat
    
    init(size: CGFloat, relativeTo: Font.TextStyle = .largeTitle) {
        _size = .init(wrappedValue: size, relativeTo: relativeTo)
    }

    func body(content: Content) -> some View {
        content.font(.system(size: size))
    }
}
