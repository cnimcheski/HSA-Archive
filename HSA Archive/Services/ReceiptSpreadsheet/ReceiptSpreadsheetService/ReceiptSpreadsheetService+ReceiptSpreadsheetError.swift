//
//  ReceiptSpreadsheetService+ReceiptSpreadsheetError.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/10/26.
//

nonisolated extension ReceiptSpreadsheetService {
    enum ReceiptSpreadsheetError: Error {
        case spreadsheetNotFound
    }
}
