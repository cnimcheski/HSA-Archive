//
//  ErrorBanner+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/3/26.
//

extension ErrorBanner {
    final class ViewModel: Equatable {
        let title: String
        let message: String
        let onClose: () -> Void
        let action: Action?
        
        init(
            _ title: String,
            message: String,
            onClose: @escaping () -> Void,
            action: Action? = nil
        ) {
            self.title = title
            self.message = message
            self.onClose = onClose
            self.action = action
        }
        
        /// Ensures two instances of this ViewModel are always considered different for animations.
        static func == (lhs: ErrorBanner.ViewModel, rhs: ErrorBanner.ViewModel) -> Bool {
            lhs === rhs
        }
    }
}
