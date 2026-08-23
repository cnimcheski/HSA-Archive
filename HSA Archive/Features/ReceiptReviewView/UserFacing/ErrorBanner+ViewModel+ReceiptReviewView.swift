//
//  ErrorBanner+ViewModel+ReceiptReviewView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/3/26.
//

extension ErrorBanner.ViewModel {
    
    // MARK: - Gemini Errors
    
    static func rateLimited(
        onClose: @escaping () -> Void,
        onRetry: @escaping () -> Void
    ) -> Self {
        .init(
            "AI Temporarily Unavailable",
            message: "Too many requests are being processed. Please try again in a moment.",
            onClose: onClose,
            action: .retry(onRetry)
        )
    }
    
    static func invalidResponse(
        onClose: @escaping () -> Void,
        onRetry: @escaping () -> Void
    ) -> Self {
        .init(
            "Couldn't Read Receipt",
            message: "We couldn't extract the receipt details. You can try again or enter them manually.",
            onClose: onClose,
            action: .retry(onRetry)
        )
    }
    
    static func configuration(
        onClose: @escaping () -> Void,
        onRetry: @escaping () -> Void
    ) -> Self {
        .init(
            "Something Went Wrong",
            message: "Receipt scanning is currently unavailable. Please try again or enter the receipt manually.",
            onClose: onClose,
            action: .retry(onRetry)
        )
    }
    
    static func blockedBySafety(onClose: @escaping () -> Void) -> Self {
        .init(
            "Receipt Couldn't Be Processed",
            message: "This receipt couldn't be processed. Enter the details manually instead.",
            onClose: onClose
        )
    }
    
    static func general(
        onClose: @escaping () -> Void,
        onRetry: @escaping () -> Void
    ) -> Self {
        .init(
            "Something Went Wrong",
            message: "We couldn't process this receipt. Please try again.",
            onClose: onClose,
            action: .retry(onRetry)
        )
    }
    
    // MARK: - OCR Text Recognition Errors
    
    static func invalidImage(onClose: @escaping () -> Void) -> Self {
        .init(
            "Something Went Wrong",
            message: "We couldn't process this receipt. Please try again.",
            onClose: onClose
        )
    }
    
    static func recognitionFailed(
        onClose: @escaping () -> Void,
        onRetry: @escaping () -> Void
    ) -> Self {
        .init(
            "Something Went Wrong",
            message: "We couldn't process this receipt. Please try again.",
            onClose: onClose,
            action: .retry(onRetry)
        )
    }
}
