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
        let images = urls.securityScopedUIImages
        handleFileLoadFailures(failedCount: urls.count - images.count)
        onCompletion(images)
    }
}

// MARK: - Private Methods

private extension ReceiptFileImporterViewModel {
    /// Shows a Toast if any of the selected files failed to load.
    func handleFileLoadFailures(failedCount: Int) {
        guard failedCount > 0 else { return }
        ToastManager.shared.show(DefaultToastType.fileImporterFailed(count: failedCount))
    }
}

