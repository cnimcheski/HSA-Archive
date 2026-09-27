//
//  ShareView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/22/26.
//

import SwiftUI

struct ShareView: View {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ShareViewRepresentable(items: [viewModel.item])
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.hidden)
    }
}

// MARK: - ShareViewRepresentable

private struct ShareViewRepresentable: UIViewControllerRepresentable {
    private let items: [Any]
    
    init(items: [Any]) {
        self.items = items
    }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

#Preview {
    Text("placeholder")
        .sheet(isPresented: .constant(true)) {
            ShareView(viewModel: .init(item: URL(string: "https://www.google.com")!))
        }
}
