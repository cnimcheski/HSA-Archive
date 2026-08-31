//
//  HSA_ArchiveApp.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import FactoryKit
import SwiftUI
import Toast

@main
struct HSA_ArchiveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    // Resolves AppSession at app launch to start its app lifetime observation.
    private let appSession = Container.shared.appSession()
    
    var body: some Scene {
        WindowGroup {
            ToastCoordinator {
                DefaultToastView()
            } content: {
                RootCoordinator()
            }
        }
    }
}
