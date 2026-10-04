//
//  SceneDelegate.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 10/1/26.
//

import FactoryKit
import Navigation
import UIKit

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    private let deepLinkManager = Container.shared.deepLinkManager()
    
    /// Opens deeplinks from a closed app state.
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let url = connectionOptions.urlContexts.first?.url else { return }
        openDeepLink(url: url)
    }
    
    /// Opens deeplinks from an open app state.
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        openDeepLink(url: url)
    }
    
    /// Opens universal links.
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let url = userActivity.webpageURL else { return }
        openDeepLink(url: url)
    }
}

// MARK: - Private Methods

private extension SceneDelegate {
    func openDeepLink(url: URL) {
        Task {
            await deepLinkManager.open(url: url)
        }
    }
}

