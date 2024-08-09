//
//  ContentView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-103.
//

import SwiftUI

struct CategoryTabView: View {
    @State private var day = Date.now
    @State private var selection = 0
    
    var body: some View {
            TabView(selection: $selection) {
                ListNavView(category: nil, day: $day)
                    .tabItem {
                        Image(systemName: "list.bullet")
                    }
                    .tag(0)
                
                ListNavView(category: .productivity, day: $day)
                    .tabItem {
                        Image(systemName: Category.productivity.image)
                            .environment(\.symbolVariants, .none)
                    }
                    .tag(1)
                
                ListNavView(category: .health, day: $day)
                    .tabItem {
                        Image(systemName: Category.health.image)
                    }
                    .tag(2)
                
                ListNavView(category: .other, day: $day)
                    .tabItem {
                        Image(systemName: Category.other.image)
                            .environment(\.symbolVariants, .none)
                    }
                    .tag(3)
            }
            
    }
}

#Preview {
    CategoryTabView()
        .environmentObject(TaskStore())
}

//#Preview {
//    @State var desc = "hi"
//    @State var comp = false
//    @State var comp2 = true
//    @State var time = Task.TimeComponent(due: .now)
//    
//    return VStack {
//        TaskView(description: $desc, complete: $comp, timeComponent: $time)
//        TaskView(description: $desc, complete: $comp2, timeComponent: $time)
//    }
//}
