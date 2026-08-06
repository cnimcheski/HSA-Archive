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
        private let viewModel: ReceiptScannerView.ViewModel
        
        /// Creates a scanner that scans receipts.
        /// - Parameter viewModel: The ViewModel for the `ReceiptScannerView`.
        init(viewModel: ReceiptScannerView.ViewModel) {
            self.viewModel = viewModel
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
            parent.viewModel.onCompletion(result: .success(scan.images))
        }
        
        func documentCameraViewControllerDidCancel(
            _ controller: VNDocumentCameraViewController
        ) {
            parent.viewModel.dismiss()
        }
        
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFailWithError error: Error
        ) {
            parent.viewModel.onCompletion(result: .failure(error))
        }
    }
}
