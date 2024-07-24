//
//  TaskLists.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-10.
//

import Foundation

struct Task: Identifiable, Hashable {
    let id = UUID()
    var complete = false
    var isDaily: Bool
    var description: String
    var dueDate: Date?
    var category: Category
    var priority: Priority
    
    mutating func edit(isDaily: Bool?, description: String?, dueDate: Date?, category: Category?, priority: Priority?) {
        if let isDaily {self.isDaily = isDaily}
        if let description {self.description = description}
        if let dueDate {self.dueDate = dueDate}
        if let category {self.category = category}
        if let priority {self.priority = priority}
    }
    
    mutating func toggleComplete() {
        complete.toggle()
    }
    
//    init(description: String, category: Category, priority: Priority? = Priority.none) {
//        self.isDaily = true
//        self.description = description
//        self.category = category
//        if let priority = priority {
//            self.priority = priority
//        }
//    }
//    
//    init(description: String, dueDate: Date, category: Category, priority: Priority? = Priority.none) {
//        self.isDaily =
//        self.isDaily = isDaily
//        self.description = description
//        
//        self.category = category
//        if let priority = priority {
//            self.priority = priority
//        }
//    }
}

enum Category: String, CaseIterable {
    case health = "Health"
    case productivity = "Productivity"
    case other = "Other"
}

enum Priority: String, CaseIterable {
    case high = "High"
    case middle = "Middle"
    case low = "Low"
    case none = "None"
}

//enum listCategory {
//    case health
//    case fitness
//    case productivity
//
//    func name() -> String {
//        switch self {
//        case .health:
//            return "Health"
//        case .fitness
//            return "Fitness"
//        case .productivity
//            "return Productivity"
//        }
//    }
//}
