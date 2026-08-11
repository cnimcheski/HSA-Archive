//
//  ReceiptPhotosPicker.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/8/26.
//

import PhotosUI
import SwiftUI
import Toast

extension View {
    /// Presents a photo picker to the user.
    ///
    /// Use this method when you need to show a photo picker using
    /// `PhotosPickerViewModel` binding.
    ///
    /// ```
    /// struct ReceiptView: View {
    ///     @State private var photosPickerViewModel: ReceiptPhotosPickerViewModel?
    ///
    ///     var body: some View {
    ///         Button("Select Photos") {
    ///             photosPickerViewModel = .init { images in
    ///                 // Handle selected images
    ///             }
    ///         }
    ///         .photosPicker(viewModel: $photosPickerViewModel)
    ///     }
    /// }
    /// ```
    @ViewBuilder
    func receiptPhotosPicker(
        viewModel: Binding<ReceiptPhotosPickerViewModel?>
    ) -> some View {
        modifier(PhotosPickerViewModifier(viewModel: viewModel))
    }
}

private struct PhotosPickerViewModifier: ViewModifier {
    @Binding private var viewModel: ReceiptPhotosPickerViewModel?

    init(viewModel: Binding<ReceiptPhotosPickerViewModel?>) {
        _viewModel = viewModel
    }

    func body(content: Content) -> some View {
        let isPresented = Binding<Bool>(
            get: {
                viewModel != nil
            },
            set: { newValue in
                if !newValue {
                    viewModel?.onDismiss?()
                    viewModel = nil
                }
            }
        )

        content.photosPicker(
            isPresented: isPresented,
            selection: Binding(
                get: { viewModel?.selection ?? [] },
                set: { viewModel?.selection = $0 }
            ),
            matching: .images
        )
    }
}
