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
           // CapsuleTextView(title, systemImage: systemImage, imageColor: imageColor)
        }
        .background(Capsule().fill(Color.accentColor.secondary))
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .controlSize(.regular)
    }
}

//struct CapsuleTextView: View {
//    let title: String?
//    let systemImage: String?
//    let imageColor: Color
//    
//    init(_ title: String? = nil, systemImage: String? = nil, imageColor: Color = .primary){
//        self.title = title
//        self.systemImage = systemImage
//        self.imageColor = imageColor
//    }
//    
//    //let color: Color
//    @ScaledMetric(relativeTo: .body) var paddingWidth = 7 //Enusre text remains inside capsule no matter the font size
//    
//    var body: some View {
//        content()
//            .font(.body)
//            .fontWeight(.regular)
//            .padding(paddingWidth)
//            .background(Color.accentColor.secondary, in: Capsule())
////            .lineLimit(1)
//     }
//    
//    @ViewBuilder
//    private func content() -> some View {
//        if let title, let systemImage {
//            Label {
//                Text(title)
//                    .foregroundStyle(Color.primary)
//            } icon: {
//                Image(systemName: systemImage)
//                    .foregroundStyle(imageColor)
//            }
//        } else if let title {
//            Text(title)
//                .foregroundStyle(Color.primary)
//        } else if let systemImage {
//            Image(systemName: systemImage)
//                .foregroundStyle(imageColor)
//        }
//    }
//}
//

//struct CapsuleButton: View {
//    let title: String?
//    let systemImage: String?
//    let role: ButtonRole?
//    let imageColor: Color
//    let action: () -> Void
//
//    init(_ title: String? = nil,
//         systemImage: String? = nil,
//         role: ButtonRole? = nil,
//         imageColor: Color = .accentColor,
//         action: @escaping () -> Void
//    ) {
//        self.title = title
//        self.systemImage = systemImage
//        self.role = role
//        self.imageColor = imageColor
//        self.action = action
//    }
//
//    var body: some View {
//        Button(role: role) {
//                action()
//        } label: {
//            CapsuleTextView(title: title, systemImage: systemImage, imageColor: imageColor)
//        }
//    }
//}

//#Preview {
//    AnimatedCapsuleButton()
//}
