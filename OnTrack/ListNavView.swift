//
//  ListNavView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import SwiftUI

struct ListNavView: View {
    var category: Category?
    @EnvironmentObject var store: TaskStore
    @State var presentTaskSheet = false
    @State var day = Date.now
    @State var showComplete = false
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                conditionalContent()
                    .navigationBarTitleDisplayMode(.inline)
                    .listSectionSpacing(0)
                    .scrollContentBackground(.hidden)
                    .toolbar {
                        toolBarContents()
                    }
                    .font(.title2).fontWeight(.semibold)
            }
            .overlay(plusButton(in: geo))
        }
    }
    
    @ViewBuilder
    private func conditionalContent() -> some View {
        ZStack { // FIXME: - 1) lets text transition apply when swaping the condition content
            if store.isEmpty(category, on: day) {
                Text("all done for the day!")
                    .transition(.identity)
            } else {
//                TaskView(description: $desc, complete: $comp, timeComponent: $time)
                List {
                    listContents()
                }
//                .buttonStyle(BorderlessButtonStyle())
                .transition(.identity)
            }
        }
    }
    
//    @ViewBuilder
//    private func listContents() ->  some View {
//        Section {} header: {
//            Text("Tasks")
//                .textCase(nil)
//                .font(.title).fontWeight(.semibold)
//                .foregroundStyle(Color.black)
//        }
//        
//        ForEach(store.tasksIndicesFor(category, onDay: day), id: \.self) {index in
//            Section {
//                TaskView(description: store.tasks[index].description, complete: $store.tasks[index].complete, timeComponent: $store.tasks[index].date)
//                    .listRowBackground(Color.gray.opacity(0.5))
//                    .swipeActions(edge: .trailing) {
//                        AnimatedButton(systemImage: "trash", role: .destructive) {
//                            store.tasks.remove(at: index)
//                        }
//                        AnimatedButton(systemImage: "pencil") {
//                            
//                        }
//                        .tint(.orange)
//                    
//                        AnimatedButton(systemImage: "arrow.right") {
//                            
//                        }
//                        .tint(.indigo)
//                    }
//                    
//            }
//            .listSectionSpacing(5)
//        }
//    }
    @ViewBuilder
    private func listContents() -> some View {
        Section {} header: {
            Text("Tasks")
                .textCase(nil)
                .font(.title).fontWeight(.semibold)
                .foregroundStyle(Color.black)
        }
        
        ForEach($store.tasks) { task in
            Section {
                if(store.contains(task.id, from: category, on: day) && task.complete.wrappedValue == showComplete) {
                    TaskView(description: task.description, complete: task.complete, timeComponent: task.date )
                        .listRowBackground(Color.gray.opacity(0.5))
                        .swipeActions(edge: .trailing) {
                            AnimatedButton(systemImage: "trash", role: .destructive) {
                                store.removeTask(withId: task.id)
                            }
                            AnimatedButton(systemImage: "pencil") {
                                
                            }
                            .tint(.orange)
                            
                            AnimatedButton(systemImage: "arrow.right") {
                                
                            }
                            .tint(.indigo)
                        }
                }
            }
            .listSectionSpacing(5)
        }
    }
    
    func changeDayBy(_ numDays: Int) {
        let calendar = Calendar.current
        day = calendar.date(byAdding: .day, value: numDays, to: day)!
    }
    
    @State private var left = true
    
    @ToolbarContentBuilder
    private func toolBarContents() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text("🔥5")
        }
        
        ToolbarItem(placement: .principal) {
            HStack(spacing: 0) {
                AnimatedButton(systemImage: "chevron.left") {
                    left = false
                    changeDayBy(-1)
                }
                
                Button {
                } label: {
                    Text(day.YMD)
                        .id(day)
                        .transition(.slide($left))
                        .animation(.smooth(duration: 0.5), value: day)
                        // FIXME: - 1) making animation longer prevents list error
                }
                .clipped()
                
                AnimatedButton(systemImage: "chevron.right") {
                    left = true
                    changeDayBy(1)
                }
            }
        }
        
        ToolbarItem {
            Button {
               
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
    
    private func plusButton(in geo: GeometryProxy) -> some View {
        Button {
            presentTaskSheet = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .background(.white, in: Circle())
        }
        .position(x: geo.size.width-50, y: geo.size.height-50)
        .sheet(isPresented: $presentTaskSheet) {
            TaskEditorView(isPresented: $presentTaskSheet, selectedDay: $day)
                .presentationDetents([.medium])
        }
    }
}

//#Preview {
//    ListNavView()
//}
