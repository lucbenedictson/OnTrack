//
//  Extensions.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-23.
//

import SwiftUI

extension Task.Category {
    var image: String {
        switch self {
        case .productivity: return "brain.head.profile"
        case .health: return "figure.walk"
        case .other: return "square"
        }
    }
}

extension Date {
    var YMD: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
    
    var HM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    var MY: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy" // Format for the year
        let year = dateFormatter.string(from: self)

        dateFormatter.dateFormat = "MMMM" // Format for the month
        let month = dateFormatter.string(from: self)

        return String("\(month) \(year)")
    }
    
    var D: String {
        String(Calendar.current.component(.day, from: self))
    }
    
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" // Use "E" for short version (e.g., "Mon")
        return dateFormatter.string(from: self)

    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    static func mostRecentSunday(from date: Date) -> Date? {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let daysSinceSunday = weekday - calendar.firstWeekday
        return calendar.date(byAdding: .day, value: -daysSinceSunday, to: date)
    }
    
    static func closestWednesdayTo(_ date: Date) -> Date? {
        let calendar = Calendar.current
        if let mostRecentSunday = mostRecentSunday(from: date) {
            return calendar.date(byAdding: .day, value: 3, to: mostRecentSunday)
        }
        return nil
    }
    
    static func weekAhead(from date: Date) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 7, to: date)
    }
    
    static func weekBehind(from date: Date) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -7, to: date)
    }
    
    static func calculateWeekOffset(from: Date, to: Date) -> Int {
        
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: from.startOfDay, to: to.startOfDay).day! / 7
    }
}

extension Task.Priority {
    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .blue
        case .low: return .yellow
        case .none: return .primary
        }
    }
}

extension UserPreferences.SortingOptions {
    var image: String {
        switch self {
        case .none: return "x.circle"
        case .priority: return "flag"
        case .date: return "calendar"
        }
    }
}
