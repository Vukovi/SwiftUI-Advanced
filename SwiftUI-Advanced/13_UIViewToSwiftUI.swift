//
//  UIViewToSwiftUI.swift
//  AdvancedSwift
//
//  Created by Vuk Knezevic on 10.10.23.
//

import SwiftUI

struct UIViewToSwiftUI: View {
    
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            Text(text)
            
            HStack {
                Text("SwiftUI:")
                TextField("Type here...", text: $text)
                    .frame(height: 55)
                    .background(Color.gray)
            }
            
            HStack {
                Text("UIKit: ")
                UITextFieldViewRepresentable(text: $text)
                    .updatePlaceholder("New placeholder")
                    .frame(height: 55)
                    .background(Color.gray)
            }
        }
        
    }
}

struct UIViewToSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        UIViewToSwiftUI()
    }
}


struct BasicUIViewRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct UITextFieldViewRepresentable: UIViewRepresentable {
    
    @Binding var text: String
    
    var placeholder: String
    
    let placeHolderColor: UIColor
    
    init(text: Binding<String>, placeholder: String = "Default placeholder", placeHolderColor: UIColor = .red) {
        self._text = text
        self.placeholder = placeholder
        self.placeHolderColor = placeHolderColor
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = getTextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    private func getTextField() -> UITextField {
        let view = UITextField(frame: .zero)
        let placeholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor : placeHolderColor]
        )
        view.attributedPlaceholder = placeholder
        return view
    }
    
    // MARK: - Ako hocemo naknadno da updateujemo representable view
    func updatePlaceholder(_ text: String) -> UITextFieldViewRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeholder = text
        return viewRepresentable
    }
    
    // MARK: - Komunikacija SwiftUI ->  UIKit
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    // MARK: - Komunikacija UIKit -> SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text )
    }
    // MARK: - Da bi se omogucila komunikacij UIKit -> SwiftUI treba nam jedna unutrasnja klasa Coordinator, koja ce se podvrgnuti odredjenom delegatu
    class Coordinator: NSObject,  UITextFieldDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            // MARK: -   _ se odnosi na Binding property-je
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
}
