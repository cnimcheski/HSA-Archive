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
    
    /// Array of receipt reviews awaiting presentation so they can be presented one after the other.
    private var pendingReceiptReviewCoordinators = [ReceiptReviewCoordinator]()
    
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
    
    /// Creates review coordinators for the provided images and presents the first receipt.
    /// Used to present the receipts one by one.
    func startReviewBatch(uiImages: [UIImage]) {
        pendingReceiptReviewCoordinators = uiImages.map { .init(receiptReviewViewModel: .init(uiImage: $0)) }
        presentNextPendingReview()
    }
}

// MARK: - Private Methods

private extension AddReceiptCoordinator {
    /// Presents the next pending receipt if available.
    func presentNextPendingReview() {
        guard !pendingReceiptReviewCoordinators.isEmpty else { return }
        let receiptReviewCoordinator = pendingReceiptReviewCoordinators.removeFirst()
        push(.review(receiptReviewCoordinator), type: .sheet)
    }
}

// MARK: - Delegate Handlers

extension AddReceiptCoordinator: ReceiptScannerView.NavigationDelegate {
    func navigate(to destination: ReceiptScannerView.ViewModel.Destination) {
        switch destination {
        case let .dismiss(uiImages):
            dismissFullScreenCover { [weak self] in
                self?.startReviewBatch(uiImages: uiImages)
            }
        }
    }
}

extension AddReceiptCoordinator: ReceiptReviewCoordinator.NavigationDelegate {
    func navigate(to destination: ReceiptReviewCoordinator.Destination) {
        switch destination {
        case let .dismiss(shouldShowScanner):
            dismissSheet { [weak self] in
                guard let self else { return }
                if shouldShowScanner {
                    push(.scanner, type: .fullScreenCover)
                } else {
                    presentNextPendingReview()
                }
            }
        }
    }
}
