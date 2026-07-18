//
//  OnboardingView+ProgressPills.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/16/26.
//

import SwiftUI

extension OnboardingView {
    struct ProgressPills: View {
        private let selectedPage: Page?
        
        init(selectedPage: Page?) {
            self.selectedPage = selectedPage
        }
        
        var body: some View {
            HStack(spacing: Theme.Spacing.small) {
                ForEach(Page.allCases) { page in
                    Capsule()
                        .foregroundStyle(.secondary.opacity(page == selectedPage ? 1 : 0.35))
                        .frame(width: page == selectedPage ? 22 : 8, height: 8)
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    OnboardingView.ProgressPills(selectedPage: .find)
}
