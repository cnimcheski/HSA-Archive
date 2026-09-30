//
//  GrowthView+GrowthChart+Series+Mock.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/29/26.
//

import SwiftUI

nonisolated extension GrowthView.GrowthChart.Series {
    static func mock(
        id: String = "Invested",
        color: Color = .accentColor,
        points: [Point] = (1...40).map { num in
            Point.mock(x: Calendar.current.date(byAdding: .year, value: num, to: .now) ?? .now)
        }
    ) -> Self {
        .init(id: id, color: color, points: points)
    }
}

// MARK: - Mock Point

nonisolated extension GrowthView.GrowthChart.Series.Point {
    static func mock(
        x: Date = .now,
        y: Double = Double.random(in: 0...20000)
    ) -> Self {
        .init(x: x, y: y)
    }
}
