//
//  ReceiptReviewCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/24/26.
//

import Navigation
import SwiftUI

extension ReceiptReviewCoordinator {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: Destination)
    }
}

/// This `StackCoordinator` also conforms to `Navigating` and therefore has its own `NavigationDelegate`
/// since it needs to send a signal back to dismiss itself.
@Observable
final class ReceiptReviewCoordinator: StackCoordinator, Navigating, NavigationModel {
    enum Page: CoordinatedPage {
        case categorySelection(SelectionView.ViewModel)
    }
    
    enum Destination {
        case dismiss(shouldShowScanner: Bool)
    }
    
    private let receiptReviewViewModel: ReceiptReviewView.ViewModel
    
    weak var delegate: ReceiptReviewCoordinator.NavigationDelegate?
    
    var path: [Page] = []
    var sheet: Page?
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCover: Page?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    var rootView: some View {
        ReceiptReviewView(viewModel: receiptReviewViewModel.setup(delegate: self))
    }
    
    init(receiptReviewViewModel: ReceiptReviewView.ViewModel) {
        self.receiptReviewViewModel = receiptReviewViewModel
    }
    
    func build(page: Page) -> some View {
        switch page {
        case let .categorySelection(viewModel):
            SelectionView(viewModel: viewModel.setup(delegate: self))
        }
    }
}

// MARK: - Delegate Handlers

extension ReceiptReviewCoordinator: ReceiptReviewView.NavigationDelegate {
    func navigate(to destination: ReceiptReviewView.ViewModel.Destination) {
        switch destination {
        case let .categorySelection(viewModel):
            push(.categorySelection(viewModel))
        case let .dismiss(shouldShowScanner):
            delegate?.navigate(to: .dismiss(shouldShowScanner: shouldShowScanner))
        }
    }
}

extension ReceiptReviewCoordinator: SelectionView.NavigationDelegate {
    func navigate(to destination: SelectionView.ViewModel.Destination) {
        switch destination {
        case .pop:
            pop()
        }
    }
}
