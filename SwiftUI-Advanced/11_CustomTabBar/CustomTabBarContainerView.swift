//
//  CustomTabBarContainerView.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 21.11.23.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    
    let content: Content
    @Binding var tabBarItem: TabBarItem
    @State private var tabs: [TabBarItem] = []
    
    init(tabBarItem: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._tabBarItem = tabBarItem
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            
            CustomTabBarView(tabs: tabs, selection: $tabBarItem, localSelection: tabBarItem)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            tabs = value
        })
    }
}

#Preview {
    
    let tabs: [TabBarItem] = [ .home, .favourites, .profile ]
    
    return CustomTabBarContainerView(tabBarItem: .constant(tabs.first!)) {
        Color.red
    }
}
