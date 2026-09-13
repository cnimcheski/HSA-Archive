//
//  HomeView+Overview+StatusCapsule.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/13/26.
//

import SwiftUI

extension HomeView.Overview {
    struct StatusCapsule: View {
        @State private var width = CGFloat.zero
        private let location: CGFloat?
        private let isLoading: Bool
        
        init(location: CGFloat?, isLoading: Bool) {
            self.location = location
            self.isLoading = isLoading
        }
        
        var body: some View {
            content
                .onGeometryChange(for: CGFloat.self, of: \.size.width, action: { width = $0 })
                .redactedShimmer(isShimmering: isLoading)
        }
    }
}

private extension HomeView.Overview.StatusCapsule {
    var content: some View {
        HStack(spacing: .zero) {
            if let location {
                Color.accent
                    .frame(width: accentColorWidth(location))
                Color.brandSecondary
            } else {
                Color.secondary.opacity(0.3)
            }
        }
        .clipShape(.capsule)
        .frame(height: 6)
    }
}

// MARK: - Private Methods

private extension HomeView.Overview.StatusCapsule {
    /// Returns the accent color width based on the normalized location.
    func accentColorWidth(_ location: CGFloat) -> CGFloat {
        width * min(max(location, 0), 1)
    }
}

// MARK: - Previews

#Preview {
    VStack {
        HomeView.Overview.StatusCapsule(location: nil, isLoading: true)
        HomeView.Overview.StatusCapsule(location: 0.4, isLoading: false)
    }
    .padding()
}
