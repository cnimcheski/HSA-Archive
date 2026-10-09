//
//  ReceiptSpreadsheetService+Folder.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 10/7/26.
//

import FactoryKit

extension ReceiptSpreadsheetService {
    /// Represents a managed HSA Archive folder and its persisted Drive ID.
    enum Folder {
        case archive
        case receipts
        
        var name: String {
            switch self {
            case .archive: AppConstants.archiveFolderName
            case .receipts: AppConstants.receiptsFolderName
            }
        }
        
        var parent: Folder? {
            switch self {
            case .archive: nil
            case .receipts: .archive
            }
        }
        
        var id: String? {
            switch self {
            case .archive: userDefaultsManager.archiveFolderID
            case .receipts: userDefaultsManager.receiptsFolderID
            }
        }
        
        private var userDefaultsManager: UserDefaultsManager { Container.shared.userDefaultsManager() }
        
        func set(id: String) {
            switch self {
            case .archive: userDefaultsManager.setArchiveFolderID(id)
            case .receipts: userDefaultsManager.setReceiptsFolderID(id)
            }
        }
        
        func clearID() {
            switch self {
            case .archive: userDefaultsManager.clearArchiveFolderID()
            case .receipts: userDefaultsManager.clearReceiptsFolderID()
            }
        }
    }
}
