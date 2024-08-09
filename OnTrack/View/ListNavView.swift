//
//  ListNavView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import SwiftUI

struct ListNavView: View {
    @EnvironmentObject var store: TaskStore
    let category: Category?
    @State var presentTaskSheet = false
    @State var presentTaskEditorSheet = false
    @State var showComplete = false
//    @State var sort: TaskStore.SortingOptions = .none

    @Binding var day: Date
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
//                conditionalContent()
                TaskListView(category: category, date: day, showComplete: showComplete)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        toolBarContents()
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .overlay(plusButton(in: geo))
        }
    }
    
    @ViewBuilder
    private func conditionalContent() -> some View {
//        ZStack { // FIXME: - 1) lets text transition apply when swaping the condition content
            if store.isEmpty(category, on: day, allowsComplete: showComplete) {
                Text("all done for the day!")
            } else {
//                TaskList()
                TaskListView(category: category, date: day, showComplete: showComplete)
            }
//        }
    }
    
    private func changeDayBy(_ numDays: Int) {
        let calendar = Calendar.current
        day = calendar.date(byAdding: .day, value: numDays, to: day)!
    }
    
    @State var showEventsCalendar = false
    
    @ToolbarContentBuilder
    private func toolBarContents() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink {
//                WeekAtAGlanceView(baseDate: $day)
                GeometryReader {geo in
                    WeekView(currentDate: $day, availableWidth: geo.size.width, category: category, showComplete: showComplete)
                }
            } label: {
                Image(systemName: "calendar")
            }
        }
        
        ToolbarItem(placement: .principal) {
            HStack(spacing: 0) {
                AnimatedButton(systemImage: "chevron.left") {
                    changeDayBy(-1)
                }

                Text(day.YMD)
                    .id(day)
                    .transition(.identity)
                    .clipped()
                    .onTapGesture {
                        day = .now
                    }
                
                AnimatedButton(systemImage: "chevron.right") {
                    changeDayBy(1)
                }
            }
        }
        
        ToolbarItem {
            Menu {
                Toggle(isOn: $showComplete)  {
                    Text("Show Complete")
                }
                
                Menu {
                    ForEach(TaskStore.SortingOptions.allCases, id: \.self) { sort in
                        AnimatedButton(sort.rawValue, systemImage: currentSort == sort ? "checkmark" : nil) {
                            currentSort = sort
                            store.sortBy(sort)
                        }
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
    
    @State var currentSort: TaskStore.SortingOptions = .none
    
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
            TaskEdittorView(selectedDay: day, initialCategory: category)
        }
    }
}


//#Preview {
//    ListNavView()
//}






//struct ListView: View {
//    var category: Category?
//    @Binding var showComplete: Bool
//    @Binding var day: Date
//    @EnvironmentObject var store: TaskStore
//    
//    var body: some View {
//       conditionalContent()
//    }
//    
//    @ViewBuilder
//    private func conditionalContent() -> some View {
//        ZStack { // FIXME: - 1) lets text transition apply when swaping the condition content
//            if store.isEmpty(category, on: day, allowsComplete: showComplete) {
//                Image(systemName: "checkmark")
//            } else {
//                List {
//                    listContents()
//                }
//                .listSectionSpacing(5)
//            }
//        }
//    }
//
//    @ViewBuilder
//    private func listContents() -> some View {
//        Section {} header: {
//            Text("Tasks")
//                .textCase(nil)
//                .font(.title).fontWeight(.semibold)
//                .foregroundStyle(Color.black)
//        }
//        
//        ForEach($store.tasks) { task in
//                if(store.contains(task.id, from: category, on: day) && task.complete.wrappedValue == showComplete) {
//                    Section {
//                        TaskView(description: task.description, complete: task.complete, timeComponent: task.date )
//                            .listRowBackground(Color.gray.opacity(0.5))
//                            .swipeActions(edge: .trailing) {
//                                AnimatedButton(systemImage: "trash", role: .destructive) {
//                                    store.removeTask(withId: task.id)
//                                }
//                                AnimatedButton(systemImage: "pencil") {
//                                    
//                                }
//                                .tint(.orange)
//                                
//                                AnimatedButton(systemImage: "arrow.right") {
//                                    
//                                }
//                                .tint(.indigo)
//                            }
//                    }
//                }
//            }
//    }
//}
