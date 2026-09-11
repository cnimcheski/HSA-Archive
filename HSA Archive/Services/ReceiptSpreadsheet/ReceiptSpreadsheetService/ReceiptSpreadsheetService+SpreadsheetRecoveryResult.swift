//
//  ReceiptSpreadsheetService+SpreadsheetRecoveryResult.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/10/26.
//

nonisolated extension ReceiptSpreadsheetService {
    /// Represents whether spreadsheet recovery found an existing spreadsheet or created a new one.
    enum SpreadsheetRecoveryResult {
        case existing(String)
        case new(String)
    }
}
