//
//  HomeView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import Dialogs
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
            case addReceipt
        }
        
        weak var delegate: NavigationDelegate?
        
        var confirmationDialogViewModel: ConfirmationDialogViewModel?
        
        func showUploadReceiptConfirmationDialog() {
            confirmationDialogViewModel = .uploadReceipt(
                showReceiptScanner: showReceiptScanner,
                showFileImporter: showFileImporter,
                showPhotosPicker: showPhotosPicker
            )
        }
    }
}

// MARK: - Private Methods

private extension HomeView.ViewModel {
    func showReceiptScanner() {
        delegate?.navigate(to: .addReceipt)
    }
    
    func showFileImporter() {
        // TODO: - Implement file importer
    }
    
    func showPhotosPicker() {
        // TODO: - Implement Photos Picker
    }
}
