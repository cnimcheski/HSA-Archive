//
//  ConfirmationDialogViewModel+HomeView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/7/26.
//

import Dialogs

extension ConfirmationDialogViewModel {
    static func uploadReceipt(
        showReceiptScanner: @escaping () -> Void,
        showFileImporter: @escaping () -> Void,
        showPhotosPicker: @escaping () -> Void
    ) -> Self {
        .cancelConfirmationDialog(
            message: "Where would you like to import your receipt from?",
            buttons: [
                .init(title: "Scan Receipt", action: showReceiptScanner),
                .init(title: "Browse Files", action: showFileImporter),
                .init(title: "Choose from Photos", action: showPhotosPicker)
            ]
        )
    }
}
