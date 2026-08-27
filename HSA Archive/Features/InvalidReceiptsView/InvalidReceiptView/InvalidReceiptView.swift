//
//  InvalidReceiptView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/26/26.
//

import SwiftUI

struct InvalidReceiptView: View {
    private let failedRow: ReceiptSpreadsheetDecoder.Response.FailedRow
    
    init(failedRow: ReceiptSpreadsheetDecoder.Response.FailedRow) {
        self.failedRow = failedRow
    }
    
    var body: some View {
        HStack(spacing: Theme.Spacing.medium) {
            failureIcon
            failureDescription
        }
    }
}

// MARK: - Private Views

private extension InvalidReceiptView {
    var failureIcon: some View {
        Image(systemName: "exclamationmark.triangle")
            .foregroundStyle(.red)
            .defaultCardStyle(backgroundColor: .red.withBackgroundOpacity)
    }
    
    var failureDescription: some View {
        VStack(alignment: .leading) {
            Text("Row \(failedRow.rowNumber)")
                .font(.headline)
            Text(failedRow.reason)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Previews

#Preview {
    List {
        ForEach(1..<5, id: \.self) { num in
            InvalidReceiptView(
                failedRow: .init(
                    rowNumber: num,
                    reason: ReceiptSpreadsheetDecoder.RowDecodeError.wrongColumnCount(num + 2).description
                )
            )
        }
    }
    .listStyle(.plain)
}
