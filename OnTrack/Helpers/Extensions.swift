//
//  Extensions.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-23.
//

import SwiftUI

extension Category {
    var image: String {
        switch self {
        case .productivity: return "brain.head.profile"
        case .health: return "figure.walk"
        case .other: return "square"
        }
    }
}

extension AnyTransition {
    static func slide(_ left: Bool) -> AnyTransition {
        .asymmetric(insertion: .move(edge: left ? .trailing : .leading), removal: .move(edge: left ? .leading : .trailing).combined(with: .opacity))
    }
    
//    static var slideRight: AnyTransition {
//        .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing).combined(with: .opacity))/*.combined(with: .asymmetric(insertion: .identity, removal: .opacity))*/
//    }
}

extension Date {
    var YMD: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .none
//        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    var HM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    var MY: String {
        // Current date

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy" // Format for the year
        let year = dateFormatter.string(from: self)

        dateFormatter.dateFormat = "MMMM" // Format for the month
        let month = dateFormatter.string(from: self)

        return String("\(month) \(year)")
        //return String("\(components.year) \(components.month)")
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
    
    static func mostRecentSunday(from date: Date) -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let daysSinceSunday = weekday - calendar.firstWeekday
        let mostRecentSunday = calendar.date(byAdding: .day, value: -daysSinceSunday, to: date)!
        return mostRecentSunday
    }
    
    static func closestWednesdayTo(_ date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 3, to: mostRecentSunday(from: date))!
        
    }
}

extension Priority {
    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .blue
        case .low: return .yellow
        case .none: return .primary
        }
    }
}

extension View {
    func appFont() -> some View {
        self.font(.system(size: 17, weight: .regular))
    }
}
