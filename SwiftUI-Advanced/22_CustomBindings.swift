//
//  22_CustomBindings.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 28.11.23.
//

import SwiftUI

extension Binding where Value == Bool {
    init(myValue: Binding<String?>) {
        self.init {
//            return value.wrappedValue != nil ? true : false
            // ISTO STO I GORE
            myValue.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                myValue.wrappedValue = nil
            }
        }

    }
    
    // MARK: - Pravim ovaj custom Binding takvim da vazi za sve tipove ne samo za String
    init<T>(myValue: Binding<T?>) {
        self.init {
            myValue.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                myValue.wrappedValue = nil
            }
        }

    }
}

struct CustomBindings: View {
    
    @State var title: String = "Start"
    @State private var errorTitle: String? = nil
//    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            Text(title)
            
            ChildBindingView(title: $title)
            
            ChildBindingView2(title: title) { newTitle in
                title = newTitle
            }
            
            ChildBindingView3(title: $title)
            
            ChildBindingView3(title: Binding(get: {
                return title
            }, set: { newValue in
                title = newValue
            }))
            
            Button("Click me") {
                errorTitle = "NEW ERROR !!!"
//                showError.toggle()
            }
        }
        // MARK: - Native Binding Primer
//        .alert(errorTitle ?? "Error", isPresented: $showError) {
//            Button("OK") {
//                
//            }
//        }
        // MARK: - Custom Binding Primer
//        .alert(errorTitle ?? "Error", isPresented: Binding(get: {
////            return errorTitle != nil ? true : false
//            // ISTO STO I GORE
//            errorTitle != nil
//        }, set: { newValue in
//            if !newValue {
//                errorTitle = nil
//            }
//        })) {
//            Button("OK") {
//                
//            }
//        }
        // MARK: - Advanced Custom Binding Primer
        .alert(errorTitle ?? "Error", isPresented: Binding(myValue: $errorTitle)) {
            Button("OK") {}
        }
    }
}

struct ChildBindingView: View {
    
    @Binding var title: String
    
    var body: some View {
        Text(title)
            .onAppear {
//                title = "New Title"
            }
    }
}

struct ChildBindingView2: View {
    
    let title: String
    let setTitle: (String) -> Void
    
    var body: some View {
        Text(title)
            .onAppear {
                setTitle("New Title 2")
            }
    }
}

struct ChildBindingView3: View {
    let title: Binding<String>
    
    var body: some View {
        Text(title.wrappedValue)
            .onAppear {
                title.wrappedValue = "New Title 3"
            }
    }
}

#Preview {
    CustomBindings()
}
