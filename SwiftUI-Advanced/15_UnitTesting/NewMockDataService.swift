//
//  NewMockDataService.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Vuk Knezevic on 10.10.23.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Kod pisanja testova, mozemo testirati funkcionalsnost biznis logike i mozemo testirati i performanse testiranjem vremena izvrsenja
// MARK: - [testMethod() throws] i [testPerformanceMethod() throws { self.measure {....} }]
// MARK: - Obicno se u Test Targetu prave posebni fajlovi sa imenom klase koja se testira i dodavanjem _Tests na naziv klase ili strukture koja se testira
// MARK: - Kad se na vrhu test fajla pokrene sveukupni test, posle svake test metode koju smo pisali se pozivaju setUpWithError() i tearDownWithError() jedna za drugom da bi se kreiralo a zatim i resetovalo test okruzenje. To je vazno jer ce nam sveukupni test pokrenute sve test metode, a u pojedinim metodama podaci koji se testiraju moraju krenuti od pocetnih vrednosti i ukoliko nismo ponistili test okrucenje u TearDown metodi mozemo preneti podatke iz prethodnog testa u novi test i dobiti lazne rezultate. Npr viewmodel je kao varijabla opcional u test fajlu, jer ce se npr menjati u test metodama ono sto je potrebno proslediti viewModelu. U metodi setUpWithError(), koja je slicna viewWillAppear() metodi, se onda obavlja inicijalizacija, a u metodi tearDownWithError() se zatim obavlja postavljanje viewModela na nil.
// MARK: - Metode se imenuju sa obaveznim prefiksom test
// MARK: - Asinhroni kod se testira pomocu [let expectation = XCTestExpectation()], expectation se zatim postavlja da je [expectation.fulfill()] kad se asinhrona metoda zavrsi, i na kraju koristi se [wait(for: [expectation], timeout: 5)], za neko postavljeno vreme
// MARK: - U metodi tearDownWithError() bi trebalo pozvati cancellables.removeAll(), ako se koristi Combine u test fajlovima.

protocol NewDataServiceProtocol {
    func downloadItemsWithEscaping(completion: @escaping (_ items: [String]) -> ())
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error>
}

class NewMockDataService: NewDataServiceProtocol {
    
    let items: [String]
    
    init(items: [String]?) {
        self.items = items ?? [
            "ONE", "TWO", "THREE"
        ]
    }
    
    func downloadItemsWithEscaping(completion: @escaping (_ items: [String]) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(self.items)
        }
    }
    
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error> {
        Just(items)
            .tryMap({ publishedItems in
                guard !publishedItems.isEmpty else {
                    throw URLError(.badServerResponse)
                }
                return publishedItems
            })
            .eraseToAnyPublisher()
    }
    
}
