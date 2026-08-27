//
//  InvalidReceiptsView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/25/26.
//

import SwiftUI

struct InvalidReceiptsView: View {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .navigationTitle("Invalid Receipts")
    }
}

// MARK: - Private Views

private extension InvalidReceiptsView {
    var content: some View {
        List(viewModel.failedRows) { failedRow in
            InvalidReceiptView(failedRow: failedRow)
        }
        .listStyle(.plain)
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        InvalidReceiptsView(
            viewModel: .init(
                failedRows: (1..<5).map { num in
                    .init(
                        rowNumber: num,
                        reason: ReceiptSpreadsheetDecoder.RowDecodeError.wrongColumnCount(num + 2).description
                    )
                }
            )
        )
    }
}
