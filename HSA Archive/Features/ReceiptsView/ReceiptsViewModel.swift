//
//  ReceiptsViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import Navigation
import Observation

extension ReceiptsView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
    
    @MainActor
    @Observable
    final class ViewModel: Navigating {
        enum Destination {
            case temp
        }
        
        weak var delegate: NavigationDelegate?
    }
}
