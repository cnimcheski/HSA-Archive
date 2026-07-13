//
//  TabsCoordinatorViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Combine
import Navigation
import SwiftUI

final class TabsCoordinatorViewModel: ObservableObject {
    enum Tab {
        case home
        case receipts
    }
    
    @Published private var activeTab = Tab.home
    
    let homeCoordinator: HomeCoordinator = .init()
    let receiptsCoordinator: ReceiptsCoordinator = .init()
    
    @MainActor
    var tabSelection: Binding<Tab> {
        Binding(
            get: { self.activeTab },
            set: { self.tabTapped($0) }
        )
    }
}

// MARK: - Private Methods

private extension TabsCoordinatorViewModel {
    func tabTapped(_ newTab: Tab) {
        guard newTab == activeTab else {
            activeTab = newTab
            return
        }
        /// Pop the current tab to root whenever it is tapped a second time
        switch newTab {
        case .home:
            homeCoordinator.popToRoot()
        case .receipts:
            receiptsCoordinator.popToRoot()
        }
    }
}
