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
        case signIn(SignInView.ViewModel)
        case invalidReceipts(InvalidReceiptsView.ViewModel)
    }
    
    var path: [Page] = []
    var sheet: Page?
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCover: Page?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    var rootView: some View {
        @Bindable var coordinator = self
        return HomeView(viewModel: homeViewModel)
            .receiptFileImporter(viewModel: $coordinator.fileImporterViewModel)
            .receiptPhotosPicker(viewModel: $coordinator.photosPickerViewModel)
    }
    
    private var homeViewModel = HomeView.ViewModel()
    private var addReceiptCoordinator = AddReceiptCoordinator()
    private var fileImporterViewModel: ReceiptFileImporterViewModel?
    private var photosPickerViewModel: ReceiptPhotosPickerViewModel?
    
    init() {
        homeViewModel = homeViewModel.setup(delegate: self)
        addReceiptCoordinator = addReceiptCoordinator.setup(delegate: self)
    }
    
    func build(page: Page) -> some View {
        switch page {
        case let .addReceiptCoordinator(page):
            addReceiptCoordinator.build(page: page)
        case let .signIn(viewModel):
            SignInView(viewModel: viewModel.setup(delegate: self))
        case let .invalidReceipts(viewModel):
            InvalidReceiptsView(viewModel: viewModel)
        }
    }
}

// MARK: - Private Methods

private extension HomeCoordinator {
    func handleSelectedImages(_ uiImages: [UIImage]) {
        // TODO: - Use all images instead of just first
        guard let uiImage = uiImages.first else { return }
        push(.addReceiptCoordinator(.review(.init(receiptReviewViewModel: .init(uiImage: uiImage)))), type: .sheet)
    }
}

// MARK: - Delegate Handlers

extension HomeCoordinator: HomeView.NavigationDelegate {
    func navigate(to destination: HomeView.ViewModel.Destination) {
        switch destination {
        case .filePicker:
            fileImporterViewModel = .init(onCompletion: handleSelectedImages)
        case .photosPicker:
            photosPickerViewModel = .init(onCompletion: handleSelectedImages)
        case .scanner:
            push(.addReceiptCoordinator(.scanner), type: .fullScreenCover)
        case let .signIn(viewModel):
            push(.signIn(viewModel), type: .fullScreenCover)
        case let .invalidReceipts(viewModel):
            push(.invalidReceipts(viewModel))
        }
    }
}

extension HomeCoordinator: AddReceiptCoordinator.NavigationDelegate {
    func push(_ page: AddReceiptCoordinator.Page, type: Navigation.PushType) {
        push(.addReceiptCoordinator(page), type: type)
    }
}

extension HomeCoordinator: SignInView.NavigationDelegate {
    func navigate(to destination: SignInView.ViewModel.Destination) {
        switch destination {
        case .dismiss:
            dismissFullScreenCover()
        }
    }
}
