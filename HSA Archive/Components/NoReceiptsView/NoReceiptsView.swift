//
//  NoReceiptsView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/2/26.
//

import SwiftUI

struct NoReceiptsView: View {
    var body: some View {
        ContentUnavailableView(
            "No Receipts Yet",
            systemImage: "receipt",
            description: Text("Add your first receipt using the plus button in the top right")
        )
    }
}

// MARK: - Previews

#Preview {
    NoReceiptsView()
}
