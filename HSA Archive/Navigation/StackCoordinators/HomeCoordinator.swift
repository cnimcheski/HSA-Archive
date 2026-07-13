//
//  HomeCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Combine
import Navigation
import SwiftUI

final class HomeCoordinator: StackCoordinator {
    enum Page: CoordinatedPage {
        // TODO: - Implement further navigation
        case temp
    }
    
    @Published var path: [Page] = []
    @Published var sheet: Page?
    @Published var fullScreenCover: Page?
    
    var rootView: some View {
        HomeView(viewModel: homeViewModel)
    }
    
    private var homeViewModel: HomeViewModel
    
    init() {
        homeViewModel = .init()
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

extension HomeCoordinator: HomeViewModelDelegate {
    @MainActor
    func navigate(to destination: HomeViewModel.Destination) {
        switch destination {
        case .temp:
            // TODO: - Add actual navigation logic..
            push(.temp)
        }
    }
}
