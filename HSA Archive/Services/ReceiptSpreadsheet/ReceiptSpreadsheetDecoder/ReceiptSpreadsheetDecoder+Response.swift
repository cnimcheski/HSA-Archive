//
//  ReceiptSpreadsheetDecoder+Response.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/24/26.
//

import Foundation

nonisolated extension ReceiptSpreadsheetDecoder {
    struct Response {
        let receipts: [Receipt]
        let failedRows: [FailedRow]
    }
}

// MARK: - FailedRow

nonisolated extension ReceiptSpreadsheetDecoder.Response {
    struct FailedRow: Identifiable {
        let id = UUID()
        let rowNumber: Int
        let reason: String
    }
}
