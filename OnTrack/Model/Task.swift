//
//  TaskLists.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-10.
//

import Foundation

struct Task: Identifiable, Hashable, Codable {
    var id = UUID()
    var completionStatus: CompletionStatus = .incomplete
    var description: String
    var dateComponent: TimeComponent
    var category: Category
    var priority: Priority

    enum CompletionStatus: Codable {
        case incomplete
        case checking
        case complete
    }
    
    enum Priority: Int, CaseIterable, Codable, Comparable, CustomStringConvertible {
        var description: String {
            switch self {
            case .high: return "High"
            case .medium: return "Medium"
            case .low: return "Low"
            case .none: return "None"
            }
        }
        
        static func < (lhs: Priority, rhs: Priority) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        case high = 3
        case medium = 2
        case low = 1
        case none = 0
    }
    
    enum Category: String, CaseIterable, Codable, CustomStringConvertible {
        var description: String {
            self.rawValue
        }
        
        case health = "Health & Fitness"
        case productivity = "Career"
        case other = "Other"
        
        
    }
    
    struct TimeComponent: Hashable, Codable {
        var due: Date
        var includeTime = false
    }
}

