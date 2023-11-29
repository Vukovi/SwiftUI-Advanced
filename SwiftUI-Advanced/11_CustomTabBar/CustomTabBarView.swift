//
//  CustomTabBarView.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 21.11.23.
//

import SwiftUI

struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem
    
    var body: some View {
        tabBarVersion2
            .onChange(of: selection) {
                withAnimation(.easeInOut) {
                    localSelection = selection
                }
            }
    }
    
    private func switchToTab(_ tab: TabBarItem) {
        selection = tab
    }
}

extension CustomTabBarView {
    private func tabView(tabItem: TabBarItem) -> some View {
        VStack {
            Image(systemName: tabItem.iconName)
                .font(.headline)
            Text(tabItem.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(localSelection == tabItem ? tabItem.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(localSelection == tabItem ? tabItem.color.opacity(0.2) : Color.clear)
        .cornerRadius(10)
    }
        
    var tabBarVersion: some View {
        HStack {
            ForEach(tabs, id: \.self) { tabItem in
                tabView(tabItem: tabItem)
                    .onTapGesture {
                        switchToTab(tabItem)
                    }
            }
        }
        .padding(6)
        .background(
            Color.clear
            .opacity(0.2)
            .ignoresSafeArea(edges: .bottom)
        )
    }
}

extension CustomTabBarView {
    private func tabView2(tabItem: TabBarItem) -> some View {
        VStack {
            Image(systemName: tabItem.iconName)
                .font(.headline)
            Text(tabItem.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(localSelection == tabItem ? tabItem.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                if localSelection == tabItem {
                   RoundedRectangle(cornerRadius: 10)
                        .fill(tabItem.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle_tab", in: namespace)
                }
            }
        )
    }
    
    var tabBarVersion2: some View {
        HStack {
            ForEach(tabs, id: \.self) { tabItem in
                tabView2(tabItem: tabItem)
                    .onTapGesture {
                        switchToTab(tabItem)
                    }
            }
        }
        .padding(6)
        .background(
            Color.white
            .ignoresSafeArea(edges: .bottom)
        )
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 10)
        .padding(.horizontal)
    }
}



#Preview {
    let tabs: [TabBarItem] = [.home, .favourites, .profile]
    
    return VStack {
        Spacer()
        CustomTabBarView(tabs: tabs, selection: .constant(tabs.first!), localSelection: tabs.first!)
    }
}



enum TabBarItem: Hashable {
    case home, favourites, profile
    
    var iconName: String {
        switch self {
        case .home: "house"
        case .favourites: "heart"
        case .profile: "person"
        }
    }
    
    var title: String {
        switch self {
        case .home: "Home"
        case .favourites: "Favourites"
        case .profile: "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .home: Color.red
        case .favourites: Color.blue
        case .profile: Color.green
        }
    }
}
