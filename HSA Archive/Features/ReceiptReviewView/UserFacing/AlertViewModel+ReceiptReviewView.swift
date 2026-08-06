//
//  AlertViewModel+ReceiptReviewView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/1/26.
//

import Dialogs

extension AlertViewModel {
    static func unreadable(
        handleScanAgain: @escaping () -> Void
    ) -> Self {
        .init(
            title: "Couldn't Read Receipt",
            message: "We couldn't read enough information from this receipt. Try taking a clearer photo or enter the receipt manually.",
            primaryButton: .init(
                title: "Scan Again",
                action: handleScanAgain
            ),
            secondaryButton: .init(
                title: "Enter Manually",
                type: .cancel
            )
        )
    }
    
    static func noEligibleExpenses(
        handleScanAgain: @escaping () -> Void
    ) -> Self {
        .init(
            title: "No HSA-Eligible Expenses Found",
            message: "We couldn't identify any HSA-eligible expenses on this receipt. AI analysis isn't always accurate, so you can review the receipt and enter the details manually if needed.",
            primaryButton: .init(
                title: "Scan Another Receipt",
                action: handleScanAgain
            ),
            secondaryButton: .init(
                title: "Enter Manually",
                type: .cancel
            )
        )
    }
    
    static func notReceipt(
        handleScanAgain: @escaping () -> Void
    ) -> Self {
        .init(
            title: "Not a Receipt",
            message: "The image doesn't appear to be a receipt. Try scanning a receipt or enter the details manually instead.",
            primaryButton: .init(
                title: "Scan Another Receipt",
                action: handleScanAgain
            ),
            secondaryButton: .init(
                title: "Enter Manually",
                type: .cancel
            )
        )
    }
}
