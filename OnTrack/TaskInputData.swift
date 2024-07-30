//
//  TaskInputDate.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import Foundation

struct TaskInputData {
    var text: String = ""
    var category: Category = .productivity
    var dateComponent: Task.TimeComponent
    var includeTime: Bool = false
    var priority: Priority = .none
}

//#Preview {
//    TaskInputData()
//}
