//
//  03_CustomAnyTransition.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 15.11.23.
//

import SwiftUI

struct RotateViewModifier: ViewModifier {
    
    let rotation: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotation))
            .offset(
                x: rotation != 0 ? UIScreen.main.bounds.width : 0,
                y: rotation != 0 ? UIScreen.main.bounds.height : 0
            )
    }
}

extension AnyTransition {
    
    static var rotation: AnyTransition {
        return AnyTransition.modifier(
            active: RotateViewModifier(rotation: 180),
            identity: RotateViewModifier(rotation: 0)
        )
    }
    
    static func rotation(amount: Double = 180) -> AnyTransition {
        modifier(
            active: RotateViewModifier(rotation: amount),
            identity: RotateViewModifier(rotation: 0)
        )
    }
    
    static var rotationOn: AnyTransition {
        return AnyTransition.asymmetric(
            insertion: rotation,
            removal: .move(edge: .leading)
        )
    }
}

struct CustomAnyTransition: View {
    
    @State var showRectangle: Bool = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            if showRectangle {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: 250, height: 350)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .transition(AnyTransition.rotation.animation(.easeInOut))
                    .transition(.rotationOn)
            }
            
            Spacer()
            
            Text("Click me")
                .withBlueButtonStyle()
                .padding(.horizontal, 40)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        showRectangle.toggle()
                    }
                }
        }
    }
}

#Preview {
    CustomAnyTransition()
}
