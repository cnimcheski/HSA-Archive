//
//  ReceiptsCoordinator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/9/26.
//

import Combine
import Navigation
import SwiftUI

final class ReceiptsCoordinator: StackCoordinator {
    enum Page: CoordinatedPage {
        case temp
    }
    
    @Published var path: [Page] = []
    @Published var sheet: Page?
    @Published var fullScreenCover: Page?
    
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
