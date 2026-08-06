//
//  Sync.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/25/25.
//

import SwiftUI

extension View {
    /// Sync's a viewModel property with a view property.
    /// Commenly used with `@FocusState` properties.
    func sync<ModelValue: Syncable, ViewValue: Syncable>(
        _ modelValue: ModelValue, to viewValue: ViewValue
    ) -> some View where ModelValue.Value == ViewValue.Value, ModelValue.Value: Equatable {
        modifier(Sync(modelValue: modelValue, viewValue: viewValue))
    }
}

private struct Sync<ModelValue: Syncable, ViewValue: Syncable>: ViewModifier
    where ModelValue.Value == ViewValue.Value, ModelValue.Value: Equatable {
    @State private var hasAppeared = false
    
    let modelValue: ModelValue
    let viewValue: ViewValue
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                guard viewValue.wrappedValue != modelValue.wrappedValue else { return }
                viewValue.wrappedValue = modelValue.wrappedValue
            }
            .onChange(of: modelValue.wrappedValue) { _, newValue in
                guard viewValue.wrappedValue != newValue else { return }
                viewValue.wrappedValue = newValue
            }
            .onChange(of: viewValue.wrappedValue) { _, newValue in
                guard modelValue.wrappedValue != newValue else { return }
                modelValue.wrappedValue = newValue
            }
    }
}

protocol Syncable {
    associatedtype Value
    var wrappedValue: Value { get nonmutating set }
}

extension Binding: Syncable {}
extension State: Syncable {}
extension FocusState: Syncable {}
extension FocusState.Binding: Syncable {}
