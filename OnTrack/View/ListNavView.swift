//
//  ListNavView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import SwiftUI

struct ListNavView: View {
    @EnvironmentObject var store: TaskStore
    @State var presentTaskSheet = false
    @State var presentTaskEditorSheet = false
    @ObservedObject var userPreferencesStore: UserPreferencesStore
    let category: Task.Category?
    
    init(_ userPreferencesStore: UserPreferencesStore, changingPreferencesCategoryTo category: Task.Category?) {
        self.userPreferencesStore = userPreferencesStore
        self.category = category
    }
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                TaskListView(userPreferencesStore)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        toolBarContents()
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .overlay(plusButton(in: geo))
        }
        .onAppear {
            userPreferencesStore.preferences.category = category //update userPreferences category for current list
        }
    }
    
    @ToolbarContentBuilder
    private func toolBarContents() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink {
                GeometryReader { geo in
                    WeekAtAGlanceView(userPreferencesStore, availableWidth: geo.size.width)
                }
            } label: {
                Image(systemName: "calendar")
            }
        }
        
        ToolbarItem(placement: .principal) {
            HStack {
                AnimatedButton(systemImage: "chevron.left") {
                    decrementDay()
                }

                Text(userPreferencesStore.preferences.date.YMD)
                    .transition(.identity)
                    .onTapGesture {
                        userPreferencesStore.preferences.date = .now
                    }
                
                AnimatedButton(systemImage: "chevron.right") {
                    incrementDay()
                }
            }
        }
        
        ToolbarItem {
            Menu {
                Toggle(isOn: $userPreferencesStore.preferences.showComplete)  {
                    Text("Show Complete")
                        
                }
                Picker(selection: $userPreferencesStore.preferences.sort){
                    ForEach(UserPreferences.SortingOptions.allCases, id: \.self) { sort in
                        Label(sort.rawValue, systemImage: sort.image)
                            .fixedSize()
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                        .fixedSize()
                }
                .pickerStyle(.menu)
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
    
    func incrementDay() {
        let calendar = Calendar.current
        userPreferencesStore.preferences.date = calendar.date(byAdding: .day, value: 1, to: userPreferencesStore.preferences.date) ?? Date.now
    }

    func decrementDay() {
        let calendar = Calendar.current
        userPreferencesStore.preferences.date = calendar.date(byAdding: .day, value: -1, to: userPreferencesStore.preferences.date) ?? Date.now
    }
    
    private func plusButton(in geo: GeometryProxy) -> some View {
        let size = CGFloat(65)
        let xPos = geo.size.width - size/2 - 15
        let yPos = geo.size.height - size/2 - 15
        
        return Button {
            presentTaskSheet = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: size, height: size)
                .background(.background, in: Circle())
        }
        .position(x: xPos, y: yPos)
        .sheet(isPresented: $presentTaskSheet) {
            TaskEdittorView(selectedDay: userPreferencesStore.preferences.date, initialCategory: userPreferencesStore.preferences.category)
        }
    }
}
