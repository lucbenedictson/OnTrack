//
//  Extensions.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-23.
//

import SwiftUI

struct Checkify: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Circle()
                .fill(.white)
                .strokeBorder(.foreground, lineWidth: 1.5)
                .frame(width: 20, height: 20)
                
            content
        }
    }
}

extension View {
    func checkify() -> some View {
        modifier(Checkify())
    }
}

extension Category {
    var image: String {
        switch self {
        case .health: return "figure.walk"
        case .productivity: return "brain.head.profile"
        case .other: return "square"
        }
    }
}

