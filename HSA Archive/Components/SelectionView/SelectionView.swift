//
//  SelectionView.swift
//  climbto350
//
//  Created by Steve Nimcheski on 8/1/25.
//

import SwiftUI

struct SelectionView: View {
    @Bindable private var viewModel: ViewModel
    @FocusState private var isFocused: Bool
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.filteredItems) { item in
            itemButton(item)
        }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: viewModel.searchPlaceholder
        )
        .searchFocused($isFocused)
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .onAppear { isFocused = true }
    }
}

// MARK: - Private Views

private extension SelectionView {
    func itemButton(_ item: Selection) -> some View {
        Button {
            viewModel.selectItem(item)
        } label: {
            HStack {
                if let systemImage = item.systemImage {
                    Image(systemName: systemImage)
                }
                Text(item.title)
                if item.title == viewModel.selection {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    SelectionView(
        viewModel: .init(
            navigationTitle: "Title",
            searchPlaceholder: "Placeholder",
            items: [
                .init(title: "Dog", systemImage: "dog.fill"),
                .init(title: "Car", systemImage: "car.fill"),
                .init(title: "Person", systemImage: "person.fill")
            ],
            initialSelection: "Person",
            onSelect: { selection in
                // Do something with selection
            }
        )
    )
}
