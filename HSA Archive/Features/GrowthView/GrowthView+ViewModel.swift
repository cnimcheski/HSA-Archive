//
//  GrowthView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/26/26.
//

import Navigation

extension GrowthView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension GrowthView {
    final class ViewModel: Navigating {
        enum Destination {
            case temp
        }
        
        weak var delegate: NavigationDelegate?
    }
}
