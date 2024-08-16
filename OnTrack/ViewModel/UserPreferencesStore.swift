//
//  UserPreferencesStore.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-08-16.
//

import SwiftUI

extension UserDefaults {
    func userPreferences(forKey key: String) -> UserPreferences {
        if let jsonData = data(forKey: key),
            let decodedPalettes = try? JSONDecoder().decode(UserPreferences.self, from: jsonData) {
            return decodedPalettes
        } else {
            return UserPreferences(date: Date.now, category: nil, sort: .none, showComplete: false)
        }
    }
    
    func set(_ settings: UserPreferences, forKey key: String) {
        let data = try? JSONEncoder().encode(settings)
        set(data, forKey: key)
    }
}

class UserPreferencesStore: ObservableObject {
    private var userPreferencesUDKey: String { "UserPreferences" }
    
    var preferences: UserPreferences {
        get {
            UserDefaults.standard.userPreferences(forKey: userPreferencesUDKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userPreferencesUDKey)
            objectWillChange.send()
        }
    }
}
