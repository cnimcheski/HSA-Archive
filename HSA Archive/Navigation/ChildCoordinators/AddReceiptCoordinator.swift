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
        @MainActor func dismissSheet()
        @MainActor func dismissFullScreenCover()
    }
}

@MainActor
final class AddReceiptCoordinator: ChildCoordinator {
    enum Page: CoordinatedPage {
        case scanner(ReceiptScannerView.ViewModel)
        case review(ReceiptReviewView.ViewModel)
    }
    
    weak var delegate: NavigationDelegate?
    
    func build(page: Page) -> some View {
        switch page {
        case let .scanner(viewModel):
            ReceiptScannerView(viewModel: viewModel.setup(delegate: self))
        case let .review(viewModel):
            ReceiptReviewView(viewModel: viewModel.setup(delegate: self))
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
    
    func dismissSheet() {
        delegate?.dismissSheet()
    }
    
    func dismissFullScreenCover() {
        delegate?.dismissFullScreenCover()
    }
}

// MARK: - Delegate Handlers

extension AddReceiptCoordinator: ReceiptScannerView.NavigationDelegate {
    func navigate(to destination: ReceiptScannerView.ViewModel.Destination) {
        switch destination {
        case let .review(viewModel):
            push(.review(viewModel), type: .sheet())
        }
    }
}

extension AddReceiptCoordinator: ReceiptReviewView.NavigationDelegate {
    func navigate(to destination: ReceiptReviewView.ViewModel.Destination) {
        switch destination {
        case .dismiss:
            dismissSheet()
        }
    }
}
