//
//  ExtraLargeTitle.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

extension View {
    /// Provides a larger dynamic text style than the SwiftUI max of `largeTitle`
    func extraLargeTitle() -> some View {
        modifier(ExtraLargeTitleModifier())
    }
}

struct ExtraLargeTitleModifier: ViewModifier {
    private enum Constants {
        static let size: CGFloat = 44
    }
    
    @ScaledMetric(relativeTo: .largeTitle) private var size = Constants.size

    func body(content: Content) -> some View {
        content.font(.system(size: size))
    }
}
