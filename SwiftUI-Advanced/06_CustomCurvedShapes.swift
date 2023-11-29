//
//  06_CustomCurvedShapes.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 17.11.23.
//

import SwiftUI

struct ArcSample: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.height / 2,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 40),
                clockwise: true)
        }
    }
}

struct ShapeArcSample: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            
//            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.height / 2,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 180),
                clockwise: false)
            
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        }
    }
}

struct QuadCurveSample: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.maxY),
                control: CGPoint(x: rect.maxX - 50, y: rect.minY - 100)
            )
        }
    }
}

struct WaterShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.25, y: rect.height * 0.25)
            )
            
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.75, y: rect.height * 0.75)
            )
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}

struct CustomCurvedShapes: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Text("Arc:")
                    .font(.largeTitle)
                ArcSample()
                    .stroke(lineWidth: 3)
                    .frame(width: 200, height: 200)
                
                Text("Shape:")
                    .font(.largeTitle)
                ShapeArcSample()
                    .frame(width: 200, height: 200)
                
                Text("Quad Curve:")
                    .font(.largeTitle)
                QuadCurveSample()
                    .frame(width: 200, height: 200)
                
                Text("Water Shape:")
                    .font(.largeTitle)
                WaterShape()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
            }
        }
    }
}

#Preview {
    CustomCurvedShapes()
}
