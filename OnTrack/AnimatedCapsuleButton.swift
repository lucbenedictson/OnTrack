//
//  AnimatedCapsuleButton.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-24.
//

import SwiftUI

struct AnimatedCapsuleButton: View {
    var title: String? = nil
    var systemImage: String? = nil
    var role: ButtonRole?
    let action: () -> Void
    
    init(_ title: String? = nil,
         systemImage: String? = nil,
         role: ButtonRole? = nil,
         action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.action = action
    }
    
    var body: some View {
        
        Button(role: role) {
            withAnimation {
                action()
            }
        } label: {
            CapsuleTextView(title: title, systemImage: systemImage)
        }
    }
}

struct CapsuleTextView: View {
    var title: String? = nil
    var systemImage: String? = nil
    //let color: Color
    @ScaledMetric(relativeTo: .body) var paddingWidth = 7 //Enusre text remains inside capsule no matter the font size
    
    var body: some View {
        content()
            .font(.body).fontWeight(.regular)
            //.foregroundColor(.black)
            .padding(paddingWidth)
            .background(.secondary, in: Capsule())
            .lineLimit(1)
     }
    
    @ViewBuilder
    private func content() -> some View {
        if let title, let systemImage {
             Label(title, systemImage: systemImage)
                .font(.headline)
        } else if let title {
             Text(title)
                .font(.headline)
        } else if let systemImage {
             Image(systemName: systemImage)
                .font(.headline)
        }
    }
}

//#Preview {
//    AnimatedCapsuleButton()
//}
