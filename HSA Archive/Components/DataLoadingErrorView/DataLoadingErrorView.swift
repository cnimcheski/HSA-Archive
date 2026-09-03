//
//  DataLoadingErrorView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/2/26.
//

import SwiftUI

/// A view that displays a generic error when data fails to load.
struct DataLoadingErrorView: View {
    var body: some View {
        ContentUnavailableView(
            "Something Went Wrong",
            systemImage: "exclamationmark.triangle",
            description: Text("There was an error loading your data. Please try again.")
        )
    }
}

// MARK: - Previews

#Preview {
    DataLoadingErrorView()
}
