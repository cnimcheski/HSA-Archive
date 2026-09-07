//
//  InvalidReceiptsButton.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/2/26.
//

import SwiftUI

/// A toolbar button for displaying and navigating to invalid receipts.
struct InvalidReceiptsButton: View {
    private let count: Int
    private let action: () -> Void
    
    init(count: Int, action: @escaping () -> Void) {
        self.count = count
        self.action = action
    }
    
    var body: some View {
        Button("View invalid receipts", systemImage: "exclamationmark.triangle", action: action)
            .adaptiveBadge(count, tint: .red)
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        Text("Placeholder")
            .toolbar {
                InvalidReceiptsButton(count: 3) {
                    // Do something when pressed
                }
            }
    }
}
