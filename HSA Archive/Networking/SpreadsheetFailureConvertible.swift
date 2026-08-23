//
//  SpreadsheetFailureConvertible.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/22/26.
//

/// Describes the reason a spreadsheet operation failed.
nonisolated enum SpreadsheetFailureReason {
    case notFound
}

/// Provides a spreadsheet specific failure reason for an error.
nonisolated protocol SpreadsheetFailureConvertible {
    var spreadsheetFailureReason: SpreadsheetFailureReason? { get }
}
