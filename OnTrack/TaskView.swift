//
//  TaskView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-23.
//

import SwiftUI

struct TaskView: View {
    var description: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text(description)
                .font(.body).fontWeight(.regular)
            
            Spacer()
            
            VStack {
                Image(systemName: "clock")
                Text("time")
            }
            .font(.caption2).fontWeight(.regular)
            .foregroundStyle(.secondary)
        }
        .checkify()
    }
}

#Preview {
    TaskView(description: "HI")
}
