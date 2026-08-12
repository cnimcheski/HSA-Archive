//
//  FullImageView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/11/26.
//

import Navigation
import UIKit

extension FullImageView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension FullImageView {
    final class ViewModel: NavigationModel, Navigating {
        enum Destination {
            case dismiss
        }
        
        let uiImage: UIImage
        
        weak var delegate: NavigationDelegate?
        
        init(uiImage: UIImage) {
            self.uiImage = uiImage
        }
        
        func close() {
            delegate?.navigate(to: .dismiss)
        }
    }
}
