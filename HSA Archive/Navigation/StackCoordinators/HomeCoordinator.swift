//
//  HomeCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Navigation
import SwiftUI

@Observable
final class HomeCoordinator: StackCoordinator {
    enum Page: CoordinatedPage {
        case addReceiptCoordinator(AddReceiptCoordinator.Page)
    }
    
    var path: [Page] = []
    var sheet: Page?
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCover: Page?
    var fullScreenCoverOnDismiss: (() -> Void)?
    var photosPickerViewModel: ReceiptPhotosPickerViewModel?
    
    var rootView: some View {
        @Bindable var coordinator = self
        return HomeView(viewModel: homeViewModel)
            .receiptPhotosPicker(viewModel: $coordinator.photosPickerViewModel)
    }
    
    private var homeViewModel = HomeView.ViewModel()
    private var addReceiptCoordinator = AddReceiptCoordinator()
    
    init() {
        homeViewModel = homeViewModel.setup(delegate: self)
        addReceiptCoordinator = addReceiptCoordinator.setup(delegate: self)
    }
    
    func build(page: Page) -> some View {
        switch page {
        case let .addReceiptCoordinator(page):
            addReceiptCoordinator.build(page: page)
        }
    }
}

// MARK: - Private Methods

private extension HomeCoordinator {
    func handlePhotosPickerSelections(_ uiImages: [UIImage]) {
        // TODO: - Use all images instead of just first
        guard let uiImage = uiImages.first else { return }
        push(.addReceiptCoordinator(.review(.init(receiptReviewViewModel: .init(uiImage: uiImage)))), type: .sheet)
    }
}

// MARK: - Delegate Handlers

extension HomeCoordinator: HomeView.NavigationDelegate {
    func navigate(to destination: HomeView.ViewModel.Destination) {
        switch destination {
        case .photosPicker:
            photosPickerViewModel = .init(onCompletion: handlePhotosPickerSelections)
        case .scanner:
            push(.addReceiptCoordinator(.scanner), type: .fullScreenCover)
        }
    }
}

extension HomeCoordinator: AddReceiptCoordinator.NavigationDelegate {
    func push(_ page: AddReceiptCoordinator.Page, type: Navigation.PushType) {
        push(.addReceiptCoordinator(page), type: type)
    }
}
