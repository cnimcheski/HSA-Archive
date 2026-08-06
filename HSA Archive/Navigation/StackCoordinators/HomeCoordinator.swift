//
//  HomeCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Navigation
import SwiftUI

@Observable
final class HomeCoordinator: StackCoordinator {
    enum Page: CoordinatedPage {
        case addReceiptCoordinator(AddReceiptCoordinator.Page)
    }
    
    var path: [Page] = []
    var sheet: Page?
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCover: Page?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    var rootView: some View {
        HomeView(viewModel: homeViewModel)
    }
    
    private var homeViewModel = HomeView.ViewModel()
    private var addReceiptCoordinator = AddReceiptCoordinator()
    
    init() {
        homeViewModel = homeViewModel.setup(delegate: self)
        addReceiptCoordinator = addReceiptCoordinator.setup(delegate: self)
    }
    
    func build(page: Page) -> some View {
        switch page {
        case let .addReceiptCoordinator(page):
            addReceiptCoordinator.build(page: page)
        }
    }
}

// MARK: - Delegate Handlers

extension HomeCoordinator: HomeView.NavigationDelegate {
    func navigate(to destination: HomeView.ViewModel.Destination) {
        switch destination {
        case .addReceipt:
            push(.addReceiptCoordinator(.scanner), type: .fullScreenCover)
        }
    }
}

extension HomeCoordinator: AddReceiptCoordinator.NavigationDelegate {
    func push(_ page: AddReceiptCoordinator.Page, type: Navigation.PushType) {
        push(.addReceiptCoordinator(page), type: type)
    }
}
