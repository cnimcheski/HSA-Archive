//
//  ReceiptPreviewView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/19/26.
//

import Navigation
import SwiftUI

extension ReceiptReviewView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension ReceiptReviewView {
    @MainActor
    final class ViewModel: NavigationModel, Navigating {
        enum Destination {
            case dismiss
        }
        
        let uiImage: UIImage
        
        weak var delegate: NavigationDelegate?
        
        init(uiImage: UIImage) {
            self.uiImage = uiImage
        }
        
        func dismiss() {
            delegate?.navigate(to: .dismiss)
        }
    }
}
