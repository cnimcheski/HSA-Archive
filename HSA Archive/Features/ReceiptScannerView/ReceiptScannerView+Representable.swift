//
//  ReceiptScannerView+Representable.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/19/26.
//

import SwiftUI
import VisionKit

extension ReceiptScannerView {
    struct Representable: UIViewControllerRepresentable {
        @Environment(\.presentationMode) private var presentationMode
        
        private let onCompletion: (Result<[UIImage], Error>) -> Void
        
        /// Creates a scanner that scans receipts.
        /// - Parameter onCompletion: A callback that will be invoked when the scanning operation has succeeded or failed.
        init(onCompletion: @escaping (Result<[UIImage], Error>) -> Void) {
            self.onCompletion = onCompletion
        }
        
        func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
            let vc = VNDocumentCameraViewController()
            vc.delegate = context.coordinator
            return vc
        }
        
        func updateUIViewController(
            _ uiViewController: VNDocumentCameraViewController,
            context: Context
        ) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
    }
}

// MARK: - Private Methods

private extension ReceiptScannerView.Representable {
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - ReceiptScanner+Representable+Coordinator

extension ReceiptScannerView.Representable {
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private var parent: ReceiptScannerView.Representable
        
        init(_ parent: ReceiptScannerView.Representable) {
            self.parent = parent
        }
        
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan
        ) {
            parent.onCompletion(.success(scan.images))
            parent.dismiss()
        }
        
        func documentCameraViewControllerDidCancel(
            _ controller: VNDocumentCameraViewController
        ) {
            parent.dismiss()
        }
        
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFailWithError error: Error
        ) {
            parent.onCompletion(.failure(error))
            parent.dismiss()
        }
    }
}
