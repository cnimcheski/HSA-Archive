//
//  ReceiptsCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Navigation
import SwiftUI

@Observable
final class ReceiptsCoordinator: StackCoordinator {
    enum Page: CoordinatedPage {
        case addReceiptCoordinator(AddReceiptCoordinator.Page)
        case filters(ReceiptFiltersCoordinator)
        case invalidReceipts(InvalidReceiptsView.ViewModel)
        case signIn(SignInView.ViewModel)
    }
    
    var path: [Page] = []
    var sheet: Page?
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCover: Page?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    var rootView: some View {
        @Bindable var coordinator = self
        return ReceiptsView(viewModel: receiptsViewModel)
            .receiptFileImporter(viewModel: $coordinator.fileImporterViewModel)
            .receiptPhotosPicker(viewModel: $coordinator.photosPickerViewModel)
    }
    
    private var receiptsViewModel = ReceiptsView.ViewModel()
    private var addReceiptCoordinator = AddReceiptCoordinator()
    private var fileImporterViewModel: ReceiptFileImporterViewModel?
    private var photosPickerViewModel: ReceiptPhotosPickerViewModel?
    
    init() {
        receiptsViewModel = receiptsViewModel.setup(delegate: self)
        addReceiptCoordinator = addReceiptCoordinator.setup(delegate: self)
    }
    
    func build(page: Page) -> some View {
        switch page {
        case let .addReceiptCoordinator(page):
            addReceiptCoordinator.build(page: page)
        case let .filters(filtersCoordinator):
            NavigationStackCoordinator(for: filtersCoordinator.setup(delegate: self))
        case let .invalidReceipts(viewModel):
            InvalidReceiptsView(viewModel: viewModel)
        case let .signIn(viewModel):
            SignInView(viewModel: viewModel.setup(delegate: self))
        }
    }
}

// MARK: - Private Methods

private extension ReceiptsCoordinator {
    func handleSelectedImages(_ uiImages: [UIImage]) {
        // TODO: - Use all images instead of just first
        guard let uiImage = uiImages.first else { return }
        push(.addReceiptCoordinator(.review(.init(receiptReviewViewModel: .init(uiImage: uiImage)))), type: .sheet)
    }
}

// MARK: - Delegate Handlers

extension ReceiptsCoordinator: ReceiptsView.NavigationDelegate {
    func navigate(to destination: ReceiptsView.ViewModel.Destination) {
        switch destination {
        case .scanner:
            push(.addReceiptCoordinator(.scanner), type: .fullScreenCover)
        case .filePicker:
            fileImporterViewModel = .init(onCompletion: handleSelectedImages)
        case .photosPicker:
            photosPickerViewModel = .init(onCompletion: handleSelectedImages)
        case let .filters(receiptFiltersViewModel):
            push(.filters(.init(receiptFiltersViewModel: receiptFiltersViewModel)), type: .sheet)
        case let .invalidReceipts(viewModel):
            push(.invalidReceipts(viewModel))
        case let .reviewReceipt(receiptReviewViewModel):
            push(.addReceiptCoordinator(.review(.init(receiptReviewViewModel: receiptReviewViewModel))), type: .sheet)
        case let .signIn(viewModel):
            push(.signIn(viewModel), type: .fullScreenCover)
        }
    }
}

extension ReceiptsCoordinator: AddReceiptCoordinator.NavigationDelegate {
    func push(_ page: AddReceiptCoordinator.Page, type: Navigation.PushType) {
        push(.addReceiptCoordinator(page), type: type)
    }
}

extension ReceiptsCoordinator: SignInView.NavigationDelegate {
    func navigate(to destination: SignInView.ViewModel.Destination) {
        switch destination {
        case .dismiss:
            dismissFullScreenCover()
        }
    }
}

extension ReceiptsCoordinator: ReceiptFiltersCoordinator.NavigationDelegate {
    func navigate(to destination: ReceiptFiltersCoordinator.Destination) {
        switch destination {
        case .dismiss:
            dismissSheet()
        }
    }
}
