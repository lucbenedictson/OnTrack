//
//  OnTrackApp.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-10.
//

import SwiftUI

//@available(iOS 17.0, *)
@main
struct OnTrackApp: App {
    @StateObject var taskStore = TaskStore()
    
    var body: some Scene {
        WindowGroup {
            CategoryTabView()
                    .environmentObject(taskStore)
        }
    }
}
