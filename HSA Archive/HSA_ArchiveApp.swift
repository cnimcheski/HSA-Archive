//
//  HSA_ArchiveApp.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import SwiftUI

@main
struct HSA_ArchiveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootCoordinator()
        }
    }
}
