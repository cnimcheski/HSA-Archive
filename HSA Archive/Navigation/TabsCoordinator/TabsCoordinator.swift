//
//  TabsCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Navigation
import SwiftUI

struct TabsCoordinator: View {
    @StateObject private var viewModel: TabsCoordinatorViewModel
    
    init(viewModel: TabsCoordinatorViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        TabView(selection: viewModel.tabSelection) {
            homeCoordinator
            receiptsCoordinator
        }
    }
}

// MARK: - Private Views

private extension TabsCoordinator {
    var homeCoordinator: some TabContent<TabsCoordinatorViewModel.Tab> {
        Tab(
            "Home",
            systemImage: "house.fill",
            value: TabsCoordinatorViewModel.Tab.home
        ) {
            NavigationStackCoordinator(for: viewModel.homeCoordinator)
        }
    }
    
    var receiptsCoordinator: some TabContent<TabsCoordinatorViewModel.Tab> {
        Tab(
            "Receipts",
            systemImage: "receipt.fill",
            value: TabsCoordinatorViewModel.Tab.receipts
        ) {
            NavigationStackCoordinator(for: viewModel.receiptsCoordinator)
        }
    }
}

// MARK: - Previews

#Preview {
    TabsCoordinator(viewModel: .init())
}
