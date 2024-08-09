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
    private let editing: Bool
    private let taskId: Task.ID?
    
    
    init(selectedDay: Date, initialCategory category: Category?) {
        self._taskInput = State(initialValue: TaskInputData(category: category ?? .productivity, dateComponent: TimeComponent(due: selectedDay)))
        self.editing = false
        self.taskId = nil
    }
    
    init(editTask: Task) {
        self._taskInput = State(initialValue: editTask.toTaskInputData())
        self.editing = true
        self.taskId = editTask.id
    }
    
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // FIXME: - for some reason errors go away when there is no text field
                TextField("whats next", text: $taskInput.text)
                    .textFieldStyle(.roundedBorder)
                    .focused($focused, equals: true)
                    
                
                AnimatedCapsuleButton(systemImage: editing ? "pencil" : "plus") {
                    editing ? store.edit(withId: taskId!, taskData: taskInput) : store.add(taskData: taskInput)
                    dismiss()
                }
            }
            
            
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
            
            Spacer()
        }
        .padding()
        .onAppear {
            focused = true
        }
    }
    
    @State var isDaily = false
    
    var categoryPopover: some View {
        VStack(alignment: .leading) {
            ForEach(Category.allCases, id: \.self) { category in
                AnimatedButton(category.rawValue, systemImage: category.image, imageColor: Color.primary, textColor: Color.primary) {
                    self.taskInput.category = category
                    showCategory = false
                    focused = false
                }
                
                if Category.allCases.last != category {
                    Divider()
                }
            }
        }
        .padding(5)
    }
    
    var priorityPopover: some View {
        VStack(alignment: .leading) {
            ForEach(Priority.allCases, id: \.self) { priority in
                AnimatedButton(priority.toString(), systemImage: "flag", imageColor: priority.color, textColor: Color.primary) {
                    self.taskInput.priority = priority
                    showPriority = false
                    focused = false
                }
                
                if Priority.allCases.last != priority {
                    Divider()
                }
            }
        }
        .padding(5)
    }
}

extension Task {
    func toTaskInputData() -> TaskInputData {
        TaskInputData (
            text: self.description,
            category: self.category,
            dateComponent: self.date,
            priority: self.priority)
    }
}

//struct TextEdittorButton: View {
//    
//}
