//
//  TimeComponent.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-08-06.
//

import Foundation

struct TimeComponent: Hashable, Codable {
    var due: Date
    var includeTime = false
}
