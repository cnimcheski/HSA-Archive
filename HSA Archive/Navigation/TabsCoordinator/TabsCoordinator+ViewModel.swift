//
//  TabsCoordinator+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Navigation
import SwiftUI

extension TabsCoordinator {
    @MainActor
    @Observable
    final class ViewModel {
        enum Tab {
            case home
            case receipts
        }
        
        private var activeTab = Tab.home
        
        let homeCoordinator = HomeCoordinator()
        let receiptsCoordinator = ReceiptsCoordinator()
        
        var tabSelection: Binding<Tab> {
            Binding(
                get: { self.activeTab },
                set: { self.tabTapped($0) }
            )
        }
    }
}

// MARK: - Private Methods

private extension TabsCoordinator.ViewModel {
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
