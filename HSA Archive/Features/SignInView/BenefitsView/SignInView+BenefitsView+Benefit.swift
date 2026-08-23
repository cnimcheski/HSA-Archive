//
//  SignInView+BenefitView+Benefit.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/12/26.
//

extension SignInView.BenefitsView {
    enum Benefit: CaseIterable {
        case googleDrive
        case appIndependent
        
        var title: String {
            switch self {
            case .googleDrive:
                "Your Google Drive"
            case .appIndependent:
                "Never tied to the app"
            }
        }
        
        var subtitle: String {
            switch self {
            case .googleDrive:
                "Saves straight to Sheets"
            case .appIndependent:
                "Uninstall, keep your data"
            }
        }
        
        var systemImage: String {
            switch self {
            case .googleDrive:
                "folder"
            case .appIndependent:
                "shield"
            }
        }
    }
}
