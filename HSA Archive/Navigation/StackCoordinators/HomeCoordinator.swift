//
//  HomeCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Combine
import Navigation
import SwiftUI

@MainActor
@Observable
final class HomeCoordinator: StackCoordinator {
    enum Page: CoordinatedPage {
        // TODO: - Implement further navigation
        case temp
    }
    
    var path: [Page] = []
    var sheet: Page?
    var fullScreenCover: Page?
    
    var rootView: some View {
        HomeView(viewModel: homeViewModel)
    }
    
    private var homeViewModel = HomeView.ViewModel()
    
    init() {
        homeViewModel = homeViewModel.setup(delegate: self)
    }
    
    func build(page: Page) -> some View {
        switch page {
        case .temp:
            EmptyView()
        }
    }
}

// MARK: - Delegate Handlers

extension HomeCoordinator: HomeView.NavigationDelegate {
    @MainActor
    func navigate(to destination: HomeView.ViewModel.Destination) {
        switch destination {
        case .temp:
            // TODO: - Add actual navigation logic..
            push(.temp)
        }
    }
}
