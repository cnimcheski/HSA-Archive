//
//  ReceiptReviewView+PreviewImage.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/7/26.
//

import SwiftUI

extension ReceiptReviewView {
    struct PreviewImage: View {
        private let imageState: ImageState
        
        init(imageState: ImageState) {
            self.imageState = imageState
        }
        
        var body: some View {
            // Use the parent's available width so the image fills its container and clips correctly.
            GeometryReader { proxy in
                switch imageState {
                case .loading:
                    loadingView
                case let .loaded(uiImage):
                    imageView(uiImage, proxy: proxy)
                case let .error(imageError):
                    errorView(imageError)
                }
            }
            .frame(height: 200)
        }
    }
}

// MARK: - Private Views

private extension ReceiptReviewView.PreviewImage {
    var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func imageView(_ uiImage: UIImage, proxy: GeometryProxy) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Spacing.large))
    }
    
    func errorView(_ error: ImageState.ImageError) -> some View {
        ContentUnavailableView {
            Label(error.title, systemImage: "exclamationmark.triangle")
        } description: {
            Text(error.description)
        } actions: {
            if let retry = error.retry {
                Button("Retry") {
                    Task {
                        await retry()
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    VStack {
        ReceiptReviewView.PreviewImage(imageState: .loading)
        ReceiptReviewView.PreviewImage(imageState: .loaded(.init(systemName: "list.bullet.rectangle.fill")!))
        ReceiptReviewView.PreviewImage(imageState: .error(.notFound))
    }
    .padding()
}
