//
//  ReceiptSpreadsheetSchema.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/24/26.
//

nonisolated enum ReceiptSpreadsheetSchema {
    /// The ordered column headers used for receipt data in the spreadsheet.
    static let headers = [
        "Merchant",
        "Description",
        "Amount",
        "Transaction Date",
        "Category",
        "Reimbursement Date",
        "Submission Date",
        "Notes",
        "Receipt"
    ]
}
