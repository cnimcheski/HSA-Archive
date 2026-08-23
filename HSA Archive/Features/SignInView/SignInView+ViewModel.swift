//
//  SignInView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/12/26.
//

import FactoryKit
import Navigation
import Observation
import Toast

extension SignInView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension SignInView {
    @Observable
    final class ViewModel: NavigationModel, Navigating {
        enum Destination {
            case dismiss
        }
        
        private let googleAuthService = Container.shared.googleAuthService()
        private let googleDriveService = Container.shared.googleDriveService()
        private let receiptSpreadsheetService = Container.shared.receiptSpreadsheetService()
        
        private let onSuccess: () -> Void
        
        weak var delegate: NavigationDelegate?
        
        private(set) var isSigningIn = false
        
        init(onSuccess: @escaping () -> Void) {
            self.onSuccess = onSuccess
        }
        
        func signIn() async {
            defer { isSigningIn = false }
            isSigningIn = true
            
            guard await googleAuthService.signIn() != nil else { return }
            if await googleDriveService.existingSpreadsheetID() == nil {
                guard await receiptSpreadsheetService.setupSpreadsheet() != nil else { return }
                ToastManager.shared.show(DefaultToastType.spreadsheetCreated)
            }
            onSuccess()
            close()
        }
        
        func close() {
            delegate?.navigate(to: .dismiss)
        }
    }
}
