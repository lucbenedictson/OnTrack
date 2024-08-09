//
//  TaskView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-23.
//

import SwiftUI

struct TaskView: View {
    @Binding var task: Task
    
    init(_ task: Binding<Task>) {
        self._task = task
    }
    
    var body: some View {
        HStack(alignment: .center) {
            
            Text(task.description)
                .font(.body)
                .fontWeight(.regular)
            
            Spacer()
            
            if(task.date.includeTime) {
                VStack {
                    Image(systemName: "clock")
                    Text(task.date.due.HM)
                }
                .font(.caption2).fontWeight(.regular)
                .foregroundStyle(.secondary)
            }
        }
        .checkify(complete: $task.complete, priority: task.priority)
    }
}

extension View {
    func checkify(complete: Binding<Bool>, priority: Priority) -> some View {
        modifier(Checkify(complete: complete, priority: priority))
    }
}

struct Checkify: ViewModifier, Animatable {
    @Binding var complete: Bool
    @State var maskPosition: Double
    private let priority: Priority

    init(complete: Binding<Bool>, priority: Priority) {
        self._complete = complete
        self._maskPosition = State(initialValue: complete.wrappedValue ? 20 : 0)
        self.priority = priority
    }

    var animatableData: Double {
        get { maskPosition }
        set { maskPosition = newValue}
    }
    
    func body(content: Content) -> some View {
        HStack {
            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(priority.color)
                .background(
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(.background)
                )
                .symbolEffect(.bounce, value: maskPosition)
                .overlay(
                    Rectangle()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.background)
                        .offset(x: maskPosition)
                        .clipped()
                )
                .onTapGesture {
                    withAnimation(.spring) {
                        toggleMaskPosition()
                    } completion: {
                        withAnimation {
                            complete.toggle()
                        }
                    }
                }
            content
        }
    }
    
    func toggleMaskPosition() {
        maskPosition < 20.0 ? (maskPosition = 20.0) : (maskPosition = 0.0)
    }
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
