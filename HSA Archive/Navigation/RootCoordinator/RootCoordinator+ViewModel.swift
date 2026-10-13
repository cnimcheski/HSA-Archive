//
//  RootCoordinator+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/17/26.
//

import FactoryKit
import Observation

extension RootCoordinator {
    @Observable
    final class ViewModel {
        enum RootViewType {
            case onboarding
            case tabs
            case updateRequired
        }
        
        private let receiptSpreadsheetService = Container.shared.receiptSpreadsheetService()
        private let userDefaultsManager = Container.shared.userDefaultsManager()
        
        let onboardingViewModel = OnboardingView.ViewModel()
        let tabsCoordinatorViewModel = TabsCoordinator.ViewModel()
        
        var rootViewType: RootViewType {
            if receiptSpreadsheetService.requiresAppUpdate { return .updateRequired }
            return userDefaultsManager.didFinishOnboarding ? .tabs : .onboarding
        }
    }
}
