//
//  GrowthView+GrowthChart+Series.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/28/26.
//

import Charts
import SwiftUI

nonisolated extension GrowthView.GrowthChart {
    nonisolated struct Series: Identifiable {
        struct Point: Identifiable {
            let id = UUID()
            let x: Date
            let y: Double
        }
        
        /// The legend key for this series.
        let id: String
        let color: Color
        let style: StrokeStyle
        let points: [Point]
        
        init(
            id: String,
            color: Color,
            style: StrokeStyle = .init(lineWidth: 2),
            points: [Point]
        ) {
            self.id = id
            self.color = color
            self.style = style
            self.points = points
        }
    }
}
