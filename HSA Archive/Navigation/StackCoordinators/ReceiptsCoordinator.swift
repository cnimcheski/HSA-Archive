//
//  ReceiptsCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Navigation
import SwiftUI

@MainActor
@Observable
final class ReceiptsCoordinator: StackCoordinator {
    enum Page: CoordinatedPage {
        case temp
    }
    
    var path: [Page] = []
    var sheet: Modal<Page>?
    var fullScreenCover: Modal<Page>?
    
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
