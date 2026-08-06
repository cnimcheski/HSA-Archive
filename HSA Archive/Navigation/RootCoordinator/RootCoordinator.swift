//
//  RootCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/17/26.
//

import FactoryKit
import SwiftUI

struct RootCoordinator: View {
    @Injected(\.remoteConfigClient) private var remoteConfigClient
    @State private var viewModel = ViewModel()
    
    var body: some View {
        Group {
            switch viewModel.rootViewType {
            case .onboarding:
                OnboardingView(viewModel: viewModel.onboardingViewModel)
                    .transition(.opacity)
            case .tabs:
                TabsCoordinator(viewModel: viewModel.tabsCoordinatorViewModel)
            }
        }
        .animation(.spring, value: viewModel.rootViewType)
        .task { await remoteConfigClient.fetchAndActivate() }
    }
}

// MARK: - Previews

#Preview {
    RootCoordinator()
}
