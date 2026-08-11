//
//  HSA_ArchiveApp.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import SwiftUI
import Toast

@main
struct HSA_ArchiveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
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
