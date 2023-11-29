//
//  09_PreferenceKey.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 20.11.23.
//

import SwiftUI

struct PreferenceKeyBootcamp: View {
    
    @State private var text: String = "Hello"
    
    var body: some View {
        NavigationView {
            VStack {
                SecondaryScreen(text: text)
                    .navigationTitle("Title")
//                    .preference(key: CustomTitlePreferenceKey.self, value: "NEW TITLE !!!")
                // MARK: - gornji red radi isto sto i donji, a tako radi i navigationTitle
//                    .customTitle("NEW TITLE !!!")
            }
        }
        .onPreferenceChange(CustomTitlePreferenceKey.self, perform: { value in
            self.text = value
        })
    }
}

extension View {
    func customTitle(_ text: String) -> some View {
        self.preference(key: CustomTitlePreferenceKey.self, value: text)
    }
}

struct SecondaryScreen: View {
    
    let text: String
    @State private var newValue: String = ""
    
    var body: some View {
        Text(text)
        // MARK: - moze i iz child view-a da menja text na parentovom property-ju
//            .preference(key: CustomTitlePreferenceKey.self, value: "NEW TITLE 2!!!")
            .onAppear(perform: getDataFromDatabase)
            .customTitle(newValue)
    }
    
    func getDataFromDatabase() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            newValue = "NEW VALUE FROM DATABASE"
        }
    }
}

#Preview {
    PreferenceKeyBootcamp()
}

struct CustomTitlePreferenceKey: PreferenceKey {
    
    // MARK: - ovaj defaultValue mora da se pozove
    static var defaultValue: String = ""
    
    // MARK: - ovaj reduce mora da se pozove
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}
