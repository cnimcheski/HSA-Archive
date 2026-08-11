//
//  ReceiptFileImporter.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/11/26.
//

import SwiftUI
import UniformTypeIdentifiers

extension View {
    /// Presents a file importer to the user.
    ///
    /// Use this method when you need to show a file importer using
    /// `ReceiptFileImporterViewModel` binding.
    ///
    /// ```
    /// struct ReceiptView: View {
    ///     @State private var fileImporterViewModel: ReceiptFileImporterViewModel?
    ///
    ///     var body: some View {
    ///         Button("Select File") {
    ///             fileImporterViewModel = .init { images in
    ///                 // Handle selected images
    ///             }
    ///         }
    ///         .receiptFileImporter(viewModel: $fileImporterViewModel)
    ///     }
    /// }
    /// ```
    @ViewBuilder
    func receiptFileImporter(
        viewModel: Binding<ReceiptFileImporterViewModel?>
    ) -> some View {
        modifier(FileImporterViewModifier(viewModel: viewModel))
    }
}

private struct FileImporterViewModifier: ViewModifier {
    @Binding private var viewModel: ReceiptFileImporterViewModel?

    init(viewModel: Binding<ReceiptFileImporterViewModel?>) {
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
        
        // Capture the view model before dismissal sets it to nil
        let presentedViewModel = viewModel

        content.fileImporter(
            isPresented: isPresented,
            allowedContentTypes: [.image], // TODO: - Support pdf documents later
            allowsMultipleSelection: true
        ) { presentedViewModel?.handleImportResult($0) }
    }
}
