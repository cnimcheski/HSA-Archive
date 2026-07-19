//
//  HomeView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import Navigation
import Observation

extension HomeView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
    
    @MainActor
    @Observable
    final class ViewModel: Navigating {
        enum Destination {
            // TODO: - Add actual navigational logic
            case temp
        }
        
        weak var delegate: NavigationDelegate?
    }
}
