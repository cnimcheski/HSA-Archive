//
//  ReceiptScannerView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/19/26.
//

import Navigation
import UIKit

extension ReceiptScannerView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension ReceiptScannerView {
    @MainActor
    final class ViewModel: NavigationModel, Navigating {
        enum Destination {
            case review(ReceiptReviewView.ViewModel)
        }
        
        private let onError: () -> Void
        
        weak var delegate: NavigationDelegate?
        
        private var images: [UIImage]?
        
        init(onError: @escaping () -> Void) {
            self.onError = onError
        }
        
        func onCompletion(result: Result<[UIImage], Error>) {
            // Delaying success/failure until the fullScreenCover's onDismiss runs
            if case let .success(images) = result {
                self.images = images
            }
        }
        
        func onDismiss() {
            // Runs when the fullScreenCover's onDismiss runs
            // TODO: - Don't just use the first image at some point.
            guard let images, let first = images.first else {
                onError()
                return
            }
            self.delegate?.navigate(to: .review(.init(uiImage: first)))
        }
    }
}
