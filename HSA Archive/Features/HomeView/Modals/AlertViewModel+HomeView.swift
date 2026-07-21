//
//  AlertViewModel+HomeView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/20/26.
//

import Dialogs

extension AlertViewModel {
    static var scannerError: Self {
        .init(
            title: "Unable to Scan Receipt",
            message: "Something went wrong while using the receipt scanner. Please try again.",
            primaryButton: .okButton()
        )
    }
}
