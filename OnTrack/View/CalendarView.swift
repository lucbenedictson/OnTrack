//
//  CalendarView.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var dateSelected: TimeComponent
//    @Binding var isPresented: Bool
    
    @State private var initialDateInfo: TimeComponent
    
    @Environment(\.dismiss) var dismiss
    
    init(dateSelection: Binding<TimeComponent>) {//, isPresented: Binding<Bool>) {
        self._dateSelected = dateSelection
//        self._isPresented = isPresented
        self._initialDateInfo = State(initialValue: dateSelection.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                AnimatedButton("Cancel") {
                    dateSelected = initialDateInfo
//                    isPresented = false
                    dismiss()
                }
                Spacer()
                AnimatedButton("Done") {
//                    isPresented = false
                    dismiss()
                }
            }
            .padding([.top,.horizontal])
            
            
            DatePicker("Choose Date", selection: $dateSelected.due, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding()
            
            
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
                .listRowBackground(Color.gray.opacity(0.1))
            
            }
            .scrollContentBackground(.hidden)
        }
    }
}

//#Preview {
//    CalendarView()
//}

