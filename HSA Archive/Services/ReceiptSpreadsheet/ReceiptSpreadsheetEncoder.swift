//
//  ReceiptSpreadsheetEncoder.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/24/26.
//

import Foundation

nonisolated struct ReceiptSpreadsheetEncoder {
    /// Encodes our `Receipt` type into the values that Google Sheets expects.
    static func encode(_ receipt: Receipt, imageID: String) -> [String] {
        [
            receipt.merchant,
            receipt.description,
            String(receipt.amount),
            DateFormatter.iso8601DateOnly.string(from: receipt.transactionDate),
            receipt.category.rawValue,
            receipt.reimbursementDate.map { DateFormatter.iso8601DateOnly.string(from: $0) } ?? "",
            DateFormatter.iso8601DateOnly.string(from: receipt.submissionDate ?? .now),
            receipt.notes,
            "=HYPERLINK(\"https://drive.google.com/file/d/\(imageID)/view\", \"\(receipt.fileName)\")"
        ]
    }
}
