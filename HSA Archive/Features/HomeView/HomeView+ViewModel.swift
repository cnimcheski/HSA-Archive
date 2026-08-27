//
//  HomeView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import Dialogs
import FactoryKit
import Navigation
import SwiftUI

extension HomeView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension HomeView {
    @Observable
    final class ViewModel: Navigating {
        enum Destination {
            case filePicker
            case photosPicker
            case scanner
            case invalidReceipts(InvalidReceiptsView.ViewModel)
        }
        
        private let googleAuthService = Container.shared.googleAuthService()
        private let receiptRepository = Container.shared.receiptRepository()
        
        weak var delegate: NavigationDelegate?
        
        var confirmationDialogViewModel: ConfirmationDialogViewModel?
        
        var recentReceipts: [Receipt] {
            Array(receiptRepository.sortedReceipts.prefix(3))
        }
        
        var failedRows: [ReceiptSpreadsheetDecoder.Response.FailedRow] {
            receiptRepository.failedRows
        }
        
        var shouldShowViewAllReceiptsButton: Bool {
            receiptRepository.sortedReceipts.count > 3
        }
        
        func fetchReceipts() async {
            // TODO: - Adding loading state...
            guard await googleAuthService.isSignedIn else {
                // TODO: - Show not logged in state...
                return
            }
            guard await receiptRepository.fetchAll() != nil else {
                // TODO: - Show error state...
                return
            }
        }
        
        func showUploadReceiptConfirmationDialog() {
            confirmationDialogViewModel = .uploadReceipt(
                showReceiptScanner: showReceiptScanner,
                showFileImporter: showFileImporter,
                showPhotosPicker: showPhotosPicker
            )
        }
        
        func showInvalidReceipts() {
            delegate?.navigate(to: .invalidReceipts(.init(failedRows: failedRows)))
        }
        
        func onReceiptSelected(_ receipt: Receipt) {
            // TODO: - Navigate to the ReceiptReviewView
        }
    }
}

// MARK: - Private Methods

private extension HomeView.ViewModel {
    func showReceiptScanner() {
        delegate?.navigate(to: .scanner)
    }
    
    func showFileImporter() {
        delegate?.navigate(to: .filePicker)
    }
    
    func showPhotosPicker() {
        delegate?.navigate(to: .photosPicker)
    }
}
