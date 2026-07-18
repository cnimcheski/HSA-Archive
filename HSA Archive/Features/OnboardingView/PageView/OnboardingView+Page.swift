//
//  OnboardingView+Page.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/16/26.
//

import Foundation

extension OnboardingView {
    enum Page: CaseIterable, Identifiable {
        case maximize
        case scan
        case find
        case safety
        case growth
        
        var id: Self { self }
        
        var title: String {
            switch self {
            case .maximize:
                "Maximize Your HSA"
            case .scan:
                "Scan in Seconds"
            case .find:
                "Find Eligible Expenses"
            case .safety:
                "Store Everything Safely"
            case .growth:
                "Watch Savings Grow"
            }
        }
        
        var subtitle: String {
            switch self {
            case .maximize:
                "Take advantage of your HSA's triple tax benefits by keeping every eligible expense organized for reimbursement whenever you choose."
            case .scan:
                "Capture a receipt and we'll automatically extract the important details for you."
            case .find:
                "Discover HSA-eligible purchase and import qualifying items from supported retailers."
            case .safety:
                "Securely back up receipts to Google Drive and export your records anytime."
            case .growth:
                "Track reimbursable expenses and see the long-term value of delaying reimbursement."
            }
        }
        
        var systemImage: String {
            switch self {
            case .maximize:
                "dollarsign.arrow.circlepath"
            case .scan:
                "document.viewfinder"
            case .find:
                "checkmark.seal.fill"
            case .safety:
                "externaldrive.badge.checkmark"
            case .growth:
                "chart.line.uptrend.xyaxis"
            }
        }
        
        var next: Page {
            switch self {
            case .maximize:
                .scan
            case .scan:
                .find
            case .find:
                .safety
            case .safety:
                .growth
            case .growth:
                .growth
            }
        }
        
        var previous: Page {
            switch self {
            case .maximize:
                .maximize
            case .scan:
                .maximize
            case .find:
                .scan
            case .safety:
                .find
            case .growth:
                .safety
            }
        }
    }
}
