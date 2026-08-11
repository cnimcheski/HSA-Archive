//
//  ReceiptFileImporterViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/11/26.
//

import SwiftUI
import Toast

@Observable
final class ReceiptFileImporterViewModel {
    let onDismiss: (() -> Void)?
    private let onCompletion: ([UIImage]) -> Void

    init(
        onCompletion: @escaping ([UIImage]) -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.onCompletion = onCompletion
        self.onDismiss = onDismiss
    }
    
    func handleImportResult(_ result: Result<[URL], any Error>) {
        guard case let .success(urls) = result, !urls.isEmpty else { return }
        let images = getUIImages(from: urls)
        handleFileLoadFailures(failedCount: urls.count - images.count)
        onCompletion(images)
    }
}

// MARK: - Private Methods

private extension ReceiptFileImporterViewModel {
    /// Converts the `[URL]` into `[UIImage]`.
    nonisolated func getUIImages(from urls: [URL]) -> [UIImage] {
        urls.compactMap { url in
            guard url.startAccessingSecurityScopedResource() else { return nil }
            defer { url.stopAccessingSecurityScopedResource() }
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return nil }
            return image
        }
    }

    /// Shows a Toast if any of the selected files failed to load.
    func handleFileLoadFailures(failedCount: Int) {
        guard failedCount > 0 else { return }
        ToastManager.shared.show(DefaultToastType.fileImporterFailed(count: failedCount))
    }
}

