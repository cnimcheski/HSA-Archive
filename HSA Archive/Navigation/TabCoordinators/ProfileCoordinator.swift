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
        case share(ShareView.ViewModel)
        case signIn(SignInView.ViewModel)
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
        case let .share(viewModel):
            ShareView(viewModel: viewModel)
        case let .signIn(viewModel):
            SignInView(viewModel: viewModel.setup(delegate: self))
        }
    }
}

// MARK: - Delegate Handlers

extension ProfileCoordinator: ProfileView.NavigationDelegate {
    func navigate(to destination: ProfileView.ViewModel.Destination) {
        switch destination {
        case let .share(viewModel):
            push(.share(viewModel), type: .sheet)
        case let .signIn(viewModel):
            push(.signIn(viewModel), type: .fullScreenCover)
        }
    }
}

extension ProfileCoordinator: SignInView.NavigationDelegate {
    func navigate(to destination: SignInView.ViewModel.Destination) {
        switch destination {
        case .dismiss:
            dismissFullScreenCover()
        }
    }
}
