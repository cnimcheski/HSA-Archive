//
//  AppSlider.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/27/26.
//

import SwiftUI

struct AppSlider<V>: View where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint {
    @Binding private var value: V
    private let prompt: LocalizedStringResource
    private let range: ClosedRange<V>
    private let step: V.Stride
    private let displayValue: LocalizedStringResource
    private let isLoading: Bool
    
    init(
        _ prompt: LocalizedStringResource,
        value: Binding<V>,
        in range: ClosedRange<V>,
        step: V.Stride = 1,
        displayValue: LocalizedStringResource,
        isLoading: Bool = false
    ) {
        self._value = value
        self.prompt = prompt
        self.range = range
        self.step = step
        self.displayValue = displayValue
        self.isLoading = isLoading
    }
    
    var body: some View {
        VStack {
            header
            Slider(value: $value, in: range, step: step)
                .redactedShimmer(isShimmering: isLoading)
        }
    }
}

// MARK: - Private Views

private extension AppSlider {
    var header: some View {
        HStack {
            Text(prompt)
                .foregroundStyle(.secondary)
            Spacer()
            Text(displayValue)
                .font(.headline)
        }
    }
}

// MARK: - Previews

#Preview {
    @Previewable @State var value = 20.0
    List {
        AppSlider(
            "Years until retirement",
            value: $value,
            in: 1...50,
            displayValue: "^[\(Int(value)) year](inflect: true)"
        )
    }
    .listStyle(.plain)
}
