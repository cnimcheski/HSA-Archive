//
//  TabsCoordinator+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import FactoryKit
import Navigation
import SwiftUI

extension TabsCoordinator {
    @Observable
    final class ViewModel {
        enum Tab {
            case home
            case receipts
            case growth
            case profile
        }
        
        private let deepLinkManager = Container.shared.deepLinkManager()
        
        let receiptsCoordinator = ReceiptsCoordinator()
        let growthCoordinator = GrowthCoordinator()
        let profileCoordinator = ProfileCoordinator()
        
        var tabSelection: Binding<Tab> {
            Binding(
                get: { self.activeTab },
                set: { self.tabTapped($0) }
            )
        }
        
        private(set) var homeCoordinator = HomeCoordinator()
        
        private var activeTab = Tab.home
        
        init() {
            homeCoordinator = homeCoordinator.setup(delegate: self)
            observeDeepLinkPublisher()
        }
    }
}

// MARK: - Private Methods

private extension TabsCoordinator.ViewModel {
    func observeDeepLinkPublisher() {
        Task {
            for await deepLink in deepLinkManager.deepLinks {
                await handle(deepLink: deepLink)
            }
        }
    }
    
    func resetActiveTab(_ activeTab: Tab) {
        self.activeTab = activeTab
        popTabToRoot(activeTab)
    }
    
    func popTabToRoot(_ activeTab: Tab) {
        switch activeTab {
        case .home:
            homeCoordinator.popToRoot()
        case .receipts:
            receiptsCoordinator.popToRoot()
        case .growth:
            growthCoordinator.popToRoot()
        case .profile:
            profileCoordinator.popToRoot()
        }
    }
    
    // TODO: - Use this once we start listening to auth state changes...
    func popAllTabsToRoot() {
        homeCoordinator.popToRoot()
        receiptsCoordinator.popToRoot()
        growthCoordinator.popToRoot()
        profileCoordinator.popToRoot()
    }
    
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
        case .growth:
            growthCoordinator.popToRoot()
        case .profile:
            profileCoordinator.popToRoot()
        }
    }
}

// MARK: - Delegate Handlers

extension TabsCoordinator.ViewModel: HomeCoordinator.NavigationDelegate {
    func navigate(to destination: HomeCoordinator.Destination) {
        switch destination {
        case .receiptsTab:
            resetActiveTab(.receipts)
        }
    }
}

// MARK: - DeepLink Handlers

private extension TabsCoordinator.ViewModel {
    func handle(deepLink: DeepLink) async {
        switch deepLink {
        case let link as ImportReceiptsDeepLink:
            handleImportReceiptsDeepLink(batch: link.batch)
        default: break
        }
    }
    
    func handleImportReceiptsDeepLink(batch: String) {
        resetActiveTab(.receipts)
        receiptsCoordinator.handleSelectedImages(loadImages(for: batch))
        delete(batch: batch)
    }
    
    /// Loads receipt images from the specified App Group inbox batch.
    func loadImages(for batch: String) -> [UIImage] {
        let root = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: AppConstants.appGroupID)
        guard let dir = root?
            .appendingPathComponent("\(AppConstants.inboxDirectoryName)/\(batch)") else { return [] }
        let files = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
        return files?
            .sorted { $0.lastPathComponent < $1.lastPathComponent }
            .compactMap { UIImage(contentsOfFile: $0.path) } ?? []
    }

    /// Deletes the specified App Group inbox batch.
    func delete(batch: String) {
        guard let dir = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: AppConstants.appGroupID)?
            .appendingPathComponent("\(AppConstants.inboxDirectoryName)/\(batch)") else { return }
        try? FileManager.default.removeItem(at: dir)
    }
}
