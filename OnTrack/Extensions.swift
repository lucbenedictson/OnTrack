//
//  Extensions.swift
//  OnTrack
//
//  Created by Luc Benedictson on 2024-07-23.
//

import SwiftUI

struct Checkify: ViewModifier, Animatable {
    @Binding var complete: Bool
//    
    init(complete: Binding<Bool>) {
        self._complete = complete
        mask = complete.wrappedValue ? 20 : 0
    }
    
    var mask: Double
    var animatableData: Double {
        get { mask }
        set { mask = newValue}
    }
    
    func body(content: Content) -> some View {
        HStack {
            Image(systemName: "checkmark.circle")
                //.resizable()
                .aspectRatio(contentMode: .fit)
                .symbolEffect(.bounce, value: complete)
                .background(
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 21, height: 21)
                        .foregroundStyle(.white)
                        .symbolEffectsRemoved()
                )
                .overlay(
                    Rectangle()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.white)
                        .offset(x: mask)
                        .clipped()
                )
                .onTapGesture {
                    withAnimation(.spring) {
                        complete.toggle()
                    }
                }
            
            content
        }
    }
}

extension View {
    func checkify(complete: Binding<Bool>) -> some View {
        modifier(Checkify(complete: complete))
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

extension AnyTransition {
    static func slide(_ left: Binding<Bool>) -> AnyTransition {
        .asymmetric(insertion: .move(edge: left.wrappedValue ? .trailing : .leading), removal: .move(edge: left.wrappedValue ? .leading : .trailing).combined(with: .opacity))
    }
    
//    static var slideRight: AnyTransition {
//        .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing).combined(with: .opacity))/*.combined(with: .asymmetric(insertion: .identity, removal: .opacity))*/
//    }
}

extension Date {
    var YMD: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .none
//        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    var HM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}

//extension Date: Identifiable {
//    public var id: String {
//        self.YMD
//    }
//}

//struct Slider: Transition {
//    @Binding var left: Bool
//    
//    func body(content: Content, phase: TransitionPhase) -> some View {
//        GeometryReader { geo in
//            content
//                .offset(x: phase.isIdentity ? (left ?  -geo.size.width : geo.size.width) : 0)
////                .offset(phase.didDisappear ? (x: left ? -geo.size.width : geo.size.width) : nil)
//        }
//    }
//}
// 
