//
//  ListStore.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-11.
//

import SwiftUI

extension UserDefaults {
    func tasks(forKey key: String) -> [Task] {
        if let jsonData = data(forKey: key),
            let decodedPalettes = try? JSONDecoder().decode([Task].self, from: jsonData) {
            return decodedPalettes
        } else {
            return []
        }
    }
    func set(_ tasks: [Task], forKey key: String) {
        let data = try? JSONEncoder().encode(tasks)
        set(data, forKey: key)
    }
}


class TaskStore: ObservableObject {
    private var tasksUDKey: String { "Tasks" }
    
    var tasks: [Task] {
        get { // FIXME: - Move responsibility of sorting to taskListView
            UserDefaults.standard.tasks(forKey: tasksUDKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tasksUDKey)
            objectWillChange.send()
        }
    }
    
    func add(taskData: TaskInputData) {
        tasks.append(Task(description: taskData.text,
                          dateComponent: taskData.dateComponent,
                          category: taskData.category,
                          priority: taskData.priority))
    }
    
    func edit(withId id: Task.ID, taskData: TaskInputData) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            tasks[index].description = taskData.text
            tasks[index].dateComponent = taskData.dateComponent
            tasks[index].category = taskData.category
            tasks[index].priority = taskData.priority
        }
    }
    
    func removeTask(withId id: Task.ID) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            tasks.remove(at: index)
        }
    }
    
    func pushTask(withId id: Task.ID) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            let calendar = Calendar.current
            tasks[index].dateComponent.due = calendar.date(byAdding: .day, value: 1, to: tasks[index].dateComponent.due)!
        }
    }
}

extension [Task] {
    func filterByDay(_ day: Date) -> [Task] {
        let calendar = Calendar.current
        
        return self.filter {
            calendar.dateComponents([.day,.month,.year], from: $0.dateComponent.due)
            == calendar.dateComponents([.day, .month, .year], from: day)
        }
    }
    
    func filterByCategory(_ category: Task.Category?) -> [Task] {
        if let category = category {
            return self.filter { $0.category == category}
        }
        return self
    }
                
    func filterByCompletionStatus(_ showComplete: Bool) -> [Task] {
        if !showComplete {
            return self.filter { $0.completionStatus != .complete }
        }
        return self
    }
}
