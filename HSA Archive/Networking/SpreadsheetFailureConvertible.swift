//
//  SpreadsheetFailureConvertible.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/22/26.
//

import Networking

/// Describes the reason a spreadsheet operation failed.
nonisolated enum SpreadsheetFailureReason {
    case notFound
}

/// Provides a spreadsheet specific failure reason for an error.
nonisolated protocol SpreadsheetFailureConvertible {
    var spreadsheetFailureReason: SpreadsheetFailureReason? { get }
}

// MARK: - APIManagerError SpreadsheetFailureConvertible

/// Exposes the underlying API error's spreadsheet failure reason so callers can recover from spreadsheet specific
/// failures even when the error is wrapped by the API manager.
extension APIManagerError: SpreadsheetFailureConvertible {
    var spreadsheetFailureReason: SpreadsheetFailureReason? {
        switch self {
        case let .endpoint(apiError):
            (apiError as? SpreadsheetFailureConvertible)?.spreadsheetFailureReason
        default:
            nil
        }
    }
}
