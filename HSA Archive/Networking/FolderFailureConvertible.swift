//
//  FolderFailureConvertible.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 10/4/26.
//

import Networking

/// Describes the reason a folder operation failed.
nonisolated enum FolderFailureReason {
    case notFound
}

/// Provides a folder specific failure reason for an error.
nonisolated protocol FolderFailureConvertible {
    var folderFailureReason: FolderFailureReason? { get }
}

// MARK: - APIManagerError FolderFailureConvertible

/// Exposes the underlying API error's folder failure reason so callers can recover from folder specific
/// failures even when the error is wrapped by the API manager.
extension APIManagerError: FolderFailureConvertible {
    var folderFailureReason: FolderFailureReason? {
        switch self {
        case let .endpoint(apiError):
            (apiError as? FolderFailureConvertible)?.folderFailureReason
        default:
            nil
        }
    }
}

