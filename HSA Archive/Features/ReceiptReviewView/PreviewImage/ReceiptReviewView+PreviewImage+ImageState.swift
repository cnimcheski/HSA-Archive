//
//  ReceiptReviewView+PreviewImage+ImageState.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/7/26.
//

import UIKit

nonisolated extension ReceiptReviewView.PreviewImage {
    enum ImageState {
        case loading
        case loaded(UIImage)
        case error(ImageError)
    }
}

// MARK: - Image Error

nonisolated extension ReceiptReviewView.PreviewImage.ImageState {
    enum ImageError {
        case unknown(retry: () async -> Void)
        case notFound
        
        var title: String {
            switch self {
            case .unknown:
                "Something Went Wrong"
            case .notFound:
                "Receipt Unavailable"
            }
        }
        
        var description: String {
            switch self {
            case .unknown:
                "The receipt image couldn’t be loaded."
            case .notFound:
                "The receipt image is no longer available."
            }
        }
        
        /// Returns the action used to retry loading the image, if available.
        var retry: (() async -> Void)? {
            switch self {
            case let .unknown(retry):
                retry
            case .notFound:
                nil
            }
        }
    }
}
