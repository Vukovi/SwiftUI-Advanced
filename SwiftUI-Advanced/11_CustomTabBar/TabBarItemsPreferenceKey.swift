//
//  TabBarItemsPreferenceKey.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 21.11.23.
//

import Foundation
import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}


struct TabBarViewModifier: ViewModifier {
    let tabItem: TabBarItem
    @Binding var selection: TabBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tabItem ? 1 : 0)
            .preference(key: TabBarItemsPreferenceKey.self, value: [tabItem])
    }
}


extension View {
    func tabBarItem(tabItem: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        self.modifier(TabBarViewModifier(tabItem: tabItem, selection: selection))
    }
}
