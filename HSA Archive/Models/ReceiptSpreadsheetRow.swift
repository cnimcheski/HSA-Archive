//
//  ReceiptSpreadsheetRow.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/22/26.
//

import Foundation

/// Represents a receipt row in the app spreadsheet.
nonisolated struct ReceiptSpreadsheetRow {
    let merchant: String
    let description: String
    let amount: String
    let transactionDate: String
    let category: String
    let reimbursementDate: String
    let submissionDate: String = DateFormatter.iso8601DateOnly.string(from: .now)
    let notes: String
    let receipt: String
    
    /// Builds a receipt spreadsheet row from a `Receipt` object and the Google Drive image ID for the receipt image.
    init(receipt: Receipt, imageID: String) {
        merchant = receipt.merchant
        description = receipt.description
        amount = receipt.amount.formatted(AppFormatStyle.Currency.current)
        transactionDate = DateFormatter.iso8601DateOnly.string(from: receipt.transactionDate)
        category = receipt.category.rawValue
        reimbursementDate = receipt.reimbursementDate.map { DateFormatter.iso8601DateOnly.string(from: $0) } ?? ""
        notes = receipt.notes
        self.receipt = "=HYPERLINK(\"https://drive.google.com/file/d/\(imageID)/view\", \"\(receipt.fileName)\")"
    }
}

// MARK: - headers

nonisolated extension ReceiptSpreadsheetRow {
    /// The headers for the receipt spreadsheet.
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

// MARK: - values

nonisolated extension ReceiptSpreadsheetRow {
    /// The values passed to Google Sheets to create the spreadsheet row.
    var values: [String] {
        [
            merchant,
            description,
            amount,
            transactionDate,
            category,
            reimbursementDate,
            submissionDate,
            notes,
            receipt
        ]
    }
}
