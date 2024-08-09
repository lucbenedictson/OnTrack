//
//  TaskListView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-08-08.
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var store: TaskStore
    let category: Category?
    let date: Date
    let showComplete: Bool
    
    @State var editTask: Task?
    
    var body: some View {
        conditionalContent()
    }
    
    @ViewBuilder
    private func conditionalContent() -> some View {
//        ZStack { // FIXME: - 1) lets text transition apply when swaping the condition content
            if store.isEmpty(category, on: date, allowsComplete: showComplete) {
                    Text("all done for the day!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
            } else {
                taskList
            }
//        }
    }
    
    var taskList: some View {
        List {
            Section {} header: {
                Text("Tasks")
                    .textCase(nil)
                    .font(.title).fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
            }
            
            ForEach($store.tasks) { task in
                if(store.contains(task.id, from: category, on: date, allowComplete: showComplete)) {
                    Section {
                        TaskView(task)
                            .listRowBackground(Color.gray.opacity(0.5))
                            .swipeActions(edge: .trailing) {
                                AnimatedButton(systemImage: "trash", role: .destructive) {
                                    store.removeTask(withId: task.id)
                                }
                                AnimatedButton(systemImage: "pencil") {
                                    editTask = task.wrappedValue
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
            .sheet(item: $editTask) { task in
                TaskEdittorView(editTask: task)
                    .font(nil)
                    .fontWeight(nil)
            }
        }
        .listSectionSpacing(5)
        .scrollContentBackground(.hidden)
    }
}
