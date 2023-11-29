//
//  24_KeyPaths.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 28.11.23.
//

import SwiftUI

//protocol

struct MyDataModel: Identifiable {
    let id = UUID().uuidString
    let title: MovieTitle
    let count: Int
    let date: Date
}

struct MovieTitle {
    let primary: String
    let secondary: String
}

// MARK: - Po komentarima se vidi kako se gradila ova extenzija, u principu svaki korak je isti, ali je i svaki napredniji od prethodnog
extension Array where Element == MyDataModel {
//    func customSort() -> [MyDataModel] {
//    func customSort() -> [Element] {
//    func customSort(keyPath: KeyPath<MyDataModel, Int>) -> [Element] {
//    func customSort(keyPath: KeyPath<Element, Int>) -> [Element] {
    func customSort<T: Comparable>(keyPath: KeyPath<Element, T>) -> [Element] {
//        return self.sorted { $0.count < $1.count }
//        return self.sorted { $0[keyPath: \.count] < $1[keyPath: \.count] }
        return self.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}

// MARK: - Korak dalje u pravljenju jos generickije ekstenzije
extension Array {
//    func customSortByKeyPath<T: Comparable>(_ keyPath: KeyPath<Element, T>) -> [Element] {
    func customSortByKeyPath<T: Comparable>(_ keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
//        return self.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
        return self.sorted { ascending ? $0[keyPath: keyPath] < $1[keyPath: keyPath] : $0[keyPath: keyPath] > $1[keyPath: keyPath] }
    }
    
    // MARK: - Za mutabilne nizove, var array, mozemo korstiti i metodu sort() na sam niz, zato i nasa metoda mora biti mutabilna
    mutating func customSortingByKeyPath<T: Comparable>(_ keyPath: KeyPath<Element, T>, ascending: Bool = true) {
        return self.sort { ascending ? $0[keyPath: keyPath] < $1[keyPath: keyPath] : $0[keyPath: keyPath] > $1[keyPath: keyPath] }
    }
}

struct KeyPaths: View {
    
    @AppStorage("user_count") var userCount: Int = 0
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var mode
    @State private var screenTitle: String = ""
    
    @State private var dataArray: [MyDataModel] = []
    
    var body: some View {
        List {
            ForEach(dataArray) { element in
                VStack(alignment: .leading) {
                    Text(element.id)
                    Text(element.title.primary)
                    Text("\(element.count)")
                    Text(element.date.description)
                }
            }
        }
        Text(screenTitle)
            .onAppear {
                let item = MyDataModel(title: MovieTitle(primary: "Alpha", secondary: "Beta"), count: 1, date: .now)
                // MARK: - Sledece dve linije su identicne
                let title = item.title.primary
                let title2 = item[keyPath: \.title.primary]
                
                let array = [
                    MyDataModel(title: MovieTitle(primary: "Alpha", secondary: "Beta"), count: 3, date: .now),
                    MyDataModel(title: MovieTitle(primary: "Gamma", secondary: "Delta"), count: 1, date: .now),
                    MyDataModel(title: MovieTitle(primary: "Eta", secondary: "Epsilon"), count: 2, date: .now)
                ]
                
                let newArray = array.sorted {
                    $0.count < $1.count
                }
                // ISTO STO I IZNAD
                let newArray1 = array.sorted { item1, item2 in
                    item1[keyPath: \.count] < item2[keyPath: \.count]
                }
                // ISTO STO I OBA IZNAD
//                let newArray2 = array.customSort()
                let newArray2 = array.customSort(keyPath: \.date) // datum sad moze da se korsiti takodje jer je ekstenzija podvrgnuta Comparable protokolu
                // ISTO STO I SVE IZNAD
                let newArray3 = array.customSortByKeyPath(\.count, ascending: false)
                
                var array2 = [
                    MyDataModel(title: MovieTitle(primary: "Alpha", secondary: "Beta"), count: 3, date: .now),
                    MyDataModel(title: MovieTitle(primary: "Gamma", secondary: "Delta"), count: 1, date: .now),
                    MyDataModel(title: MovieTitle(primary: "Eta", secondary: "Epsilon"), count: 2, date: .now)
                ]
                
                array2.customSortingByKeyPath(\.count, ascending: false)
                
                dataArray = array
                
            }
    }
}

#Preview {
    KeyPaths()
}
