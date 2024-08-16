//
//  TaskListView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-08-08.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var store: TaskStore
    @ObservedObject private var userPreferencesStore: UserPreferencesStore
    @State var editTask: Task?
    @State var recentlyCheckedTasks: [Task] = []
    
    init(_ userPreferencesStore: UserPreferencesStore){
        self.userPreferencesStore = userPreferencesStore
    }
    
    var body: some View {
        conditionalContent()
    }
    
    @ViewBuilder
    private func conditionalContent() -> some View {
//        ZStack { // FIXME: - 1) lets text transition apply when swaping the condition content
            if tasksToShow.isEmpty {
                Text("All done for the day!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(Constants.EmptyList.lineLimit)
                    .minimumScaleFactor(Constants.EmptyList.scaleFactor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                taskList
            }
    }
    
    private var taskList: some View {
        List {
            Section {} header: {
                Text("Tasks")
                    .textCase(nil) //remove auto uppercase
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
            }
            
            ForEach(tasksToShow) { task in
                if let index = indexOf(taskWithId: task.id) {
                    Section {
                        TaskView($store.tasks[index])
                            .listRowBackground(Color.secondary.opacity(Constants.List.rowBackgroundOpacity))
                            .swipeActions(edge: .trailing) {
                                AnimatedButton(systemImage: "trash", role: .destructive) {
                                    store.removeTask(withId: task.id)
                                }
                                AnimatedButton(systemImage: "pencil") {
                                    editTask = task
                                }
                                .tint(.orange)
                                
                                AnimatedButton(systemImage: "arrow.right") {
                                    store.pushTask(withId: task.id)
                                }
                                .tint(.indigo)
                            }
                    }
                }
            }
        }
        .sheet(item: $editTask) { task in
            TaskEdittorView(editTask: task)
        }
        .listSectionSpacing(Constants.List.rowSpacing)
        .scrollContentBackground(.hidden)
    }
    
    func indexOf(taskWithId id: Task.ID) -> Int? {
        if let index = store.tasks.firstIndex(where: {$0.id == id}) {
            return index
        }
        return nil
    }
    
    private var tasksToShow: [Task] {
        //filter by date, category, and completionStatus
        let currTasks = store.tasks
            .filterByDay(userPreferencesStore.preferences.date)
            .filterByCategory(userPreferencesStore.preferences.category)
            .filterByCompletionStatus(userPreferencesStore.preferences.showComplete)
        
        //sort
        switch userPreferencesStore.preferences.sort {
        case .none: return currTasks
        case .priority: return currTasks.sorted(by: prioritySort(t1:t2:))
        case .date: return currTasks.sorted(by: dateSort(t1:t2:))
        }
    }
    
    private func prioritySort(t1: Task, t2: Task) -> Bool {
        t1.priority > t2.priority
    }
    
    private func dateSort(t1: Task, t2: Task) -> Bool {
        let d1 = t1.dateComponent, d2 = t2.dateComponent
        
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
    
    private struct Constants {
        struct List {
            static let rowSpacing = CGFloat(5)
            static let rowBackgroundOpacity = CGFloat(0.5)
        }
        
        struct EmptyList {
            static let scaleFactor = CGFloat(0.1)
            static let lineLimit = 1
        }
    }
}
