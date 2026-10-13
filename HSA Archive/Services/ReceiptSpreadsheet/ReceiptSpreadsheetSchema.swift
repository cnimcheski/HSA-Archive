//
//  ReceiptSpreadsheetSchema.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/24/26.
//

nonisolated enum ReceiptSpreadsheetSchema {
    /// The current schema version.
    /// - Note: The schema version must be updated in order for the app to migrate to new schema versions on app launch.
    /// - Note: Whenever this is changed, we need to also add a case to `migrateSchema` in `ReceiptSpreadsheetService`.
    static let currentVersion = 1
    
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
