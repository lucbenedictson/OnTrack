//
//  TaskLists.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-10.
//

import Foundation

struct Task: Identifiable, Hashable, Codable, CustomDebugStringConvertible {
    var debugDescription: String {
        return "Desciption: \(description), Date: \(date)"
    }
    
    var id = UUID()
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
}
