//
//  AnimatedButton.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import SwiftUI

struct AnimatedButton: View {
    var title: String? = nil
    var systemImage: String? = nil
    var role: ButtonRole?
    let imageColor: Color
    let textColor: Color
    let action: () -> Void
    
    init(_ title: String? = nil,
         systemImage: String? = nil,
         role: ButtonRole? = nil,
         imageColor: Color = .accentColor,
         textColor: Color = .accentColor,
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
                //Image(systemName: "systemImage").foregroundStyle(imageColor)
//                Label(title, Image(systemName: "systemImage").foregroundStyle(imageColor))
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
    }
}

//#Preview {
//    AnimatedButton()
//}
