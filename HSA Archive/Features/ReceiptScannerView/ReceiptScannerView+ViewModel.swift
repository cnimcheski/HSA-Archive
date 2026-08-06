//
//  ReceiptScannerView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/19/26.
//

import Dialogs
import Navigation
import UIKit

extension ReceiptScannerView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension ReceiptScannerView {
    @Observable
    final class ViewModel: NavigationModel, Navigating {
        enum Destination {
            case dismiss(uiImage: UIImage? = nil)
        }
        
        weak var delegate: NavigationDelegate?
        
        var alertViewModel: AlertViewModel?
        
        func onCompletion(result: Result<[UIImage], Error>) {
            switch result {
            case let .success(uiImages):
                dismiss(uiImages: uiImages)
            case .failure:
                handleError()
            }
        }
        
        /// Dismisses this screen and pushes on the `ReceiptReviewView` when passing an actual UIImage.
        func dismiss(uiImages: [UIImage]? = nil) {
            delegate?.navigate(to: .dismiss(uiImage: uiImages?.first))
        }
    }
}

// MARK: - Private Methods

private extension ReceiptScannerView.ViewModel {
    func handleError() {
        alertViewModel = .scannerError { self.dismiss() }
    }
}
