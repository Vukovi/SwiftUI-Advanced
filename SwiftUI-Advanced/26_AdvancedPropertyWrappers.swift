//
//  26_AdvancedPropertyWrappers.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 28.11.23.
//

import SwiftUI
import Combine

@propertyWrapper
struct Capitalized: DynamicProperty {
    
    @State private var value: String
    
    var wrappedValue: String {
        get {
            value
        }
        nonmutating set {
            value = newValue.capitalized
        }
    }
    
    init(wrappedValue: String) {
        self.value = wrappedValue.capitalized
    }
}



@propertyWrapper
struct Uppercased: DynamicProperty {
    
    @State private var value: String
    
    var wrappedValue: String {
        get {
            value
        }
        nonmutating set {
            value = newValue.uppercased()
        }
    }
    
    init(wrappedValue: String) {
        self.value = wrappedValue.uppercased()
    }
}


@propertyWrapper // struct FileManagerCodableProperty<T: Codable>: DynamicProperty ISTO STO I  OVO SA WHERE
struct FileManagerCodableProperty<T>: DynamicProperty where T: Codable {
    
    @State private var value: T?
    
    var wrappedValue: T? {
        get { value }
        nonmutating set { save(newValue: newValue) }
    }
    
    var projectedValue: Binding<T?> {
        Binding {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
        }

    }
    
    let key: String
    
    // MARK: - Necu da mi wrappedValue bude izlozeno u startu zbog toga sto prilikom inicijalizacije uvek mora da se onda T ubacuje, tj da ima vrednost ili da bude nil, zato brisem wrappedValue iz inicijalizatora
//    init(wrappedValue: T?, _ key: String) {
    init(_ key: String) {
        self.key = key
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data) 
//            value = object MARK: - ovo daje mali bug jer po novom startovanju ne daje sacuvani podatak. To se dogadja jer je ovde setovan property VALUE umesto @State wrappera koji porperty VALUE ima upravo zbog @State. Dakle mora da se pristupi wrapperu i onda bug nece postojati
            _value = State(wrappedValue: object)
            print("SUCCESS READ")
        } catch {
//            value = wrappedValue
//            _value = State(wrappedValue: wrappedValue)
            _value = State(wrappedValue: nil)
            print("ERROR READ: \(error)")
        }
    }
    
    
    // MARK: - Keypath inicijaliztor
    init(_ key: KeyPath<FileManagerValues, String>) {
        
        let keyPath = FileManagerValues.shared[keyPath: key]
        let key = keyPath
        self.key = key
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(wrappedValue: object)
            print("SUCCESS READ")
        } catch {
            _value = State(wrappedValue: nil)
            print("ERROR READ: \(error)")
        }
    }
    
    // MARK: - Keypath inicijaliztor kao za @Environment
    init(_ key: KeyPath<FileManagerValues, FileManagerKeyPath<T>>) {
        
        let keyPath = FileManagerValues.shared[keyPath: key]
        let key = keyPath.key
        self.key = key
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(wrappedValue: object)
            print("SUCCESS READ")
        } catch {
            _value = State(wrappedValue: nil)
            print("ERROR READ: \(error)")
        }
    }
    
    private func save(newValue: T?) {
        do {
            let data = try JSONEncoder().encode(newValue)
            try data.write(to: FileManager.documentsPath(key: key))
            value = newValue
            print("SUCCESS")
        } catch {
            print("ERROR SAVING: \(error)")
        }
    }
}

struct User: Codable {
    let name: String
    let age: Int
    let isPremium: Bool
}

struct FileManagerValues {
    static let shared = FileManagerValues()
    private init() {}
    
    let userProfileString = "user_profile"
    
    let userProfileGenericType = FileManagerKeyPath(key: "user_profile", type: User.self)
}

struct FileManagerKeyPath<T: Codable> {
    let key: String
    let type: T.Type
}

struct CustomProjectedValue<T: Codable> {
    let binding: Binding<T?>
    let publisher: CurrentValueSubject<T?, Never>
    
    var stream: AsyncPublisher<CurrentValueSubject<T?, Never>> {
        publisher.values
    }
}


// TODO: - Napravi keychain property wrapper


struct AdvancedPropertyWrappers: View {
    
