//
//  ContentView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-10.
//

import SwiftUI

struct CategoryTabView: View {
    var body: some View {
            TabView {
                ListNavView(category: nil)
                    .tabItem {
                        Image(systemName: "list.bullet")
                    }
//                
                ListNavView(category: .productivity)
                    .tabItem {
                        Image(systemName: Category.productivity.image)
                            .environment(\.symbolVariants, .none)
                    }
                
                ListNavView(category: .health)
                    .tabItem {
                        Image(systemName: Category.health.image)
                    }
                
                ListNavView(category: .other)
                    .tabItem {
                        Image(systemName: Category.other.image)
                            .environment(\.symbolVariants, .none)
                    }
            }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTabView()
    }
}

struct NewTaskView: View {
    init(isPresented: Binding<Bool>, category: Category?) {
        self._isPresented = isPresented
        category != nil ? (self.category = category!) : (self.category = .productivity)
    }
    
    @Binding var isPresented: Bool
    
    @State var category: Category
    @State var showCategory = false
    
    @State var date: Date = Date.now
    @State var showDate = false
    
    @State var priority: Priority = .none
    @State var showPriority = false
    
    @EnvironmentObject var store: TaskStore
    @State var text = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextField("Whats next?", text: $text)
                
                AnimatedCapsuleButton(systemImage: "plus") {
                    store.addTask(text, due: date, category: category, priority: priority)
                    isPresented = false
                }
            }
            
            HStack {
                AnimatedCapsuleButton("Today", systemImage: "calendar") {
                    showDate = true
                }
                .sheet(isPresented: $showDate) {
                    DateAndTimeSelectorView()
                }
                
                
                AnimatedCapsuleButton(priority.rawValue, systemImage: "flag") {
                    showPriority = true
                }
                .popover(isPresented: $showPriority, attachmentAnchor: .point(.center)) {
                    priorityPopoverContent
                }
                
                
                AnimatedCapsuleButton(category.rawValue, systemImage: category.image) {
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
    
    var categoryPopeverContent: some View {
        ForEach(Category.allCases, id: \.self) { category in
            AnimatedButton(category.rawValue) {
                self.category = category
                showCategory = false
            }
            
            if category != Category.allCases.last {
                Divider()
            }
        }
        .padding()
        .presentationCompactAdaptation(.popover)
    }
    
    var priorityPopoverContent: some View {
        ForEach(Priority.allCases, id: \.self) { priority in
            AnimatedButton(priority.rawValue) {
                self.priority = priority
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

struct DateAndTimeSelectorView: View {
    @State private var day = Date()
    @State private var setTime = false
    @State private var setReminder = false
    @State private var time = Date.now
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                AnimatedButton("Cancel") {}
                Spacer()
                AnimatedButton("Done") {}
            }
            .padding([.top,.horizontal])
            
            
            DatePicker("Choose Date", selection: $day , displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding()
            
            Form {
                Section {
                    Toggle("Set time" , isOn: $setTime)
                    if(setTime) {
                        DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    } else {
                        HStack {
                            Text("Time")
                            Spacer()
                            Text("None").foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Time")
                }
                .listRowBackground(Color.gray.opacity(0.1))
                
                Section {
                    withAnimation(.easeIn(duration: 10)) {
                        Toggle("Set reminder" , isOn: $setReminder)
                    }
                    if(setReminder) {
                        DatePicker("Reminder", selection: $time)
                    } else {
                        HStack {
                            Text("Reminder")
                            Spacer()
                            Text("None").foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Reminder")
                }
                .listRowBackground(Color.gray.opacity(0.1))
                

                
            }
            .scrollContentBackground(.hidden)

        }
    }
}
