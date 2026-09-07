//
//  ReceiptFiltersCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/4/26.
//

import Navigation
import SwiftUI

extension ReceiptFiltersCoordinator {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: Destination)
    }
}

/// This `StackCoordinator` also conforms to `Navigating` and therefore has its own `NavigationDelegate`
/// since it needs to send a signal back to dismiss itself.
@Observable
final class ReceiptFiltersCoordinator: StackCoordinator, Navigating, NavigationModel {
    enum Page: CoordinatedPage {
        case categoriesSelection(MultiSelectionView.ViewModel)
    }
    
    enum Destination {
        case dismiss
    }
    
    private let receiptFiltersViewModel: ReceiptFiltersView.ViewModel
    
    weak var delegate: NavigationDelegate?
    
    var path: [Page] = []
    var sheet: Page?
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCover: Page?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    var rootView: some View {
        ReceiptFiltersView(viewModel: receiptFiltersViewModel.setup(delegate: self))
    }
    
    init(receiptFiltersViewModel: ReceiptFiltersView.ViewModel) {
        self.receiptFiltersViewModel = receiptFiltersViewModel
    }
    
    func build(page: Page) -> some View {
        switch page {
        case let .categoriesSelection(viewModel):
            MultiSelectionView(viewModel: viewModel.setup(delegate: self))
        }
    }
}

// MARK: Delegate Handlers

extension ReceiptFiltersCoordinator: ReceiptFiltersView.NavigationDelegate {
    func navigate(to destination: ReceiptFiltersView.ViewModel.Destination) {
        switch destination {
        case let .categoriesSelection(viewModel):
            push(.categoriesSelection(viewModel))
        case .dismiss:
            delegate?.navigate(to: .dismiss)
        }
    }
}

extension ReceiptFiltersCoordinator: MultiSelectionView.NavigationDelegate {
    func navigate(to destination: MultiSelectionView.ViewModel.Destination) {
        switch destination {
        case .pop:
            pop()
        }
    }
}
