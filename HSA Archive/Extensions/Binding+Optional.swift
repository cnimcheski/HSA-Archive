//
//  Binding+Optional.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/25/26.
//

import SwiftUI

func ??<T>(optionalBinding: Binding<T?>, defaultValue: T) -> Binding<T> {
    Binding<T>(
        get: { optionalBinding.wrappedValue ?? defaultValue },
        set: { optionalBinding.wrappedValue = $0 }
    )
}
