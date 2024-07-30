//
//  TaskView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-23.
//

import SwiftUI

struct TaskView: View {
    @Binding var description: String
    @Binding var complete: Bool
    @Binding var timeComponent: Task.TimeComponent
    
    var body: some View {
        HStack(alignment: .center) {
            
            Text(description)
                .font(.body).fontWeight(.regular)
            
            Spacer()
            
            if(timeComponent.includeTime) {
                VStack {
                    Image(systemName: "clock")
                    Text(timeComponent.due.HM)
                }
                .font(.caption2).fontWeight(.regular)
                .foregroundStyle(.secondary)
            }
        }
        .checkify(complete: $complete)
    }
}

#Preview {
    @State var desc = "hi"
    @State var comp = false
    @State var comp2 = true
    @State var time = Task.TimeComponent(due: .now)
    
    return VStack {
        TaskView(description: $desc, complete: $comp, timeComponent: $time)
        TaskView(description: $desc, complete: $comp2, timeComponent: $time)
    }
}
