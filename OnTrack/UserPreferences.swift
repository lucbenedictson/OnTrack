//
//  UserPreferences.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-08-11.
//

import Foundation

struct UserPreferences: Codable {
    var date: Date
    var category: Task.Category?
    var sort: SortingOptions
    var showComplete: Bool
    
    enum SortingOptions: String, CaseIterable, Codable  {
        case none = "None"
        case priority = "Priority"
        case date = "Date"
    }
}
