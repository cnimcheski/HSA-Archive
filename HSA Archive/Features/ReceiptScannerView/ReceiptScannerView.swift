//
//  ReceiptScannerView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/19/26.
//

import Dialogs
import SwiftUI

struct ReceiptScannerView: View {
    @Bindable private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Representable(viewModel: viewModel)
            .ignoresSafeArea()
            .alert(viewModel: $viewModel.alertViewModel)
    }
}

// MARK: - Previews

#Preview {
    ReceiptScannerView(viewModel: .init())
}
