//
//  TaskEditorView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import SwiftUI
import Foundation

struct TaskEditorView: View {
    @EnvironmentObject private var store: TaskStore
    @State private var showCategory = false
    @State private var showDate = false
    @State private var showPriority = false
    
    @Binding var isPresented: Bool
    @Binding var selectedDay: Date
    @State private var taskInput: TaskInputData
    
    init(isPresented: Binding<Bool>, selectedDay: Binding<Date>) {
        self._isPresented = isPresented
        self._selectedDay = selectedDay
        self.taskInput = TaskInputData(dateComponent: Task.TimeComponent(due: selectedDay.wrappedValue))
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextField("Whats next?", text: $taskInput.text)
                
                CapsuleButton(systemImage: "plus") {
                    store.add(taskData: taskInput)
                    isPresented = false
                }
            }
            
            HStack {
                AnimatedCapsuleButton(taskInput.dateComponent.due.formatted(date: .abbreviated, time: taskInput.dateComponent.includeTime ? .shortened : .omitted), systemImage: "calendar") {
                    showDate = true
                }
                .sheet(isPresented: $showDate) {
                    CalendarView(dateSelection: $taskInput.dateComponent, isPresented: $showDate)
                }
                
                AnimatedCapsuleButton(taskInput.priority.rawValue, systemImage: "flag") {
                    showPriority = true
                }
                .popover(isPresented: $showPriority, attachmentAnchor: .point(.center)) {
                    priorityPopoverContent
                }
                
                
                AnimatedCapsuleButton(systemImage: taskInput.category.image) {
                    showCategory = true
                }
                .popover(isPresented: $showCategory, attachmentAnchor: .point(.center)) {
                    categoryPopeverContent
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    @State var isDaily = false
    
    var categoryPopeverContent: some View {
        VStack(alignment: .leading) {
            ForEach(Category.allCases, id: \.self) { category in
                AnimatedButton(category.rawValue, systemImage: category.image) {
                    self.taskInput.category = category
                    showCategory = false
                }
                
                
                if category != Category.allCases.last {
                    Divider()
                }
            }
        }
        .padding()
        .presentationCompactAdaptation(.popover)
    }
    
    var priorityPopoverContent: some View {
        ForEach(Priority.allCases, id: \.self) { priority in
            AnimatedButton(priority.rawValue) {
                self.taskInput.priority = priority
                showPriority = false
            }
            
            
            if priority != Priority.allCases.last {
                Divider()
            }
        }
        .padding()
        .presentationCompactAdaptation(.popover)
    }
}
