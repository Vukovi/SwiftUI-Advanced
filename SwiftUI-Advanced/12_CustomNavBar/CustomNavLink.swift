//
//  CustomNavLink.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 21.11.23.
//

import SwiftUI

struct CustomNavLink<Label: View, Destination: View>: View {
    
    let destination: Destination
    let label: Label
    
    init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.label = label()
    }
    
    var body: some View {
        NavigationLink {
            CustomNavBarContainerView {
                destination
            }
            .navigationBarHidden(true)
        } label: {
            label
        }
    }
}

#Preview {
    CustomNavigationView {
        CustomNavLink {
            Text("Destination")
        } label: {
            Text("Go Somewhere")
        }
    }
}
