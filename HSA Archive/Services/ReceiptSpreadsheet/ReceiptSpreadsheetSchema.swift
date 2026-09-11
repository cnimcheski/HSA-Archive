//
//  ReceiptSpreadsheetSchema.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/24/26.
//

nonisolated enum ReceiptSpreadsheetSchema {
    /// The ordered column headers used for receipt data in the spreadsheet.
    static let headers = [
        "ID",
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
    
    /// The number of columns in the schema.
    static let columnCount = headers.count
    
    /// The last column containing receipt data in the spreadsheet.
    static let lastColumn = "J"
    
    /// The spreadsheet range containing the specified receipt row.
    static func rowRange(for row: Int) -> String {
        "\(AppConstants.worksheetName)!A\(row):\(lastColumn)\(row)"
    }
}
