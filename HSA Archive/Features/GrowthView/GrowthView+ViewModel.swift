//
//  GrowthView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/26/26.
//

import FactoryKit
import Navigation
import SwiftUI

extension GrowthView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension GrowthView {
    @Observable
    final class ViewModel: Navigating {
        enum Destination {
            case temp
        }
        
        private let receiptRepository = Container.shared.receiptRepository()
        private let userDefaultsManager = Container.shared.userDefaultsManager()
        
        weak var delegate: NavigationDelegate?
        
        var currentAmount: Double {
            receiptRepository.sortedReceipts.filter { !$0.isReimbursed }.map { $0.amount }.reduce(0, +)
        }
        
        var projectedAmount: Double {
            investedSeries.points.last?.y ?? 0
        }
        
        var series: [GrowthChart.Series] {
            [investedSeries, uninvestedSeries]
        }
        
        private var investedSeries: GrowthChart.Series {
            GrowthChart.Series(
                id: "Invested",
                color: .accent,
                points: (0...Int(userDefaultsManager.yearsUntilRetirement)).map { yearOffset in
                    .init(
                        x: Calendar.current.date(from: .init(year: currentYear + yearOffset)) ?? .now,
                        y: currentAmount * pow(1 + userDefaultsManager.assumedAnnualReturn, Double(yearOffset))
                    )
                }
            )
        }
        
        private var uninvestedSeries: GrowthChart.Series {
            GrowthChart.Series(
                id: "Uninvested",
                color: .secondary,
                style: .init(lineWidth: 2, dash: [6, 6]),
                points: (0...Int(userDefaultsManager.yearsUntilRetirement)).map { yearOffset in
                    .init(
                        x: Calendar.current.date(from: .init(year: currentYear + yearOffset)) ?? .now,
                        y: currentAmount
                    )
                }
            )
        }
        
        private var currentYear: Int {
            Calendar.current.component(.year, from: .now)
        }
    }
}
