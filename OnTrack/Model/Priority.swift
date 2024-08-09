//
//  Priority.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-08-06.
//

import Foundation

enum Priority: Int, CaseIterable, Codable, Comparable {
    static func < (lhs: Priority, rhs: Priority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case high = 3
    case medium = 2
    case low = 1
    case none = 0
    
    func toString() -> String {
        if self == .high { return "High"}
        else if self == .medium {return "Medium"}
        else if self == .low { return "Low"}
        else {return "None"}
    }
}


