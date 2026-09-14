//
//  ProfileView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/13/26.
//

import SwiftUI

struct ProfileView: View {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Profile")
    }
}

// MARK: - Previews

#Preview {
    ProfileView(viewModel: .init())
}
