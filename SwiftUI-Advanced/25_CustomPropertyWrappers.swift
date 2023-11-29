//
//  25_CustomPropertyWrappers.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 28.11.23.
//

import SwiftUI

// MARK: - Property wrapper je isto sto i Binding sa getterom i setterom samo sto dodatno cuva i trenutnu vvrednost

struct CustomPropertyWrappers: View {
    
//    @State private var title: String = "Starting title"
//    @State var fileManagerProperty = FileManagerProperty()
//    @FileManagerProperty var finalTitle: String
    @FileManagerProperty("custom_title_1") var finalTitle: String = "Starting Title 1"
    @FileManagerProperty(wrappedValue: "Starting Title 2", "custom_title_2") var finalTitle2: String
    @FileManagerProperty("custom_title_3") var finalTitle3: String = "Starting Title 3"
    
    @State private var subtitle: String = "SUBTITLE"
    
    var body: some View {
        VStack(spacing: 40) {
//            Text(fileManagerProperty.wrappedValue)
            Text(finalTitle)
                .font(.largeTitle)
            
            
            Button("Clcike me 1") {
//                title = "title 1".uppercased()
//                setTitle(newValue: "title 1")
//                fileManagerProperty.save(newValue: "title 1")
//                fileManagerProperty.wrappedValue = "title 1"
                finalTitle = "title 1"
            }
            
            Button("Clcike me 2") {
//                title = "title 2".uppercased()
//                setTitle(newValue: "title 2")
//                fileManagerProperty.save(newValue: "title 2")
//                fileManagerProperty.wrappedValue = "title 2"
                finalTitle = "title 2"
                finalTitle2 = "Some random title"
            }
            
            Text(finalTitle2)
                .font(.largeTitle)
            
            Text(finalTitle3)
                .font(.largeTitle)
            
            Text(subtitle)
                .font(.largeTitle)
            
            ChildCustomPropertyWrappers(subtitle: $subtitle)
            
            // MARK: - ovo moze sa $ da ide jer je u proerty wrapper uveden i propertyWrapper koji je u stavri ekspozovan sa $ kao Binding property
            ChildCustomPropertyWrappers(subtitle: $finalTitle)
        }
        .onAppear {
//            fileManagerProperty.load()
        }
    }
    
    // Hocu da svaki button ima title ispisan velikim slovima
    // Ali kada bih hteo da na nivou projekta imam ovakvu funkcionalnost, onda bih pravio
    // property wrapper tipa @Uppercased private var title: String = ...
//    private func setTitle(newValue: String) {
//        title = newValue.uppercased()
//        save(newValue: newValue.uppercased())
//    }
    

}

struct ChildCustomPropertyWrappers: View {
    @Binding var subtitle: String
    var body: some View {
        Button(action: {
            subtitle = "NOVO"
        }, label: {
            Text(subtitle).font(.largeTitle)
        })
    }
}

#Preview {
    CustomPropertyWrappers(finalTitle: FileManagerProperty(wrappedValue: "Starting Title", "").wrappedValue)
}

extension FileManager {
    // MARK: - Da bismo razlikovali dva property wrapper objekta koji istovremeno mogu da se nadju u VIEW-u uvodimo key parametar
    static func documentsPath(key: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(path: "\(key).txt")
    }
}

// MARK: - Sve je podeseno da ovo bude jedan custom property wrapper. Jedino ce morati da se umesto CURRENT_VALUE korsiti predefinisani WRAPPED_VALUE i da se cela struktura obelezi sa @PropertWrapper
@propertyWrapper
struct FileManagerProperty: DynamicProperty {
    // MARK: - Da bi VIEW u kom se koristi ova struktura znao da unutar nje postoji neki mutabilni element i da bi te promene bile vidljive na tom VIEW-u, ova struktura se podvrgava DynamicProperty-ju
    
    
    // MARK: - Zbog uklanjanja mutating ispred funkcija koje se bave promenom ovog property-ja, mora se dopisati ispred @State
    @State private var title: String
    
    // MARK: - Sve je postavljeno tako da se currentValue moze zameniti sa wrappedValue zbog podvrgavanja @propertyWrapper
//    var currentValue: String {
    var wrappedValue: String {
        get { title }
        // MARK: - Moramo reci setteru da se promenom CURRENT_VALUE property-ja ne mutira cela ova struktura vec se to samo odnosi na TITLE property
        nonmutating set { save(newValue: newValue) }
    }
    
    // MARK: - Ovim omogucujemo Bindovanje, tj koriscenje $ predznaka
    var projectedValue: Binding<String> {
        Binding {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
        }

    }
    
    // MARK: - Da bismo razlikovali dva objekta koji istovremeno mogu da se nadju u VIEW-u uvodimo key parametar, a da bi se ponasao kao @AppStorage uvodimo u inicijalizator i wrappedValue
    let key: String
//    init() {
    init(wrappedValue: String, _ key: String) {
        self.key = key
        do {
            title = try String(contentsOf: FileManager.documentsPath(key: key), encoding: .utf8)
            print("SUCCESS READ")
        } catch {
//            title = "Starting Title"
            title = wrappedValue
            print("ERROR READ: \(error)")
        }
    }
    
//    private var path: URL {
//        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//            .first!
//            .appending(path: "custom_title.txt")
//    }
    
// MARK: - Sklanjanjem mutating keyword-a, mora se dodati sa @State hendlati clan koji je u stvari mutabilan u ovoj strukturi, a to je VAR TITLE
//    mutating func load() {
    func load() {
        do {
//            let savedValue = try String(contentsOf: path, encoding: .utf8)
            let savedValue = try String(contentsOf: FileManager.documentsPath(key: key), encoding: .utf8)
            title = savedValue
            print("SUCCESS READ")
        } catch {
            print("ERROR READ: \(error)")
        }
    }
    
// MARK: - Sklanjanjem mutating keyword-a, mora se dodati sa @State hendlati clan koji je u stvari mutabilan u ovoj strukturi, a to je VAR TITLE
//    mutating func save(newValue: String) {
    private func save(newValue: String) {
        do {
//            try newValue.write(to: path, atomically: false, encoding: .utf8)
            try newValue.write(to: FileManager.documentsPath(key: key), atomically: false, encoding: .utf8)
            print("SUCCESS")
            print(NSHomeDirectory())
            title = newValue
        } catch {
            print("ERROR SAVING: \(error)")
        }
    }
}

