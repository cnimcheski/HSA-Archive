//
//  ProfileView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/13/26.
//

import Navigation
import Observation

extension ProfileView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension ProfileView {
    @Observable
    final class ViewModel: Navigating {
        enum Destination {
            case temp // TODO: - Add real cases...
        }
        
        weak var delegate: NavigationDelegate?
    }
}
