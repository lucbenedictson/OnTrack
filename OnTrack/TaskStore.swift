//
//  ListStore.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-11.
//

import SwiftUI

class TaskStore: ObservableObject {
    @Published var tasks: [Task] = []
    
    func addTask(_ description: String, due: Date, category: Category, priority: Priority) {
        tasks.append(Task(isDaily: false, description: description, category: category, priority: priority))
    }
    
    func addDaily(_ description: String, category: Category, priority: Priority) {
        tasks.append(Task(isDaily: true, description: description, category: category, priority: priority))
    }
    
    func toggleComplete(withId id: Task.ID) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            tasks[index].toggleComplete()
        }
    }
    
    func edit(withId id: Task.ID, isDaily: Bool?, description: String?, dueDate: Date?, category: Category?, priority: Priority?) {
            if let index = tasks.firstIndex(where: {$0.id == id}) {
                tasks[index].edit(isDaily: isDaily, description: description, dueDate: dueDate, category: category, priority: priority)
            }
    }
    
    func tasksFor(_ category: Category?) -> [Task] {
        if let category = category {
            switch category {
            case .health: return health
            case .productivity: return productivity
            case .other: return other
            }
        }
        return tasks
    }
    
    private var other: [Task] {
        tasks.filter { $0.category == .other}
    }
    
    private var productivity: [Task] {
        tasks.filter {$0.category == .productivity}
    }
    
    private var health: [Task] {
        tasks.filter {$0.category == .health}
    }
}

//extension [Task] {
//    var other: [Task] {
//        self.filter { $0.category == .other}
//    }
//    
//    var productivity: [Task] {
//        self.filter {$0.category == .productivity}
//    }
//    
//    var health: [Task] {
//        self.filter {$0.category == .health}
//    }
//}
