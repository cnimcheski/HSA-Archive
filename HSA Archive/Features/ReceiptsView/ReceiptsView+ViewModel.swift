//
//  ReceiptsView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import Dialogs
import FactoryKit
import Foundation
import Navigation

extension ReceiptsView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension ReceiptsView {
    @Observable
    final class ViewModel: Navigating {
        enum Destination {
            case scanner
            case filePicker
            case photosPicker
            case filters(ReceiptFiltersView.ViewModel)
            case invalidReceipts(InvalidReceiptsView.ViewModel)
            case signIn(SignInView.ViewModel)
        }
        
        private let receiptRepository = Container.shared.receiptRepository()
        
        weak var delegate: NavigationDelegate?
        
        var searchText = ""
        var confirmationDialogViewModel: ConfirmationDialogViewModel?
        
        var receiptSections: [ReceiptSection] {
            Dictionary(grouping: filteredReceipts) { $0.transactionDate.startOfMonth }
                .map(ReceiptSection.init)
                .sorted { $0.date > $1.date }
        }
        
        private(set) var filters = Receipt.Filters()
        
        private var filteredReceipts: [Receipt] {
            guard !receiptRepository.isLoading else { return Placeholders.receipts }
            let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            return receiptRepository.sortedReceipts.filter {
                $0.matches(filters)
                    && $0.matches(searchText: searchText)
            }
        }
        
        func showFiltersView() {
            delegate?.navigate(
                to: .filters(
                    .init(initialFilters: filters, onApply: applyFilters)
                )
            )
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
    }
}

// MARK: - Private Methods

private extension ReceiptsView.ViewModel {
    func showReceiptScanner() {
        delegate?.navigate(to: .scanner)
    }
    
    func showFileImporter() {
        delegate?.navigate(to: .filePicker)
    }
    
    func showPhotosPicker() {
        delegate?.navigate(to: .photosPicker)
    }
    
    func applyFilters(_ filters: Receipt.Filters) {
        self.filters = filters
    }
}
