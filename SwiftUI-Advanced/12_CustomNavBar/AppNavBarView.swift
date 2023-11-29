//
//  AppNavBarView.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 21.11.23.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        CustomNavigationView {
            ZStack {
                Color.green.ignoresSafeArea()
                
                CustomNavLink {
                    Text("Destination")
                        .customNavigationTitle("Destination Title")
                        .customNavigationSubtitle("Destination Subtitle")
                } label: {
                    Text("Go To Destination")
                }
            }
            .customNavBarItems(title: "Custom Title", subtitle: nil, backButtonHidden: true)
        }
    }
}

#Preview {
    AppNavBarView()
}


extension AppNavBarView {
    private var defaultView: some View {
        NavigationView {
            ZStack {
                Color.green.ignoresSafeArea()
                
                NavigationLink {
                    Text("Destination")
                } label: {
                    Text("Go To Destination")
                }
            }
            .navigationTitle("Starting title")
        }
    }
}
