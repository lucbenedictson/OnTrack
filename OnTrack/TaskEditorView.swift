////
////  TaskEditorView.swift
////  OnTrack
////
////  Created by Luc Benedictson on 2024-07-24.
////
//
//import SwiftUI
//import Foundation
//
//struct TaskEditorView: View {
//    @EnvironmentObject private var store: TaskStore
//    @State private var showCategory = false
//    @State private var showDate = false
//    @State private var showPriority = false
//    
//    @State private var taskInput: TaskInputData
//    private let taskId: Task.ID
//    
//    init(taskToEdit task: Task) {
//        self._taskInput = State(initialValue: task.toTaskInputData())
//        self.taskId = task.id
//    }
//    
//    @Environment(\.dismiss) var dismiss
//    @FocusState private var focused: Bool
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            HStack {
////                TextEditor(text: $taskInput.text)
////                    .focused($focused, equals: true) // MARK: - error occurs if focus is not removed before pressing any of the buttons
//                TextField("whats next", text: $taskInput.text)
//                    .font(nil)
//                    .fontWeight(nil)
//                    .textFieldStyle(.roundedBorder)
//                    .focused($focused, equals: true)
//                    
//                
//                CapsuleButton(systemImage: "pencil") {
//                    store.edit(withId: taskId, taskData: taskInput)
//                    dismiss()
//                }
//            }
//            
//            HStack {
//                AnimatedCapsuleButton(taskInput.dateComponent.due.formatted(date: .abbreviated, time: taskInput.dateComponent.includeTime ? .shortened : .omitted), systemImage: "calendar") {
//                    showDate = true
//                    focused = false
//                }
//                .sheet(isPresented: $showDate) {
//                    CalendarView(dateSelection: $taskInput.dateComponent, isPresented: $showDate)
//                }
//                
//                AnimatedCapsuleButton(taskInput.priority.rawValue, systemImage: "flag") {
//                    showPriority = true
//                    focused = false
//                }
//                .popover(isPresented: $showPriority, attachmentAnchor: .point(.center)) {
//                    priorityPopoverContent
//                }
//                
//                
//                AnimatedCapsuleButton(systemImage: taskInput.category.image) {
//                    showCategory = true
//                    focused = false
//                }
//                .popover(isPresented: $showCategory, attachmentAnchor: .point(.center)) {
//                    categoryPopeverContent
//                }
//            }
//            
//            Spacer()
//        }
//        .padding()
//        //.fixedSize()
//        .onAppear {
//            focused = true
//        }
//        //.ignoresSafeArea(.keyboard, edges: .bottom)
//    }
//    
//    @State var isDaily = false
//    
//    var categoryPopeverContent: some View {
//        VStack(alignment: .leading) {
//            ForEach(Category.allCases, id: \.self) { category in
//                AnimatedButton(category.rawValue, systemImage: category.image) {
//                    self.taskInput.category = category
//                    showCategory = false
//                }
//                
//                
//                if category != Category.allCases.last {
//                    Divider()
//                }
//            }
//        }
//        .padding()
//        .presentationCompactAdaptation(.popover)
//    }
//    
//    var priorityPopoverContent: some View {
//        ForEach(Priority.allCases, id: \.self) { priority in
//            AnimatedButton(priority.rawValue) {
//                self.taskInput.priority = priority
//                showPriority = false
//            }
//            
//            
//            if priority != Priority.allCases.last {
//                Divider()
//            }
//        }
//        .padding()
//        .presentationCompactAdaptation(.popover)
//    }
//}
