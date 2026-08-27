//
//  DefaultToastType.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/8/26.
//

import SwiftUI
import Toast

nonisolated enum DefaultToastType: ToastType {
    
    // MARK: - General Errors
    
    case offline
    case serverUnavailable
    case unexpectedError
    
    // MARK: - Import Errors
    
    case fileImporterFailed(count: Int)
    case photoPickerFailed(count: Int)
    
    // MARK: - Google Authentication
    
    case googleSignInFailed
    
    // MARK: - Google API Errors
    
    case spreadsheetPermissionDenied
    case googleRateLimited
    
    // MARK: - Spreadsheet
    
    case spreadsheetCreated
    case spreadsheetRecreated
    case spreadsheetSetupFailed
    
    // MARK: - Receipt
    
    case receiptSaveFailed
    case receiptsFetchFailed
    case receiptImageUploadFailed
    case fileEncodingFailed
    
    var message: LocalizedStringKey {
        switch self {
        case .offline:
            "You are currently offline. Please reconnect to the internet."
        case .serverUnavailable,
            .unexpectedError,
            .fileEncodingFailed:
            "Something went wrong. Please try again."
        case let .fileImporterFailed(count):
            "^[\(count) file](inflect: true) couldn't be loaded."
        case let .photoPickerFailed(count):
            "^[\(count) photo](inflect: true) couldn't be loaded."
        case .googleSignInFailed:
            "Unable to sign in with Google. Please try again."
        case .spreadsheetPermissionDenied:
            "You don't have permission to edit this spreadsheet."
        case .googleRateLimited:
            "Google is temporarily unavailable. Please try again."
        case .spreadsheetCreated:
            "Your HSA Archive spreadsheet was created! Your receipts will be saved there."
        case .spreadsheetRecreated:
            "We couldn't access your previous spreadsheet, so a new one was created. Any receipts stored in the previous spreadsheet will no longer appear in the app."
        case .spreadsheetSetupFailed:
            "Unable to setup HSA Archive. Please try again."
        case .receiptSaveFailed:
            "Unable to save receipt. We couldn't access your HSA Archive spreadsheet. Please try again."
        case .receiptsFetchFailed:
            "Unable to fetch your receipts. We couldn't access your HSA Archive spreadsheet. Please try again."
        case .receiptImageUploadFailed:
            "Couldn't save receipt image to Google Drive. Please try again."
        }
    }
    
    // MARK: - Duration
    
    var defaultDuration: Double {
        switch self {
        case .spreadsheetRecreated:
            10
        case .spreadsheetCreated:
            7
        default:
            5
        }
    }
}
