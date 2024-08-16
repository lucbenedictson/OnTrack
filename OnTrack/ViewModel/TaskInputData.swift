//
//  TaskInputDate.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import Foundation

struct TaskInputData {
    var text: String = ""
    var category: Task.Category
    var dateComponent: Task.TimeComponent
    var priority: Task.Priority = .none
}
