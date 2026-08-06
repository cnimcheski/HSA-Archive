//
//  DefaultAppCheckProviderFactory.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/26/26.
//

import FirebaseAppCheck
import FirebaseCore

class DefaultAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    /// Creates the appropriate App Check provider for the current build configuration.
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        #if DEBUG
        AppCheckDebugProvider(app: app)
        #else
        AppAttestProvider(app: app)
        #endif
    }
}
