//
//  GoogleAuthService+AuthState.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/17/26.
//

import GoogleSignIn

nonisolated extension GoogleAuthService {
    enum AuthState: Equatable {
        case restoring
        case signedOut
        case signedIn(GIDGoogleUser)
        
        var isSignedIn: Bool {
            if case .signedIn = self { true } else { false }
        }
        
        var isSignedOut: Bool {
            if case .signedOut = self { true } else { false }
        }
        
        var isRestoring: Bool {
            if case .restoring = self { true } else { false }
        }
        
        var currentUser: GIDGoogleUser? {
            guard case let .signedIn(currentUser) = self else { return nil }
            return currentUser
        }
    }
}
