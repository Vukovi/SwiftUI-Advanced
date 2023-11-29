//
//  AppTabViewBar.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 20.11.23.
//

import SwiftUI

struct AppTabViewBar: View {
    
    @State private var selection: TabBarItem = .home
    
    var body: some View {
        CustomTabBarContainerView(tabBarItem: $selection) {
            Color.red
                .tabBarItem(tabItem: .home, selection: $selection)
            
            Color.blue
                .tabBarItem(tabItem: .favourites, selection: $selection)
            
            Color.green
                .tabBarItem(tabItem: .profile, selection: $selection)
        }
    }
}

#Preview {
    return AppTabViewBar()
}
