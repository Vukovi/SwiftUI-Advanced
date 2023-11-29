//
//  07_AnimateCustomShape.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 18.11.23.
//

import SwiftUI

// MARK: - Custom Shape koji se dobija Path-om ne moze se animirati bez upotrebe animatedData

struct AnimateCustomShape: View {
    
    @State private var animate: Bool = false
    
    var body: some View {
        VStack(spacing: 40) {
            RoundedRectangle(cornerRadius: animate ? 30 : 0)
                .frame(width: 150, height: 150)
            
            RectangleWithSingleCornerAnimation(cornerRadius: animate ? 30 : 0)
                .frame(width: 150, height: 150)
            
            Packman(offsetAmount: animate ? 20 : 0)
                .frame(width: 150, height: 150)
            
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever()) {
                animate.toggle()
            }
        }
    }
}

struct RectangleWithSingleCornerAnimation: Shape {
    
    var cornerRadius: CGFloat
    
    var animatableData: CGFloat { //EmptyAnimatableData match-ujemo sa cornerRadius tj sa tipom sa kojim se animacija obavlja
        get { cornerRadius }
        set { cornerRadius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            
            path.addArc(
                center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 360),
                clockwise: false)
            
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}

struct Packman: Shape {
    
    var offsetAmount: Double
    
    var animatableData: Double {
        get { offsetAmount }
        set { offsetAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.height / 2,
                startAngle: Angle(degrees: offsetAmount),
                endAngle: Angle(degrees: 360 - offsetAmount),
                clockwise: false)
        }
    }
}

#Preview {
    AnimateCustomShape()
}
