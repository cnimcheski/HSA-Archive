//
//  ReceiptReviewView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/19/26.
//

import SwiftUI

struct ReceiptReviewView: View {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        // Using a `NavigationStack` here to be able to use the toolbar modifier
        NavigationStack {
            content
                .navigationTitle("Review Receipt")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        cancelButton
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        saveButton
                    }
                }
        }
    }
}

// MARK: - Private Views

private extension ReceiptReviewView {
    var content: some View {
        ScrollView {
            VStack {
                receiptImage
                // TODO: - Add actual text and stuff here.
                Text("Merchant:")
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
    
    var receiptImage: some View {
        Image(uiImage: viewModel.uiImage)
            .resizable()
            .scaledToFill()
            .frame(height: 200)
            .clipped()
    }
    
    var cancelButton: some View {
        Button {
            viewModel.dismiss()
        } label: {
            Label("Cancel", systemImage: "xmark")
        }
    }
    
    var saveButton: some View {
        Button {
            // TODO: - Add save functionality later...
        } label: {
            Label("Save", systemImage: "checkmark")
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        Text("Placeholder")
            .sheet(isPresented: .constant(true)) {
                ReceiptReviewView(
                    viewModel: .init(
                        uiImage: .init(systemName: "person.crop.rectangle.fill")!
                    )
                )
            }
    }
}
