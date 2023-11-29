//
//  02_CustomButtonStyle.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 15.11.23.
//

import SwiftUI

struct PressableCustomButtonStyle: ButtonStyle {
    
    let scaledAmount: CGFloat
    
    init(scaledAmount: CGFloat = 0.9) {
        self.scaledAmount = scaledAmount
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledAmount : 1)
            .brightness(configuration.isPressed ? 0.1 : 0)
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}

extension View {
    func withPressableCustomButtonStyle(scaledAmount: CGFloat = 0.9) -> some View {
        self.buttonStyle(PressableCustomButtonStyle(scaledAmount: scaledAmount))
    }
}

struct CustomButtonStyle: View {
    var body: some View {
        VStack(spacing: 40) {
            Button {
                
            } label: {
                Text("Click me")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
//            .buttonStyle(PressableCustomButtonStyle())
            .withPressableCustomButtonStyle()
            
            Button {
                
            } label: {
                Text("Click me")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            .buttonStyle(PressableCustomButtonStyle(scaledAmount: 0.7))
        
        }
        .padding(40)

    }
}

#Preview {
    CustomButtonStyle()
}
