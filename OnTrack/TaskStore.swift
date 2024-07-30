//
//  ListStore.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-11.
//

import SwiftUI

class TaskStore: ObservableObject {
    @Published var tasks: [Task] = []
    //@Published var current: [Task]
    
    func add(taskData: TaskInputData) {
        tasks.append(Task(description: taskData.text,
                          date: taskData.dateComponent,
                          category: taskData.category,
                          priority: taskData.priority))
        
    }
    
    func edit(withId id: Task.ID, taskData: TaskInputData) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            tasks[index].edit(taskData: taskData)
        }
    }
    
    func removeTask(withId id: Task.ID) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            tasks.remove(at: index)
        }
    }
    
//    func toggleComplete(withId id: Task.ID) {
//        if let index = tasks.firstIndex(where: {$0.id == id}) {
//            tasks[index].toggleComplete()
//        }
//    }
    
//    func taskWithID(_ id: Task.ID) -> Task? {
//        if let index = tasks.firstIndex(where: {$0.id == id}) {
//            return tasks[index]
//        }
//        return nil
//    }
    
//    func tasksIndicesFor(_ category: Category?, onDay day: Date) -> [Int] {
//        var tasksToCompact  = [Task]()
//        if let category = category {
//            switch category {
//            case .health: tasksToCompact = health
//            case .productivity: tasksToCompact = productivity
//            case .other: tasksToCompact = other
//            }
//        } else {
//            tasksToCompact = tasks
//        }
//        
//        return tasksToCompact.filterByDay(day).compactMap { task in
//            tasks.firstIndex(where: { $0.id == task.id } )
//        }
//    }
//    func tasksFromCategory(_ category: Category?, onDay day: Date) -> [Task] {
//
//    }
//    
    private var other: [Task] {
        tasks.filter { $0.category == .other}
    }
    
    private var productivity: [Task] {
        tasks.filter {$0.category == .productivity}
    }
    
    private var health: [Task] {
        tasks.filter {$0.category == .health}
    }
    
    func isEmpty( _ category: Category?, on day: Date) -> Bool {
        if let category = category {
            switch category {
            case .health: return health.filterByDay(day).isEmpty
            case .productivity: return productivity.filterByDay(day).isEmpty
            case .other: return other.filterByDay(day).isEmpty
            }
        }
        return tasks.filterByDay(day).isEmpty
    }
    
    func contains(_ id: Task.ID, from category: Category?, on day: Date) -> Bool {
        if let category = category {
            switch category {
            case .health: return health.filterByDay(day).contains(where: {$0.id == id})
            case .productivity: return productivity.filterByDay(day).contains(where: {$0.id == id})
            case .other: return other.filterByDay(day).contains(where: {$0.id == id})
            }
        }
        return tasks.filterByDay(day).contains(where: {$0.id == id})
    }
}

//enum TaskType {
//    case regular
//    case daily
//    //case calendar
//}

extension [Task] {
    func filterByDay(_ day: Date) -> [Task] {
        let calendar = Calendar.current
        
        return self.filter {
            calendar.dateComponents([.day,.month,.year], from: $0.date.due)
            == calendar.dateComponents([.day, .month, .year], from: day)
        }
    }
}
