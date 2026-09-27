//
//  GrowthView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/26/26.
//

import SwiftUI

struct GrowthView: View {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Temp")
            .navigationTitle("Growth")
    }
}

// MARK: - Previews

#Preview {
    GrowthView(viewModel: .init())
}
