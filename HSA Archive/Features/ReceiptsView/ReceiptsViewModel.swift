//
//  ReceiptsViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import Combine
import Navigation

protocol ReceiptsViewModelDelegate: AnyObject {
    @MainActor func navigate(to destination: ReceiptsViewModel.Destination)
}

final class ReceiptsViewModel: ObservableObject, Navigating {
    enum Destination {
        case temp
    }
    
    weak var delegate: ReceiptsViewModelDelegate?
}
