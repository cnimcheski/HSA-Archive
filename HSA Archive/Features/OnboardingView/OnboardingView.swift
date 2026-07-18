//
//  OnboardingView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/12/26.
//

import SwiftUI

struct OnboardingView: View {
    @Bindable private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .animation(.spring(), value: viewModel.selectedPage)
    }
}

// MARK: - Private Views

private extension OnboardingView {
    var content: some View {
        VStack {
            topBar
            pagesView
            bottomBar
        }
        .padding()
    }
    
    var topBar: some View {
        HStack {
            if viewModel.shouldShowBackButton {
                Button("Back", action: viewModel.back)
            }
            Spacer()
            if viewModel.shouldShowSkipButton {
                Button("Skip", action: viewModel.skip)
            }
        }
        .font(.headline)
    }
    
    var pagesView: some View {
        TabView(selection: $viewModel.selectedPage) {
            ForEach(Page.allCases) { page in
                PageView(page: page)
                    .tag(page)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    var bottomBar: some View {
        VStack(spacing: Theme.Spacing.medium) {
            ProgressPills(selectedPage: viewModel.selectedPage)
            AppButton(viewModel.actionButtonTitle, action: viewModel.action)
        }
    }
}

// MARK: - Previews

#Preview {
    OnboardingView(viewModel: .init())
}
