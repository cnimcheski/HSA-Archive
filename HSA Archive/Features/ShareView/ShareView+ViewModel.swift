//
//  ShareView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/22/26.
//

import Foundation
import Navigation

extension ShareView {
    final class ViewModel: NavigationModel {
        let item: URL
        
        init(item: URL) {
            self.item = item
        }
    }
}
