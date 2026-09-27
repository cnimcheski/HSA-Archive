//
//  GrowthCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/26/26.
//

import Navigation
import SwiftUI

@Observable
final class GrowthCoordinator: StackCoordinator {
    enum Page: CoordinatedPage {
        case temp // TODO: - Add actual cases.
    }
    
    var path: [Page] = []
    var sheet: Page?
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCover: Page?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    var rootView: some View {
        GrowthView(viewModel: growthViewModel)
    }
    
    private var growthViewModel = GrowthView.ViewModel()
    
    init() {
        growthViewModel = growthViewModel.setup(delegate: self)
    }
    
    func build(page: Page) -> some View {
        switch page {
        case .temp:
            Text("Temp")
        }
    }
}

// MARK: - Delegate Handlers

extension GrowthCoordinator: GrowthView.NavigationDelegate {
    func navigate(to destination: GrowthView.ViewModel.Destination) {
        switch destination {
        case .temp:
            print("ADD ACTUAL DESTINATIONS LATER")
        }
    }
}
