//
//  01_CustomViewModifier.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 14.11.23.
//

import SwiftUI

struct BlueButtonViewModifier: ViewModifier {
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
    }
}

extension View {
    func withBlueButtonStyle(backgroundColor: Color = .blue) -> some View {
        self.modifier(BlueButtonViewModifier(backgroundColor: backgroundColor))
    }
}

struct CustomViewModifier: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .modifier(BlueButtonViewModifier(backgroundColor: .orange))
            
            Text("Hello, World!")
                .withBlueButtonStyle(backgroundColor: .green)
        }
    }
}

#Preview {
    CustomViewModifier()
}
