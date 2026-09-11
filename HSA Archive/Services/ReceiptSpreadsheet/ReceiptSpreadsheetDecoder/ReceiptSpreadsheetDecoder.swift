//
//  ReceiptSpreadsheetDecoder.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/24/26.
//

import Foundation

nonisolated struct ReceiptSpreadsheetDecoder {
    /// Decodes the Google Sheets response into our `Receipt` type.
    static func decode(_ values: [[String]]) -> Response {
        var receipts = [Receipt]()
        var failedRows = [Response.FailedRow]()
        for (index, value) in values.enumerated() {
            do {
                receipts.append(try decodeRow(value))
            } catch {
                failedRows.append(.init(rowNumber: index + 2, reason: error.description))
            }
        }
        return .init(receipts: receipts, failedRows: failedRows)
    }
}

// MARK: - Private Methods

nonisolated private extension ReceiptSpreadsheetDecoder {
    /// Decodes a single row of a Google Sheets response into our `Receipt` type.
    static func decodeRow(_ value: [String]) throws(RowDecodeError) -> Receipt {
        guard value.count >= ReceiptSpreadsheetSchema.columnCount else { throw RowDecodeError.wrongColumnCount(value.count) }
        guard let id = UUID(uuidString: value[0]) else { throw RowDecodeError.badID(value[0]) }
        guard let amount = Double(value[3]) else { throw RowDecodeError.badAmount(value[3]) }
        guard let date = DateFormatter.iso8601DateOnly.date(from: value[4]) else { throw RowDecodeError.badDate(value[4]) }
        return .init(
            id: id,
            merchant: value[1],
            description: value[2],
            amount: amount,
            transactionDate: date,
            category: .init(rawValue: value[5]) ?? .other,
            reimbursementDate: DateFormatter.iso8601DateOnly.date(from: value[6]),
            submissionDate: DateFormatter.iso8601DateOnly.date(from: value[7]),
            notes: value[8],
            fileID: value[9]
        )
    }
}
