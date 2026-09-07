//
//  AppConstants.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/24/26.
//

import Foundation

nonisolated final class AppConstants {
    // MARK: - Fields
    static let categoryPrompt = "Category"
    static let categoriesPrompt = "Categories"
    static let categorySearchPlaceholder = "Search categories..."
    
    // MARK: - Networking
    static let googleSheetsBaseURL = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/")
    static let googleDriveBaseURL = URL(string: "https://www.googleapis.com/")
    
    // MARK: - Spreadsheets
    static let spreadsheetTitle = "HSA Archive"
    static let worksheetName = "Receipts"
    static let spreadsheetAppPropertyKey = "HSA_Archive"
    static let spreadsheetAppPropertyValue = "true"
}
