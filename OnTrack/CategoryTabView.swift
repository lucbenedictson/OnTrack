//
//  ContentView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-103.
//

import SwiftUI

struct CategoryTabView: View {
    var body: some View {
            TabView {
                ListNavView(category: nil)
                    .tabItem {
                        Image(systemName: "list.bullet")
                    }
                
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
