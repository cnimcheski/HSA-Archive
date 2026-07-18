//
//  OnboardingView+PageView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/16/26.
//

import SwiftUI

extension OnboardingView {
    struct PageView: View {
        private let page: Page
        
        init(page: Page) {
            self.page = page
        }
        
        var body: some View {
            VStack(spacing: Theme.Spacing.large) {
                iconView
                titleText
                subtitleText
            }
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}

// MARK: - Private Views

private extension OnboardingView.PageView {
    var iconView: some View {
        Image(systemName: page.systemImage)
            .xxLargeTitle()
            .symbolRenderingMode(.hierarchical)
    }
    
    var titleText: some View {
        Text(page.title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
    
    var subtitleText:  some View {
        Text(page.subtitle)
            .font(.headline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
}

// MARK: - Previews

#Preview {
    OnboardingView.PageView(page: .find)
}
