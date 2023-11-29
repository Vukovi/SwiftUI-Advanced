//
//  16_UI_Testing.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 22.11.23.
//

import SwiftUI
// MARK: - Veza sa main aplikacijom. koja se postavlja kao globaalna varijabla u testu. Vidi UITestingBootcampView_UITests.swift
// let app = XCUIApplication()

// MARK: - Oznacavanjem odredjene metode u UITestu, npr CMD + CLICK ili postavljanjem kursora unutar jos uvek praznog bloka (nije obavezno da bude prazan) i zatim klikom na crveno dugme RECORD koje se nalazi u levom uglu donje trake, snima se svaka interakcija sa ekranom i to se ispisuje kao kod, koji se posle malo dotera.
// MARK: - Doteruje se tako sto od automatski ispisanog koda interakcije
// app.textFields["SignUpTextField"],
// napravim let textfield = app.textFields["SignUpTextField"].
// Prakticno sam samo na postojeci generisan kod dodao let textfield = ...

/*
 func signUpAndSignIn(shouldTypeOnKeyboard: Bool) {
     let textfield = app.textFields["SignUpTextField"]
     textfield.tap()
     
     if shouldTypeOnKeyboard {
         let keyA = app.keys["A"]
         keyA.tap()
         let keya = app.keys["a"]
         keya.tap()
         keya.tap()
     }

     let returnButton = app.buttons["Return"]
     returnButton.tap()
     
     let signUpButton = app.buttons["SignUpButton"]
     signUpButton.tap()
 }
 */

// MARK: - Pronalazenje elementa po nekom hardcode-ovanom stringu ne valja za UI test jer to moze da se menja. Elementu koji se testira treba dodati .accessibilityIdentifier("SignUpTextField") sa nekim nepromenljivim stringom tako da se po tom stringu ovaj element pronalazi u testu

// MARK: - Za Alerte ne moze .accessibilityIdentifier vec mora app.alerts.firtMatch i mora da se uradi waitForExistence jer se alert ne pojavljuje odmah na ekranu kako se izvrsava test, tj test se brze izvrsava u odnosu na pojavljivanje alerta.


// MARK: - Scheme -> Edit Scheme -> mozemo dodati ArgumentsOnLaunch i EnvironmentVariables, koje mozemo potom cekirati kako bi bili aktivni ili neaktivni. Za potrebe testiranja da bi se zapamtio signedIn user, mozemo postaviti flag kao argument i onda ga kao dependency isporuciti testu. Ukoliko bismo koristili EnvironmentVariables, oni su tipa [String:String].
// MARK: - Obicno se taj argument pise sa crtom kao prefiksom, npr ovako:
// -UITest_startSignedIn
// MARK: - Ovo pronalazimo u main SwiftUI fajlu kojem dodajemo init, vidi SwiftUI_AdvancedApp.swift, jer bismo tamo pozvali ovaj nas VIEW da bude prvi koji se startuje, pa bi ga npr. sa tog mesta preneli ove argumente ili environment varijable na njega kao dependensije.
// let userSignedIn: Bool = CommandLine.arguments.contains("-UITest_startSignedIn") ? true : false
// ILI
// let userSignedIn: Bool = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn") ? true : false
// ILI
// let userSignedIn: Bool = ProcessInfo.processInfo.environment.["-UITest_startSignedIn2"] == "true" ? true : false
// MARK: - Samom testu bi u lanch metodi prosledili fizicki ove argumente i envoronment varijable ovako:
/*
 override func setUpWithError() throws {
     continueAfterFailure = false
     app.launchArguments = ["-UITest_startSignedIn"] <- EVO OVAKO
     app.launchEnvironment = ["-UITest_startSignedIn2" : "true"] <- I EVO OVAKO
     app.launch()
 }
 */

class UITestingBootcampViewModel: ObservableObject {
    
    let placeholderText: String = "Add name here..."
    @Published var textFieldText: String = ""
    @Published var currentUserIsSignedIn: Bool
    
    init(currentUserIsSignedIn: Bool) {
        self.currentUserIsSignedIn = currentUserIsSignedIn
    }
        
    func signUpButtonPressed() {
        guard !textFieldText.isEmpty else { return }
        currentUserIsSignedIn = true
    }
    
}

struct UITestingBootcampView: View {
    
    @StateObject private var vm: UITestingBootcampViewModel
    
    init(currentUserIsSignedIn: Bool) {
        _vm = StateObject(wrappedValue: UITestingBootcampViewModel(currentUserIsSignedIn: currentUserIsSignedIn))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
        
            ZStack {
                if vm.currentUserIsSignedIn {
                    SignedInHomeView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .trailing))
                }
                if !vm.currentUserIsSignedIn {
                    signUpLayer
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
            }
            
            
        }
    }
}

struct UITestingBootcampView_Previews: PreviewProvider {
    static var previews: some View {
        UITestingBootcampView(currentUserIsSignedIn: true)
    }
}

extension UITestingBootcampView {
    
    private var signUpLayer: some View {
        VStack {
            TextField(vm.placeholderText, text: $vm.textFieldText)
                .font(.headline)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .accessibilityIdentifier("SignUpTextField")
            
            Button(action: {
                withAnimation(.spring()) {
                    vm.signUpButtonPressed()
                }
            }, label: {
                Text("Sign Up")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            .accessibilityIdentifier("SignUpButton")

        }
        .padding()
    }
    
}

struct SignedInHomeView: View {
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Button(action: {
                    showAlert.toggle()
                }, label: {
                    Text("Show welcome alert!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                })
                .accessibilityIdentifier("ShowAlertButton")
                .alert(isPresented: $showAlert, content: {
                    return Alert(title: Text("Welcome to the app!"))
                })
                
                
                NavigationLink(
                    destination: Text("Destination"),
                    label: {
                        Text("Navigate")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                    .accessibilityIdentifier("NavigationLinkToDestination")
                
            }
            .padding()
            .navigationTitle("Welcome")
        }
    }
}

