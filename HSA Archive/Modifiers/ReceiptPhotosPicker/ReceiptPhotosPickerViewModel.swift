//
//  ReceiptPhotosPickerViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/10/26.
//

import PhotosUI
import SwiftUI
import Toast

@Observable
final class ReceiptPhotosPickerViewModel {
    let onDismiss: (() -> Void)?
    private let onCompletion: ([UIImage]) -> Void
    
    var selection: [PhotosPickerItem] {
        didSet { handleNewSelection(selection) }
    }

    init(
        onCompletion: @escaping ([UIImage]) -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.selection = []
        self.onCompletion = onCompletion
        self.onDismiss = onDismiss
    }
}

// MARK: - Private Methods

private extension ReceiptPhotosPickerViewModel {
    func handleNewSelection(_ selection: [PhotosPickerItem]) {
        guard !selection.isEmpty else { return }
        Task {
            let images = await getUIImages(from: selection)
            handlePhotoLoadFailures(failedCount: selection.count - images.count)
            onCompletion(images)
        }
    }
    
    /// Converts the `[PhotosPickerItem]` into `[UIImage]`.
    nonisolated func getUIImages(from selection: [PhotosPickerItem]) async -> [UIImage] {
        await withTaskGroup(of: UIImage?.self, returning: [UIImage].self) { group in
            for item in selection {
                group.addTask {
                    guard let data = try? await item.loadTransferable(type: Data.self),
                        let image = UIImage(data: data) else { return nil }
                    return image
                }
            }
            return await group.reduce(into: []) { images, image in
                if let image { images.append(image) }
            }
        }
    }
    
    /// Shows a Toast if any of the selected photos failed to load.
    func handlePhotoLoadFailures(failedCount: Int) {
        guard failedCount > 0 else { return }
        ToastManager.shared.show(DefaultToastType.photoPickerFailed(count: failedCount))
    }
}
