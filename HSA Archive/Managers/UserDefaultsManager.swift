//
//  UserDefaultsManager.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/15/26.
//

import Foundation
import ObservableDefaults

@ObservableDefaults
nonisolated final class UserDefaultsManager {
    private(set) var didFinishOnboarding = false
    private(set) var spreadsheetID: String?
    
    func hasFinishedOnboarding() {
        didFinishOnboarding = true
    }
    
    func setSpreadsheetID(_ spreadsheetID: String) {
        self.spreadsheetID = spreadsheetID
    }
    
    func clearSpreadsheetID() {
        spreadsheetID = nil
    }
}
