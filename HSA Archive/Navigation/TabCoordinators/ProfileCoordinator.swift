//
//  ProfileCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/13/26.
//

import Navigation
import SwiftUI

@Observable
final class ProfileCoordinator: StackCoordinator {
    enum Page: CoordinatedPage {
        case temp
    }
    
    var path: [Page] = []
    var sheet: Page?
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCover: Page?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    var rootView: some View {
        ProfileView(viewModel: profileViewModel)
    }
    
    private var profileViewModel = ProfileView.ViewModel()
    
    init() {
        profileViewModel = profileViewModel.setup(delegate: self)
    }
    
    func build(page: Page) -> some View {
        switch page {
        case .temp:
            Text("Temp")
        }
    }
}

// MARK: - Delegate Handlers

extension ProfileCoordinator: ProfileView.NavigationDelegate {
    func navigate(to destination: ProfileView.ViewModel.Destination) {
        switch destination {
        case .temp:
            print("temp") // TODO: - Add actual handling...
        }
    }
}
