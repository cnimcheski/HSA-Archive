//
//  ReceiptSpreadsheetDecoder+RowDecodeError.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/24/26.
//

nonisolated extension ReceiptSpreadsheetDecoder {
    enum RowDecodeError: Error, CustomStringConvertible {
        case wrongColumnCount(Int)
        case badID(String)
        case badAmount(String)
        case badDate(String)
        
        var description: String {
            switch self {
            case let .wrongColumnCount(count):
                "Expected \(ReceiptSpreadsheetSchema.columnCount) columns but found \(count)"
            case let .badID(rawString):
                "Bad ID formatting: '\(rawString)'"
            case let .badAmount(rawString):
                "Bad amount formatting: '\(rawString)'"
            case let .badDate(rawString):
                "Bad date formatting: '\(rawString)'"
            }
        }
    }
}
