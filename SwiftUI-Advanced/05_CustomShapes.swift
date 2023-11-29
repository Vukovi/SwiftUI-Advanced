//
//  05_CustomShapes.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 17.11.23.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let horizontalOffset: CGFloat = rect.width * 0.2
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}

struct CustomShapes: View {
    var body: some View {
        VStack {
            Rectangle()
//                .trim(from: 0, to: 0.5)
                .frame(width: 200, height: 200)
                .clipShape(
                    Diamond()
                )
                
            Image("test")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 300)
                .clipShape(
                    Triangle()
                        .rotation(Angle(degrees: 180))
                )

            
            
            
        }
    }
}

#Preview {
    CustomShapes()
}
