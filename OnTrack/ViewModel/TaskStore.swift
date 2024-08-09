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
    private var userDefaultsKey: String { "Tasks" }
    @Published private var sort: SortingOptions = .none
    
    func sortBy(_ sortOption: SortingOptions) {
        sort = sortOption
    }
    
    enum SortingOptions: String, CaseIterable  {
        case none = "None"
        case priority = "Priority"
        case date = "Date"
        
        var image: String {
            switch self {
            case .none: return "x.circle"
            case .priority: return "flag"
            case .date: return "calendar"
            }
        }
    }
    
    var tasks: [Task] {
        get {
            switch sort {
            case .none:
                UserDefaults.standard.tasks(forKey: userDefaultsKey)
            case .priority:
                UserDefaults.standard.tasks(forKey: userDefaultsKey).sorted(by: {$0.priority > $1.priority})
            case .date:
                UserDefaults.standard.tasks(forKey: userDefaultsKey).sorted(by: {sortDate(d1: $0.date, d2: $1.date)})
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
            for task in self.tasks {
                print(task)
            }
            objectWillChange.send()
        }
    }
    
    private func sortDate(d1: TimeComponent, d2: TimeComponent) -> Bool {
        if(d1.includeTime && d2.includeTime){
            return d1.due < d2.due
        } else if(d1.includeTime && !d2.includeTime){
            return true
        } else if(!d1.includeTime && d2.includeTime) {
            return false
        } else {
            return true
        }
    }
    
    func add(taskData: TaskInputData) {
        tasks.append(Task(description: taskData.text,
                          date: taskData.dateComponent,
                          category: taskData.category,
                          priority: taskData.priority))
        print(tasks)
        
    }
    
    func indexOfTask(withId id: Task.ID) -> Int? {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            return index
        } else {
            return nil
        }
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
    
    func pushTask(withId id: Task.ID) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            let calendar = Calendar.current
            tasks[index].date.due = calendar.date(byAdding: .day, value: 1, to: tasks[index].date.due)!
        }
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
    
    func isEmpty( _ category: Category?, on day: Date, allowsComplete: Bool) -> Bool {
        var tasksToCheck: [Task] = []
        
        if let category = category {
            switch category {
            case .health: 
                tasksToCheck = health.filterByDay(day)
            case .productivity:
                tasksToCheck = productivity.filterByDay(day)
            case .other:
                tasksToCheck = other.filterByDay(day)
            }
        } else {
            tasksToCheck = tasks.filterByDay(day)
        }
        
        if allowsComplete {
            return tasksToCheck.isEmpty
        } else {
            return tasksToCheck.filterUncomplete().isEmpty
        }
    }
    
    func contains(_ id: Task.ID, from category: Category?, on day: Date, allowComplete: Bool) -> Bool {
        var currTasks: [Task] = []
        if let category = category {
            switch category {
            case .health: 
                currTasks = health.filterByDay(day)
            case .productivity:
                currTasks = productivity.filterByDay(day)
            case .other:
                currTasks = other.filterByDay(day)
            }
        } else {
            currTasks = tasks.filterByDay(day)
        }
        
        if !allowComplete {
            currTasks = currTasks.filterUncomplete()
        }
        
        return currTasks.contains(where: {$0.id == id})
    }
}

extension [Task] {
    func filterByDay(_ day: Date) -> [Task] {
        let calendar = Calendar.current
        
        return self.filter {
            calendar.dateComponents([.day,.month,.year], from: $0.date.due)
            == calendar.dateComponents([.day, .month, .year], from: day)
        }
    }
                
    func filterUncomplete() -> [Task] {
        self.filter { $0.complete == false }
    }
}
