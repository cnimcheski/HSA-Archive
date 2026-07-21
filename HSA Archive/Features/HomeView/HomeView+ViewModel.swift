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
    @MainActor
    @Observable
    final class ViewModel: Navigating {
        enum Destination {
            case addReceipt(ReceiptScannerView.ViewModel)
        }
        
        weak var delegate: NavigationDelegate?
        
        var alertViewModel: AlertViewModel?
        
        func showReceiptScanner() {
            delegate?.navigate(to: .addReceipt(.init(onError: showScannerErrorAlert)))
        }
    }
}

// MARK: - Private Methods

private extension HomeView.ViewModel {
    func showScannerErrorAlert() {
        alertViewModel = .scannerError
    }
}
