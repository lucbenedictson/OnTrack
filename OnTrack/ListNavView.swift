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
    
    var body: some View {
        
        GeometryReader { geo in
            NavigationStack {
                List {
                    listContents()
                }
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
    private func listContents() ->  some View {
        Section {} header: {
            Text("Dailies")
                .textCase(nil)
                .font(.title).fontWeight(.semibold)
                .foregroundStyle(Color.black)
        }
        
        ForEach(store.tasksFor(category), id: \.self) {task in
            Section {
                TaskView(description: task.description)
                    .listRowBackground(Color.gray.opacity(0.5))
            }
            .listSectionSpacing(5)
        }
        .onDelete(perform: { indexSet in
            //tasks.remove(
        })
    }
    
    @ToolbarContentBuilder
    private func toolBarContents() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text("🔥5")
        }
        
        ToolbarItem(placement: .principal) {
            HStack(spacing: 0) {
                Button{
                    
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Button {
                    
                } label: {
                    Text("Today")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "chevron.right")
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
            NewTaskView(isPresented: $presentTaskSheet, category: category)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    ListNavView()
}
