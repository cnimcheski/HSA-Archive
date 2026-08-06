//
//  UserDefaultsManager.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/15/26.
//

import Foundation
import ObservableDefaults

@ObservableDefaults
final class UserDefaultsManager {
    private(set) var didFinishOnboarding = false
    
    func hasFinishedOnboarding() {
        didFinishOnboarding = true
    }
}
