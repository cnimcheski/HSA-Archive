//
//  OnboardingView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/15/26.
//

import FactoryKit
import Observation

extension OnboardingView {
    @MainActor
    @Observable
    final class ViewModel {
        private let userDefaultsManager = Container.shared.userDefaultsManager()
        
        var selectedPage = Page.allCases.first
        
        var shouldShowBackButton: Bool {
            selectedPage != Page.allCases.first
        }
        
        var shouldShowSkipButton: Bool {
            selectedPage != Page.allCases.last
        }
        
        var actionButtonTitle: String {
            selectedPage != Page.allCases.last ? "Continue" : "Get Started"
        }
        
        func back() {
            selectedPage = selectedPage?.previous
        }
        
        func skip() {
            selectedPage = Page.allCases.last
        }
        
        func action() {
            if selectedPage == Page.allCases.last {
                userDefaultsManager.hasFinishedOnboarding()
            } else {
                selectedPage = selectedPage?.next
            }
        }
    }
}
