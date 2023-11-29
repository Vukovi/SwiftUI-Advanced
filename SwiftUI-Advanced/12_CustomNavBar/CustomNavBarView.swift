//
//  CustomNavBarView.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 21.11.23.
//

import SwiftUI

struct CustomNavBarView: View {
    
    let showBackButton: Bool
    let title: String
    let subtitle: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            if showBackButton {
                backButton
            }
            Spacer()
            titleSection
            Spacer()
            if showBackButton {
                backButton.opacity(0)
            }
        }
        .padding()
        .accentColor(.white)
        .foregroundStyle(.white)
        .font(.headline)
        .background(Color.blue.ignoresSafeArea(edges: .top))
        
    }
}

#Preview {
    VStack {
        CustomNavBarView(showBackButton: true, title: "Title", subtitle: "Subtitle")
        Spacer()
    }
}

extension CustomNavBarView {
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
        })
    }
    
    private var titleSection: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            
            if let subtitle = subtitle {
                Text(subtitle)
            }
        }
    }
}
