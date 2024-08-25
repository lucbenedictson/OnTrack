//
//  CalendarView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import SwiftUI

struct CalendarView: View {
    @Binding private var dateSelected: Task.TimeComponent    
    private let initialDateInfo: Task.TimeComponent
    
    @Environment(\.dismiss) var dismiss
    
    init(dateSelection: Binding<Task.TimeComponent>) {
        self._dateSelected = dateSelection
        self.initialDateInfo = dateSelection.wrappedValue
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                AnimatedButton("Cancel") {
                    dateSelected = initialDateInfo
                    dismiss()
                }
                Spacer()
                AnimatedButton("Done") {
                    dismiss()
                }
            }
            .padding()
            
            DatePicker("Choose Date", selection: $dateSelected.due, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding(.horizontal)

            
            
            Form {
                Section {
                    Toggle("Set time" , isOn: $dateSelected.includeTime)
                    if(dateSelected.includeTime) {
                        DatePicker("Time", selection: $dateSelected.due, displayedComponents: .hourAndMinute)
                    } else {
                        HStack {
                            Text("Time")
                            Spacer()
                            Text("None").foregroundStyle(.secondary)
                        }
                    }
                }
                .listRowBackground(Color.secondary.opacity(0.1))
            
            }
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal)
    }
}
