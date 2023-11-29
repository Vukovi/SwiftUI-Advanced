//
//  GeometryPreferenceKey.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 20.11.23.
//

import SwiftUI

struct GeometryPreferenceKey: View {
    
    @State private var rectSize: CGSize = .zero
    
    var body: some View {
        VStack {
            Spacer()
            Text("Hello, World!")
                .frame(width: rectSize.width, height: rectSize.height)
                .background(.blue)
            Spacer()
            HStack {
                Rectangle()
                GeometryReader { geo in
                    Rectangle()
                        .updateRectangleGeoSize(geo.size)
                        .overlay(
                            Text("\(geo.size.width)")
                                .foregroundStyle(.white)
                        )
                }
                Rectangle()
            }
            .frame(height: 55)
        }
        .onPreferenceChange(RectangleGeometrySizePreferenceKey.self, perform: { value in
            self.rectSize = value
        })
    }
}

struct RectangleGeometrySizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func updateRectangleGeoSize(_ size: CGSize) -> some View {
        preference(key: RectangleGeometrySizePreferenceKey.self, value: size)
    }
}

#Preview {
    GeometryPreferenceKey()
}
