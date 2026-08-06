//
//  CaseIterable+RawValues.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/5/26.
//

extension CaseIterable where Self: RawRepresentable, RawValue == String {
    /// An array containing the raw values of all cases in declaration order.
    static var rawValues: [String] {
        allCases.map(\.rawValue)
    }
}
