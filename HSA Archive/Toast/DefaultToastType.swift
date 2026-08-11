//
//  DefaultToastType.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/8/26.
//

import SwiftUI
import Toast

enum DefaultToastType: ToastType {
    case fileImporterFailed(count: Int)
    case photoPickerFailed(count: Int)
    
    var message: LocalizedStringKey {
        switch self {
        case let .fileImporterFailed(count):
            "^[\(count) file](inflect: true) couldn't be loaded."
        case let .photoPickerFailed(count):
            "^[\(count) photo](inflect: true) couldn't be loaded."
        }
    }
    
    var defaultDuration: Double {
        switch self {
        default:
            5
        }
    }
}
