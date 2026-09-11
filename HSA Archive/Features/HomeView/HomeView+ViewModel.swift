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
            case reviewReceipt(ReceiptReviewView.ViewModel)
            case signIn(SignInView.ViewModel)
            case invalidReceipts(InvalidReceiptsView.ViewModel)
        }
        
        private let googleAuthService = Container.shared.googleAuthService()
        private let receiptRepository = Container.shared.receiptRepository()
        
        weak var delegate: NavigationDelegate?
        
        var confirmationDialogViewModel: ConfirmationDialogViewModel?
        
        var recentReceipts: [Receipt] {
            receiptRepository.isLoading
                ? Placeholders.recentReceipts
                : Array(receiptRepository.sortedReceipts.prefix(3))
        }
        
        var shouldShowViewAllReceiptsButton: Bool {
            receiptRepository.sortedReceipts.count > 3
        }
        
        func showSignInView() {
            delegate?.navigate(to: .signIn(.init()))
        }
        
        func showUploadReceiptConfirmationDialog() {
            confirmationDialogViewModel = .uploadReceipt(
                showReceiptScanner: showReceiptScanner,
                showFileImporter: showFileImporter,
                showPhotosPicker: showPhotosPicker
            )
        }
        
        func showInvalidReceipts() {
            delegate?.navigate(to: .invalidReceipts(.init(failedRows: receiptRepository.failedRows)))
        }
        
        func showReceiptReview(_ receipt: Receipt) {
            delegate?.navigate(to: .reviewReceipt(.init(receipt: receipt)))
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
