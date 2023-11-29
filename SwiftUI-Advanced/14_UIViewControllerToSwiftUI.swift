//
//  UIViewControllerToSwiftUI.swift
//  AdvancedSwift
//
//  Created by Vuk Knezevic on 10.10.23.
//

import SwiftUI

struct UIViewControllerToSwiftUI: View {
    
    @State private var showScreen: Bool = false
    @State private var image: UIImage?
    
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            Button(action: {
                showScreen.toggle()
            }, label: {
                Text("Click here!")
            })
            .sheet(isPresented: $showScreen, content: {
//                BasicUIViewControllerRepresentable(labelText: "hallo")
                UIImagePickerControllerRepresentable(image: $image, showScreen: $showScreen )
            })

        }
    }
}

struct UIViewControllerToSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerToSwiftUI()
    }
}


struct UIImagePickerControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var showScreen: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.allowsEditing = false
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
         
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, showScreen: $showScreen)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @Binding var image: UIImage?
        @Binding var showScreen: Bool
        
        init(image: Binding<UIImage?>, showScreen: Binding<Bool>) {
            self._image = image
            self._showScreen = showScreen
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let newImage = info[.originalImage] as? UIImage else { return }
            image = newImage
            showScreen = false
        }
    }
}

struct BasicUIViewControllerRepresentable: UIViewControllerRepresentable {
    let labelText: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = MyBasicUIViewController()
        vc.labelText = labelText
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {    }
    
    func makeCoordinator() -> () {
        return ()
    }
}


class MyBasicUIViewController: UIViewController {
    var labelText: String = "Starting value"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue
        
        let label: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.text = labelText
            return label
        }()
        
        self.view.addSubview(label)
        label.frame = self .view.frame
    }
}
