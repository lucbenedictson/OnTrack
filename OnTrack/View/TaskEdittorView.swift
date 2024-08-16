//
//  TaskEditorView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import SwiftUI
import Foundation

struct TaskEdittorView: View {
    @EnvironmentObject private var store: TaskStore
    @State private var showCategory = false
    @State private var showDate = false
    @State private var showPriority = false
    

    @Environment(\.dismiss) var dismiss
    @State private var taskInput: TaskInputData
    private let taskId: Task.ID?
    
    
    init(selectedDay: Date, initialCategory category: Task.Category?) {
        self._taskInput = State(initialValue: TaskInputData(category: category ?? .productivity, dateComponent: Task.TimeComponent(due: selectedDay)))
        self.taskId = nil
    }
    
    init(editTask: Task) {
        self._taskInput = State(initialValue: editTask.toTaskInputData())
        self.taskId = editTask.id
    }
    
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top){
                TextField("whats next", text: $taskInput.text, axis: .vertical)
                    .focused($focused, equals: true)
                    .onAppear {
                        focused = true
                    }
                
                
                AnimatedCapsuleButton(systemImage: taskId != nil ? "pencil" : "plus") {
                    if let id = taskId {
                        store.edit(withId: id, taskData: taskInput)
                    } else {
                        store.add(taskData: taskInput)
                    }
                    dismiss()
                }
            }
            .padding([.horizontal, .top])
            
            HStack {
                AnimatedCapsuleButton(taskInput.dateComponent.due.formatted(date: .abbreviated, time: taskInput.dateComponent.includeTime ? .shortened : .omitted), systemImage: "calendar") {
                    showDate = true
                    focused = false
                }
                .lineLimit(1)
                .sheet(isPresented: $showDate) {
                    CalendarView(dateSelection: $taskInput.dateComponent) //, isPresented: $showDate)
                }
                
                AnimatedCapsuleButton(systemImage: taskInput.category.image) {
                    showCategory = true
                }
                .lineLimit(1)
                .popover(isPresented: $showCategory) {
                    categoryPopover
                        .presentationCompactAdaptation((.popover))
                }
                
                
                AnimatedCapsuleButton(systemImage: "flag", imageColor: taskInput.priority.color) {
                    showPriority = true
                }
                .lineLimit(1)
                .popover(isPresented: $showPriority) {
                    priorityPopover
                        .presentationCompactAdaptation((.popover))
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .font(nil).fontWeight(nil) //apply default font and font weight to all text
    }
    
    
    private let popoverPadding = CGFloat(5)
    
    private var categoryPopover: some View {
        VStack(alignment: .leading) {
            ForEach(Task.Category.allCases, id: \.self) { category in
                AnimatedButton(category.description, systemImage: category.image, imageColor: Color.primary, textColor: Color.primary) {
                    self.taskInput.category = category
                    showCategory = false
                    focused = false
                }
                
                if Task.Category.allCases.last != category {
                    Divider()
                }
            }
        }
        .padding(popoverPadding)
    }
    
    private var priorityPopover: some View {
        VStack(alignment: .leading) {
            ForEach(Task.Priority.allCases, id: \.self) { priority in
                AnimatedButton(priority.description, systemImage: "flag", imageColor: priority.color, textColor: Color.primary) {
                    self.taskInput.priority = priority
                    showPriority = false
                    focused = false
                }
                
                if Task.Priority.allCases.last != priority {
                    Divider()
                }
            }
        }
        .padding(popoverPadding)
    }
}

extension Task {
    func toTaskInputData() -> TaskInputData {
        TaskInputData (
            text: self.description,
            category: self.category,
            dateComponent: self.dateComponent,
            priority: self.priority)
    }
}

