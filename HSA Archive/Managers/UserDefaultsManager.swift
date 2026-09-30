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
    var isAIReceiptExtractionEnabled = true
    var yearsUntilRetirement = 30.0
    var assumedAnnualReturn = 0.07
    private(set) var didFinishOnboarding = false
    private(set) var spreadsheetID: String?
    private(set) var receiptsFolderID: String?
    
    func hasFinishedOnboarding() {
        didFinishOnboarding = true
    }
    
    func setSpreadsheetID(_ spreadsheetID: String) {
        self.spreadsheetID = spreadsheetID
    }
    
    func clearSpreadsheetID() {
        spreadsheetID = nil
    }
    
    func setReceiptsFolderID(_ receiptFoldersID: String) {
        self.receiptsFolderID = receiptFoldersID
    }
    
    func clearReceiptsFolderID() {
        receiptsFolderID = nil
    }
}
