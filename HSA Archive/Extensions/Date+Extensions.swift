//
//  Date+Extensions.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/1/26.
//

import Foundation

extension Date {
    /// Returns the date at the start of the month containing this date.
    var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) ?? self
    }
}
