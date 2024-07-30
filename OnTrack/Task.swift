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
    var description: String
    var date: TimeComponent
    var category: Category
    var priority: Priority
    
    mutating func toggleComplete() {
        complete.toggle()
    }
    
    mutating func edit(taskData: TaskInputData) {
        description = taskData.text
        date = taskData.dateComponent
        category = taskData.category
        priority = taskData.priority
    }
    
    struct TimeComponent: Hashable {
        var due: Date
        var includeTime = false
    }
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

