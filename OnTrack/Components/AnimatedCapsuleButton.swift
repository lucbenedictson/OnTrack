//
//  AnimatedCapsuleButton.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import SwiftUI

struct AnimatedCapsuleButton: View {
    let title: String?
    let systemImage: String?
    let role: ButtonRole?
    let imageColor: Color
    let textColor: Color
    let action: () -> Void
    
    init(_ title: String? = nil,
         systemImage: String? = nil,
         role: ButtonRole? = nil,
         imageColor: Color = .primary,
         textColor: Color = .primary,
         action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.imageColor = imageColor
        self.textColor = textColor
        self.action = action
    }
    
    var body: some View {
        Button(role: role) {
            withAnimation {
                action()
            }
        } label: {
            if let title, let systemImage {
                Label {
                    Text(title)
                        .foregroundStyle(textColor)
                } icon: {
                    Image(systemName: systemImage)
                        .foregroundStyle(imageColor)
                }
            } else if let title {
                Text(title)
                    .foregroundStyle(textColor)
            } else if let systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(imageColor)
            }
        }
        .background(Capsule().fill(Color.accentColor.secondary))
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .controlSize(.regular)
    }
}
