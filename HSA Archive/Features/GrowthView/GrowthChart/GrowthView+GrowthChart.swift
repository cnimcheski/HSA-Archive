//
//  GrowthView+GrowthChart.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/27/26.
//

import Charts
import SwiftUI

extension GrowthView {
    struct GrowthChart: View {
        private let series: [Series]
        
        init(series: [Series]) {
            self.series = series
        }
        
        var body: some View {
            AppGroupBox {
                Chart {
                    ForEach(series) { series in
                        ForEach(series.points) { point in
                            LineMark(
                                x: .value("Year", point.x),
                                y: .value("Amount", point.y)
                            )
                            .lineStyle(series.style)
                            .foregroundStyle(by: .value("Type", series.id))
                        }
                    }
                }
                .frame(minHeight: 175)
                .chartForegroundStyleScale(
                    domain: series.map(\.id),
                    range: series.map(\.color)
                )
            }
        }
    }
}

// MARK: - Previews

#Preview {
    List {
        GrowthView.GrowthChart(
            series: [
                GrowthView.GrowthChart.Series.mock(),
                GrowthView.GrowthChart.Series.mock(id: "Uninvested", color: .secondary)
            ]
        )
    }
    .listStyle(.plain)
}
