//
//  ReceiptReviewView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/19/26.
//

import Dialogs
import FactoryKit
import Navigation
import SwiftUI

extension ReceiptReviewView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension ReceiptReviewView {
    @Observable
    final class ViewModel: NavigationModel, Navigating {
        enum Destination {
            case categorySelection(SelectionView.ViewModel)
            case dismiss(shouldShowScanner: Bool)
            case fullImage(FullImageView.ViewModel)
            case signIn(SignInView.ViewModel)
        }
        
        enum Constants {
            static let errorBannerAnimation = Animation.easeInOut
        }
        
        private let aiClient = Container.shared.aiClient()
        private let googleAuthService = Container.shared.googleAuthService()
        private let receiptRepository = Container.shared.receiptRepository()
        private let textRecognizer = Container.shared.textRecognizer()
        
        let uiImage: UIImage
        
        weak var delegate: NavigationDelegate?
        
        var alertViewModel: AlertViewModel?
        
        var displayedReceipt: Binding<Receipt> {
            isLoading
                ? .constant(Placeholders.receipt)
                : Binding(
                    get: { self.receipt },
                    set: { self.receipt = $0 }
                )
        }
        
        var isSaveDisabled: Bool {
            isSaving
                || isLoading
                || receipt.merchant.isEmpty
                || receipt.amount.isZero
        }
        
        private(set) var errorBannerViewModel: ErrorBanner.ViewModel?
        private(set) var isLoading = true
        private var isSaving = false
        private var receipt = Receipt.empty
        
        init(uiImage: UIImage) {
            self.uiImage = uiImage
        }
        
        func extractReceiptDetails() async {
            defer { isLoading = false }
            do {
                let receiptText = try await textRecognizer.recognizeText(from: uiImage).text
                guard let response = try await aiClient.generate(
                    ReceiptExtractionRequest(text: receiptText)
                ) else {
                    handleGeneralError()
                    return
                }
                handleReceiptExtractionResponse(response)
            } catch let error as TextRecognitionError {
                handleTextRecognitionError(error)
            } catch let error as GeminiError {
                handleGeminiError(error)
            } catch {
                handleGeneralError()
            }
        }
        
        func showFullImageView() {
            delegate?.navigate(to: .fullImage(.init(uiImage: uiImage)))
        }
        
        func showCategorySelectionView() {
            delegate?.navigate(
                to: .categorySelection(
                    .init(
                        navigationTitle: AppConstants.categoryPrompt,
                        searchPlaceholder: AppConstants.categorySearchPlaceholder,
                        items: Category.allCases.map { $0.selection },
                        initialSelection: receipt.category.rawValue,
                        onSelect: { [weak self] selection in
                            // TODO: - Maybe a better default here...
                            self?.receipt.category = .init(rawValue: selection.title) ?? .other
                        }
                    )
                )
            )
        }
        
        func save() async {
            defer { isSaving = false }
            isSaving = true
            
            guard googleAuthService.isSignedIn else {
                showSignInView()
                return
            }
            guard await receiptRepository.add(receipt, uiImage: uiImage) != nil else { return }
            dismiss()
        }
        
        func dismiss(shouldShowScanner: Bool = false) {
            delegate?.navigate(to: .dismiss(shouldShowScanner: shouldShowScanner))
        }
    }
}

// MARK: - Private Methods

private extension ReceiptReviewView.ViewModel {
    func retryExtractReceiptDetails() {
        // Resets error banner and loading state before launching Task so that banner disappears instantly
        dismissErrorBanner()
        isLoading = true
        Task {
            await extractReceiptDetails()
        }
    }
    
    func handleReceiptExtractionResponse(_ response: ReceiptExtractionResponse) {
        switch response {
        case let .success(fields):
            receipt = .init(from: fields)
        case .unreadable:
            alertViewModel = .unreadable(handleScanAgain: handleScanAgain)
        case .noEligibleExpenses:
            alertViewModel = .noEligibleExpenses(handleScanAgain: handleScanAgain)
        case .notReceipt:
            alertViewModel = .notReceipt(handleScanAgain: handleScanAgain)
        }
    }
    
    func handleGeminiError(_ error: GeminiError) {
        switch error {
        case .rateLimited:
            showErrorBanner(.rateLimited(onClose: dismissErrorBanner, onRetry: retryExtractReceiptDetails))
        case .invalidResponse:
            showErrorBanner(.invalidResponse(onClose: dismissErrorBanner, onRetry: retryExtractReceiptDetails))
        case .configuration:
            showErrorBanner(.configuration(onClose: dismissErrorBanner, onRetry: retryExtractReceiptDetails))
        case .blockedBySafety:
            showErrorBanner(.blockedBySafety(onClose: dismissErrorBanner))
        case .unknown:
            showErrorBanner(.general(onClose: dismissErrorBanner, onRetry: retryExtractReceiptDetails))
        }
    }
    
    func handleGeneralError() {
        showErrorBanner(.general(onClose: dismissErrorBanner, onRetry: retryExtractReceiptDetails))
    }
    
    func handleTextRecognitionError(_ error: TextRecognitionError) {
        switch error {
        case .invalidImage:
            showErrorBanner(.invalidImage(onClose: dismissErrorBanner))
        case .recognitionFailed:
            showErrorBanner(.recognitionFailed(onClose: dismissErrorBanner, onRetry: retryExtractReceiptDetails))
        case .unusuableText:
            alertViewModel = .notReceipt(handleScanAgain: handleScanAgain)
        case .noTextFound:
            alertViewModel = .unreadable(handleScanAgain: handleScanAgain)
        }
    }
    
    func showErrorBanner(_ viewModel: ErrorBanner.ViewModel) {
        withAnimation(Constants.errorBannerAnimation) {
            errorBannerViewModel = viewModel
        }
    }
    
    func dismissErrorBanner() {
        withAnimation(Constants.errorBannerAnimation) {
            errorBannerViewModel = nil
        }
    }
    
    func handleScanAgain() {
        dismiss(shouldShowScanner: true)
    }
    
    func showSignInView() {
        delegate?.navigate(
            to: .signIn(
                .init(
                    onSuccess: {
                        Task {
                            await self.save()
                        }
                    }
                )
            )
        )
    }
}
