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
        HStack {
            Text(task.description)
            
            Spacer()
            
            if(task.dateComponent.includeTime) {
                VStack {
                    Image(systemName: "clock")
                    Text(task.dateComponent.due.HM)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                }
                .font(.caption2).fontWeight(.regular)
                .foregroundStyle(.secondary)
            }
        }
        .checkify(completionStatus: $task.completionStatus, priority: task.priority)
    }
}

extension View {
    func checkify(completionStatus: Binding<Task.CompletionStatus>, priority: Task.Priority) -> some View {
        modifier(Checkify(complete: completionStatus, priority: priority))
    }
}

struct Checkify: ViewModifier {
    @Binding var completionStatus: Task.CompletionStatus
    @State var maskPosition: Double = 0.0
    @State var tapped = false
    private let priority: Task.Priority
    
    private struct Constants {
        static let checkFrame = CGFloat(25)
        static let circleFrame = checkFrame - 3
        static let maskFrame = checkFrame - 8
        static let checkedMaskOffset = checkFrame
    }
    
    init(complete: Binding<Task.CompletionStatus>, priority: Task.Priority) {
        self._completionStatus = complete
        self._maskPosition = State(initialValue: complete.wrappedValue == .complete ? Constants.checkedMaskOffset : 0)
        self.priority = priority
    }
    
    func body(content: Content) -> some View {
        HStack {
            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: Constants.checkFrame, height: Constants.checkFrame)
                .foregroundStyle(priority.color)
                .background(
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: Constants.circleFrame, height: Constants.circleFrame)
                        .foregroundStyle(.background)
                )
                .overlay(
                    Rectangle()
                        .frame(width: Constants.maskFrame, height: Constants.maskFrame)
                        .foregroundStyle(.background)
                        .offset(x: (completionStatus == .complete || completionStatus == .checking) ? Constants.checkedMaskOffset : 0)
                        .clipShape(Circle())
                )
                .onTapGesture {
                    //Do not allow user to alter status while in the process of checking
                    if completionStatus == .complete {
                        withAnimation(.spring) {
                            completionStatus = .incomplete
                        }
                    } else if completionStatus == .incomplete {
                        withAnimation(.spring) {
                            completionStatus = .checking
                        } completion: {
                            withAnimation(.spring) {
                                completionStatus = .complete
                            }
                        }
                    }
                }
            
            content
        }
        .font(nil).fontWeight(nil)
    }
}
