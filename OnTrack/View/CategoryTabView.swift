//
//  ContentView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-103.
//

import SwiftUI

struct CategoryTabView: View {
    @State private var selection = 0
    @EnvironmentObject private var taskStore: TaskStore
    @ObservedObject private var userPreferencesStore: UserPreferencesStore
    
    init(_ userPreferencesStore: UserPreferencesStore){
        self.userPreferencesStore = userPreferencesStore
        switch userPreferencesStore.preferences.category {
        case nil: self._selection = State(initialValue: 0)
        case .productivity: self._selection = State(initialValue: 1)
        case .health: self._selection = State(initialValue: 2)
        case .other: self._selection = State(initialValue: 3)
        }
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ListNavView(userPreferencesStore, changingPreferencesCategoryTo: nil)
                .tabItem {
                    Image(systemName: "list.bullet")
                }
                .tag(0)
            
            ListNavView(userPreferencesStore, changingPreferencesCategoryTo: .productivity)
                .tabItem {
                    Image(systemName: Task.Category.productivity.image)
                        .environment(\.symbolVariants, .none)
                }
                .tag(1)
            
            ListNavView(userPreferencesStore, changingPreferencesCategoryTo: .health)
                .tabItem {
                    Image(systemName: Task.Category.health.image)
                }
                .tag(2)
            
            ListNavView(userPreferencesStore, changingPreferencesCategoryTo: .other)
                .tabItem {
                    Image(systemName: Task.Category.other.image)
                        .environment(\.symbolVariants, .none)
                }
                .tag(3)
        }
    }
}

