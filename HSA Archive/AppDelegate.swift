//
//  AppDelegate.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/22/26.
//

import FactoryKit
import FirebaseAppCheck
import FirebaseCore
import GoogleSignIn

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let providerFactory = DefaultAppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        /// Configures App Check for Google Sign In use.
        GIDSignIn.sharedInstance.configure()
        
        /// Ensure the user's sign in state is restored.
        Container.shared.googleAuthService().restorePreviousSignIn()
        
        FirebaseApp.configure()
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        /// Handles the Google Sign In authentication redirect URL.
        GIDSignIn.sharedInstance.handle(url)
    }
}
