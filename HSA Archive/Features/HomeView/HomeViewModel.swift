//
//  HomeViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import Combine
import Navigation

protocol HomeViewModelDelegate: AnyObject {
    @MainActor func navigate(to destination: HomeViewModel.Destination)
}

final class HomeViewModel: ObservableObject, Navigating {
    enum Destination {
        // TODO: - Add actual navigational logic
        case temp
    }
    
    weak var delegate: HomeViewModelDelegate?
}
