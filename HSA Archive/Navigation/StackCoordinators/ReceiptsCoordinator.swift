//
//  ReceiptsCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Navigation
import SwiftUI

@Observable
final class ReceiptsCoordinator: StackCoordinator {
    enum Page: CoordinatedPage {
        case temp
    }
    
    var path: [Page] = []
    var sheet: Page?
    var sheetOnDismiss: (() -> Void)?
    var fullScreenCover: Page?
    var fullScreenCoverOnDismiss: (() -> Void)?
    
    var rootView: some View {
        ReceiptsView()
    }
    
    func build(page: Page) -> some View {
        switch page {
        case .temp:
            EmptyView()
        }
    }
}
