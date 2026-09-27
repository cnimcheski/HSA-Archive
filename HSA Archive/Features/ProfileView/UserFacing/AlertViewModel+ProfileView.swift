//
//  AlertViewModel+ProfileView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/17/26.
//

import Dialogs

extension AlertViewModel {
    static func deleteAccount(delete: @escaping () -> Void) -> Self {
        .init(
            title: "Delete Your Account?",
            message: "This will permanently delete all of your HSA Archive receipts and spreadsheet from your Google Drive. You’ll also be signed out of HSA Archive. This action cannot be undone.",
            primaryButton: .init(
                title: "Delete",
                type: .destructive,
                action: delete
            ),
            secondaryButton: .cancelButton()
        )
    }
}
