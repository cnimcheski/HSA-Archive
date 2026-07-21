//
//  HomeCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Navigation
import SwiftUI

@MainActor
@Observable
final class HomeCoordinator: StackCoordinator {
    enum Page: CoordinatedPage {
        case addReceipt(AddReceiptCoordinator.Page)
    }
    
    var path: [Page] = []
    var sheet: Modal<Page>?
    var fullScreenCover: Modal<Page>?
    
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
        case let .addReceipt(page):
            addReceiptCoordinator.build(page: page)
        }
    }
}

// MARK: - Delegate Handlers

extension HomeCoordinator: HomeView.NavigationDelegate {
    func navigate(to destination: HomeView.ViewModel.Destination) {
        switch destination {
        case let .addReceipt(viewModel):
            push(
                .addReceipt(.scanner(viewModel)),
                type: .fullScreenCover(onDismiss: viewModel.onDismiss)
            )
        }
    }
}

extension HomeCoordinator: AddReceiptCoordinator.NavigationDelegate {
    func push(_ page: AddReceiptCoordinator.Page, type: Navigation.PushType) {
        push(.addReceipt(page), type: type)
    }
}
