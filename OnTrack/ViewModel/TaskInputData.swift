//
//  TaskInputDate.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import Foundation

struct TaskInputData {
    var text: String = ""
    var category: Category
    var dateComponent: TimeComponent
    var priority: Priority = .none
}

//#Preview {
//    TaskInputData()
//}
