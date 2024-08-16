//
//  OnTrackApp.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-10.
//

import SwiftUI

@main
struct OnTrackApp: App {
    @StateObject var taskStore = TaskStore()
    @StateObject var userPreferencesStore = UserPreferencesStore()
    
    var body: some Scene {
        WindowGroup {
            CategoryTabView(userPreferencesStore)
                    .environmentObject(taskStore)
        }
    }
}
