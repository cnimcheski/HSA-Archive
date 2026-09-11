//
//  AddReceiptCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/19/26.
//

import Navigation
import SwiftUI

extension AddReceiptCoordinator {
    protocol NavigationDelegate: AnyObject {
        @MainActor func pop(_ last: Int)
        @MainActor func popToRoot()
        @MainActor func push(_ page: Page, type: PushType)
        @MainActor func dismissSheet(onDismiss: (() -> Void)?)
        @MainActor func dismissFullScreenCover(onDismiss: (() -> Void)?)
    }
}

final class AddReceiptCoordinator: ChildCoordinator {
    enum Page: CoordinatedPage {
        case review(ReceiptReviewCoordinator)
        case scanner
    }
    
    weak var delegate: NavigationDelegate?
    
    func build(page: Page) -> some View {
        switch page {
        case let .review(receiptReviewCoordinator):
            NavigationStackCoordinator(for: receiptReviewCoordinator.setup(delegate: self))
        case .scanner:
            ReceiptScannerView(viewModel: .init().setup(delegate: self))
        }
    }
    
    func pop(_ last: Int = 1) {
        delegate?.pop(last)
    }
    
    func popToRoot() {
        delegate?.popToRoot()
    }
    
    func push(_ page: Page, type: Navigation.PushType) {
        delegate?.push(page, type: type)
    }
    
    func dismissSheet(onDismiss: (() -> Void)? = nil) {
        delegate?.dismissSheet(onDismiss: onDismiss)
    }
    
    func dismissFullScreenCover(onDismiss: (() -> Void)? = nil) {
        delegate?.dismissFullScreenCover(onDismiss: onDismiss)
    }
}

// MARK: - Delegate Handlers

extension AddReceiptCoordinator: ReceiptScannerView.NavigationDelegate {
    func navigate(to destination: ReceiptScannerView.ViewModel.Destination) {
        switch destination {
        case let .dismiss(uiImage):
            dismissFullScreenCover { [weak self] in
                guard let self, let uiImage else { return }
                push(.review(.init(receiptReviewViewModel: .init(uiImage: uiImage))), type: .sheet)
            }
        }
    }
}

extension AddReceiptCoordinator: ReceiptReviewCoordinator.NavigationDelegate {
    func navigate(to destination: ReceiptReviewCoordinator.Destination) {
        switch destination {
        case let .dismiss(shouldShowScanner):
            dismissSheet(
                onDismiss: shouldShowScanner ? { self.push(.scanner, type: .fullScreenCover) } : nil
            )
        }
    }
}
