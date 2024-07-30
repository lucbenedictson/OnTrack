//
//  CalendarView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var dateSelection: Task.TimeComponent
    @Binding var isPresented: Bool
    @State private var initialDateInfo: Task.TimeComponent
    
    init(dateSelection: Binding<Task.TimeComponent>, isPresented: Binding<Bool>) {
        self._dateSelection = dateSelection
        self._isPresented = isPresented
        self._initialDateInfo = State(initialValue: dateSelection.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                AnimatedButton("Cancel") {
                    dateSelection = initialDateInfo
                    isPresented = false
                }
                Spacer()
                AnimatedButton("Done") {
                    isPresented = false
                }
            }
            .padding([.top,.horizontal])
            
            
            DatePicker("Choose Date", selection: $dateSelection.due , displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding()
            
            Form {
                Section {
                    Toggle("Set time" , isOn: $dateSelection.includeTime)
                    if(dateSelection.includeTime) {
                        DatePicker("Time", selection: $dateSelection.due, displayedComponents: .hourAndMinute)
                    } else {
                        HStack {
                            Text("Time")
                            Spacer()
                            Text("None").foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Time")
                }
                .listRowBackground(Color.gray.opacity(0.1))
                
//                Section {
//                    withAnimation(.easeIn(duration: 10)) {
//                        Toggle("Set reminder" , isOn: $setReminder)
//                    }
//                    if(setReminder) {
//                        DatePicker("Reminder", selection: $time)
//                    } else {
//                        HStack {
//                            Text("Reminder")
//                            Spacer()
//                            Text("None").foregroundStyle(.secondary)
//                        }
//                    }
//                } header: {
//                    Text("Reminder")
//                }
//                .listRowBackground(Color.gray.opacity(0.1))
            }
            .scrollContentBackground(.hidden)
        }
    }
}

//#Preview {
//    CalendarView()
//}
