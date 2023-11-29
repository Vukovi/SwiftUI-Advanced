//
//  04_MatchedGeometryEffect.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 15.11.23.
//

import SwiftUI

// MARK: - Matched Geometry treba najcesce upotrebaljvati na predefinisanim shape-ovima.
// MARK: - On omogucava da se jedan view transformise uz animaciju u drugi koji je na drugoj poziciji u odnosu na prvi.

struct MatchedGeometryEffect: View {
    
    @State private var isClicked: Bool = false
    @Namespace private var rectangleNamespace
    private let rectangleID: String = "rectangleID"
    
    var body: some View {
        VStack {
            if !isClicked {
                RoundedRectangle(cornerRadius: 25)
                    .matchedGeometryEffect(id: rectangleID, in: rectangleNamespace)
                    .frame(width: 100, height: 100)
                //                .offset(y: isClicked ? UIScreen.main.bounds.height * 0.75 : 0)
            }
            
            Spacer()
            
            if isClicked {
                RoundedRectangle(cornerRadius: 25)
                    .matchedGeometryEffect(id: rectangleID, in: rectangleNamespace)
                    .frame(width: 300, height: 200)
                //                .offset(y: isClicked ? UIScreen.main.bounds.height * 0.75 : 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .onTapGesture {
            withAnimation(.easeInOut) {
                isClicked.toggle()
            }
        }
    }
}

struct MatchedGeometryEffectSegmentControl: View {
    
    @State private var selected: String = ""
    @Namespace private var selectedNamespace
    private let selectedID: String = "selectedID"
    private let categories: [String] = ["Home", "Popular", "Saved"]
    
    var body: some View {
        HStack(spacing: 40) {
            ForEach(categories, id: \.self) { category in
                ZStack {
                    if selected == category {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.blue)
                            .matchedGeometryEffect(id: selectedID, in: selectedNamespace)
                            .frame(width: 35, height: 2)
                            .offset(y: 10.0)
                    }
                    
                    Text(category)
                        .foregroundStyle(selected == category ? Color.red : Color.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selected = category
                    }
                }
            }
        }
    }
}

#Preview {
//    MatchedGeometryEffect()
    MatchedGeometryEffectSegmentControl()
}
