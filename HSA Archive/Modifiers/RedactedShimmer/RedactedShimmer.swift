//
//  RedactedShimmer.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/26/26.
//

import Shimmer
import SwiftUI

extension View {
    /// Applies a redacted placeholder with a shimmering animation while loading.
    func redactedShimmer(isShimmering: Bool = true) -> some View {
        modifier(RedactedShimmerModifier(isShimmering: isShimmering))
    }
}

struct RedactedShimmerModifier: ViewModifier {
    enum Constants {
        static let animation = Animation.linear(duration: 1.5).delay(0.1).repeatForever(autoreverses: false)
    }
    
    private let isShimmering: Bool
    
    init(isShimmering: Bool) {
        self.isShimmering = isShimmering
    }
    
    func body(content: Content) -> some View {
        content
            .redacted(reason: isShimmering ? .placeholder : [])
            .shimmering(active: isShimmering, animation: Constants.animation)
    }
}
