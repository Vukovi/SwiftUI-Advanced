//
//  ScrollViewOffsetPreferenceKey.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 20.11.23.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: View {
    
    @State private var text: String = "Title"
    @State private var scrollViewOffset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack {
                titleLayer
                    .opacity(Double(scrollViewOffset) / 75)
                    .onScrollViewOffsetChange { offset in
                        scrollViewOffset = offset
                    }
                // MARK: - ovo sklanjam i menjam sa onScrollViewOffsetChange
//                    .background(
//                        // MARK: - Postavljam geometry reader na titleLayer, na njegovu minY tacku, pomocu Text elementa koji se nece videti
//                        GeometryReader { geo in
//                            Text("")
//                                .preference(key: ScrollViewOffsetKey.self,
//                                            value: geo.frame(in: .global).minY)
//                        }
//                    )
                
                contentLayer
            }
            .padding()
        }
        .overlay(Text("\(scrollViewOffset)"))
        // MARK: - ovo sklanjam jer sam onScrollViewOffsetChange extenziju napravio sa klozerom
//        .onPreferenceChange(ScrollViewOffsetKey.self, perform: { value in
//            scrollViewOffset = value
//        })
        .overlay(
            navBarLayer
                .opacity(scrollViewOffset < 40 ? 1 : 0),
            alignment: .top
        )
    }
}

#Preview {
    ScrollViewOffsetPreferenceKey()
}

extension ScrollViewOffsetPreferenceKey {
    
    private var titleLayer: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var contentLayer: some View {
        ForEach(0..<100) { _ in
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.3))
                .frame(width: 300, height: 200)
        }
    }
    
    private var navBarLayer: some View {
        Text(text)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.blue)
    }
}


struct ScrollViewOffsetKey: PreferenceKey {
     static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    
    func onScrollViewOffsetChange(action: @escaping (_ offset: CGFloat) -> Void) -> some View {
        
        self
            .background(
            // MARK: - Postavljam geometry reader na titleLayer, na njegovu minY tacku, pomocu Text elementa koji se nece videti
            GeometryReader { geo in
                Text("")
                    .preference(key: ScrollViewOffsetKey.self,
                                value: geo.frame(in: .global).minY)
            }
        )
            .onPreferenceChange(ScrollViewOffsetKey.self, perform: { value in
                action(value)
            })

    }
}