    @Uppercased private var title: String = "Hello, world!"
    // MARK: - S obzirom da sam uklonio wrapped value iz inicijalizatora, ne moram vise da proglasavm vrednost, tj uklanjam   = nil
    @FileManagerCodableProperty("user_profile") private var userProfile: User? // = nil
    
    @FileManagerCodableProperty(\.userProfileString) private var userProfileWithKeyPath: User?
    
    // MARK: - Kako je promenjen keyPath u custom generic keyPath sad moze da radi bez deklarisanja tipa objekta jer je on vec deklarisan u FileManagerValues pomocu FileManagerKeyPath
    @FileManagerCodableProperty(\.userProfileGenericType) private var userProfileWithKeyPathGeneric
    
    @FileManagerCodableStreamable(\.userProfileGenericType) private var reactiveUser
    
    var body: some View {
        VStack(spacing: 40) {
            
            Text(title)
            
            Button(title) {
                title = "New title!"
            }
            
            Text(userProfile?.name ?? "USER UNKNOWN")
            
            Button(userProfile?.name ?? "USER UNKNOWN") {
                userProfile = User(name: "Vuk", age: 40, isPremium: true)
            }
            
            SomeBindingView(userProfile: $userProfile)
            
            SomeBindingView(userProfile: $userProfileWithKeyPath)
            
            SomeBindingView(userProfile: $userProfileWithKeyPathGeneric)
            
            Button(reactiveUser?.name ?? "USER UNKNOWN") {
                userProfile = User(name: "Vracar", age: 200, isPremium: true)
            }
            
            SomeBindingView(userProfile: $reactiveUser.binding)
        }
        .onAppear {
            print(NSHomeDirectory())
        }
//        .onReceive($reactiveUser, perform: { user in
//            print(user?.name ?? "NEMA")
//        })
//        .task {
//            for await user in $reactiveUser.values {
//                print(user?.name ?? "NEMA")
//            }
//        }
        .onReceive($reactiveUser.publisher, perform: { user in
            print(user?.name ?? "NEMA")
        })
        .task {
            for await user in $reactiveUser.stream {
                print(user?.name ?? "NEMA")
            }
        }
    }
}

struct SomeBindingView: View {
    
    @Binding var userProfile: User?
    
    var body: some View {
        Button(userProfile?.name ?? "USER UNKNOWN") {
            userProfile = User(name: "Vuk Knezevic", age: 40, isPremium: true)
        }
    }
}

#Preview {
    AdvancedPropertyWrappers()
}


@propertyWrapper
struct FileManagerCodableStreamable<T>: DynamicProperty where T: Codable {
    
    @State private var value: T?
    let key: String
    private let publisher: CurrentValueSubject<T?, Never>
    
    var wrappedValue: T? {
        get { value }
        nonmutating set { save(newValue: newValue) }
    }
    
//    var projectedValue: Binding<T?> {
//        Binding {
//            wrappedValue
//        } set: { newValue in
//            wrappedValue = newValue
//        }
//    }
    
//    var projectedValue: CurrentValueSubject<T?, Never> {
//        publisher
//    }
    
    var projectedValue: CustomProjectedValue<T> {
        CustomProjectedValue(
            binding: Binding(
                get: { wrappedValue },
                set: { wrappedValue = $0 }
            ),
            publisher: publisher
        )
    }

    init(_ key: String) {
        self.key = key
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(wrappedValue: object)
            publisher = CurrentValueSubject(object)
            print("SUCCESS READ")
        } catch {
            _value = State(wrappedValue: nil)
            publisher = CurrentValueSubject(nil)
            print("ERROR READ: \(error)")
        }
    }
    
    // MARK: - Keypath inicijaliztor kao za @Environment
    init(_ key: KeyPath<FileManagerValues, FileManagerKeyPath<T>>) {
        
        let keyPath = FileManagerValues.shared[keyPath: key]
        let key = keyPath.key
        self.key = key
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(wrappedValue: object)
            publisher = CurrentValueSubject(object)
            print("SUCCESS READ")
        } catch {
            _value = State(wrappedValue: nil)
            publisher = CurrentValueSubject(nil)
            print("ERROR READ: \(error)")
        }
    }
    
    private func save(newValue: T?) {
        do {
            let data = try JSONEncoder().encode(newValue)
            try data.write(to: FileManager.documentsPath(key: key))
            value = newValue
            publisher.send(newValue)
            print("SUCCESS")
        } catch {
            print("ERROR SAVING: \(error)")
        }
    }
}
