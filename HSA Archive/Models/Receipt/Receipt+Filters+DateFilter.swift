//
//  Receipt+Filters+DateFilter.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/7/26.
//

import Foundation

nonisolated extension Receipt.Filters {
    struct DateFilter {
        enum Range: CaseIterable {
            case anyTime
            case thisMonth
            case lastThreeMonths
            case thisYear
            case custom
            
            var title: String {
                switch self {
                case .anyTime:
                    "Any time"
                case .thisMonth:
                    "This month"
                case .lastThreeMonths:
                    "Last 3 months"
                case .thisYear:
                    "This year"
                case .custom:
                    "Custom range..."
                }
            }
        }
        
        var range = Range.anyTime
        var customStartDate = Calendar.current.dateInterval(of: .year, for: .now)?.start ?? .now
        var customEndDate = Date.now
        
        var dateInterval: DateInterval? {
            let calendar = Calendar.current
            let now = Date.now

            switch range {
            case .anyTime:
                return nil
            case .thisMonth:
                return calendar.dateInterval(of: .month, for: now)
            case .lastThreeMonths:
                guard let currentMonth = calendar.dateInterval(of: .month, for: now),
                      let start = calendar.date(byAdding: .month, value: -2, to: currentMonth.start)
                else { return nil }
                return DateInterval(start: start, end: currentMonth.end)
            case .thisYear:
                return calendar.dateInterval(of: .year, for: now)
            case .custom:
                let start = calendar.startOfDay(for: customStartDate)
                guard let end = calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: calendar.startOfDay(for: customEndDate)
                ) else { return nil }
                return DateInterval(start: start, end: end)
            }
        }
    }
}
