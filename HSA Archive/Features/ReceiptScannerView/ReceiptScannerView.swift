//
//  ReceiptScannerView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/19/26.
//

import SwiftUI

struct ReceiptScannerView: View {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Representable(onCompletion: viewModel.onCompletion)
            .ignoresSafeArea()
    }
}

// MARK: - Previews

#Preview {
    ReceiptScannerView(viewModel: .init(onError: {}))
}
