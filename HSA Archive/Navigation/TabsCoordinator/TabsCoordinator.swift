//
//  TabsCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import FactoryKit
import Navigation
import SwiftUI

struct TabsCoordinator: View {
    @InjectedObservable(\.receiptRepository) var receiptRepository
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView(selection: viewModel.tabSelection) {
            homeCoordinator
            receiptsCoordinator
        }
        .onFirstTask(receiptRepository.loadReceipts)
    }
}

// MARK: - Private Views

private extension TabsCoordinator {
    var homeCoordinator: some TabContent<ViewModel.Tab> {
        Tab(
            "Home",
            systemImage: "house.fill",
            value: ViewModel.Tab.home
        ) {
            NavigationStackCoordinator(for: viewModel.homeCoordinator)
        }
    }
    
    var receiptsCoordinator: some TabContent<ViewModel.Tab> {
        Tab(
            "Receipts",
            systemImage: "receipt.fill",
            value: ViewModel.Tab.receipts
        ) {
            NavigationStackCoordinator(for: viewModel.receiptsCoordinator)
        }
    }
}

// MARK: - Previews

#Preview {
    TabsCoordinator(viewModel: .init())
}
