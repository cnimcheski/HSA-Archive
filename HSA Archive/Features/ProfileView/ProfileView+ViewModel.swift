//
//  ProfileView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/13/26.
//

import Dialogs
import FactoryKit
import Foundation
import Navigation
import Observation

extension ProfileView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension ProfileView {
    @Observable
    final class ViewModel: Navigating {
        enum Destination {
            case share(ShareView.ViewModel)
            case signIn(SignInView.ViewModel)
        }
        
        private let googleAccountService = Container.shared.googleAccountService()
        private let receiptRepository = Container.shared.receiptRepository()
        private let userDefaultsManager = Container.shared.userDefaultsManager()
        
        weak var delegate: NavigationDelegate?
        
        var alertViewModel: AlertViewModel?
        
        var spreadsheetURL: URL? {
            guard let spreadsheetID = userDefaultsManager.spreadsheetID else { return nil }
            return URL(string: "https://docs.google.com/spreadsheets/d/\(spreadsheetID)/edit")
        }
        
        var receiptsFolderURL: URL? {
            guard let receiptsFolderID = userDefaultsManager.receiptsFolderID else { return nil }
            return URL(string: "https://drive.google.com/drive/folders/\(receiptsFolderID)")
        }
        
        private(set) var isExportingReceipts = false
        private(set) var isDeletingAccount = false
        
        func showSignInView() {
            delegate?.navigate(to: .signIn(.init()))
        }
        
        func exportReceipts() async {
            defer { isExportingReceipts = false }
            isExportingReceipts = true
            guard let url = await receiptRepository.exportReceipts() else { return }
            delegate?.navigate(to: .share(.init(item: url)))
        }
        
        func confirmDeleteAccount() {
            alertViewModel = .deleteAccount {
                Task {
                    await self.deleteAccount()
                }
            }
        }
    }
}

// MARK: - Private Methods

private extension ProfileView.ViewModel {
    func deleteAccount() async {
        defer { isDeletingAccount = false }
        isDeletingAccount = true
        _ = await googleAccountService.deleteAccount()
    }
}
