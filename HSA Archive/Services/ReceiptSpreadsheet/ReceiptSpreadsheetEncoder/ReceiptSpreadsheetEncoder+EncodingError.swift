//
//  ReceiptSpreadsheetEncoder+EncodingError.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/10/26.
//

nonisolated extension ReceiptSpreadsheetEncoder {
    enum EncodingError: Error {
        case missingFileID
    }
}
