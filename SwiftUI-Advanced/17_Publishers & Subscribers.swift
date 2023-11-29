//
//  17_Publishers & Subscribers.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 23.11.23.
//

import SwiftUI
import Combine

class AdvancedDataService {
    
    @Published var basicPublisher: String = "first publish"
    let currentValuePublisher = CurrentValueSubject<String, Error>("first publish")
    let passthroughPublisher = PassthroughSubject<Int, Error>()
    let boolPublisher = PassthroughSubject<Bool, Error>()
    let intPublisher = PassthroughSubject<Int, Error>()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        
        let intArray: [Int] = Array((0..<11))
        let stringArray: [String] = ["jedan", "dva", "tri"]
        
        for x in intArray.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)) { [weak self] in
                self?.passthroughPublisher.send(intArray[x])
                
                if (x > 4 && x < 8) {
                    self?.boolPublisher.send(true)
                } else {
                    self?.boolPublisher.send(false)
                }
                
                if x == 6 {
                    self?.intPublisher.send(999)
                }
                
                // MARK: - Kad se ispuni sledeci uslov, publisheru ce biti saopsteno da prestane da emituje
                if x == intArray.indices.last {
                    self?.passthroughPublisher.send(completion: .finished)
                }
            }
        }
    }
}

class AdvancedCombineViewModel: ObservableObject {
    
    @Published var data: [String] = []
    @Published var dataBools: [Bool] = []
    @Published var error: String = ""
    let service = AdvancedDataService()
    let multicastPublisher = PassthroughSubject<Int, Error>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {

        service.passthroughPublisher
        // MARK: - PIPELINES!
        
        // MARK: - I) SEQUENCE OPERATIONS:
        
            // 1)
            // MARK: - FIRST -> Emitovanje samo prvog elementa:
//            .first()
            // TODO: -> Rezultat je 0
        
            // 2)
            // MARK: - FIRST_WHERE -> Emitovanje prvog i jedinog elementa koji zadovoljava postavljenu logiku:
//            .first(where: { $0 > 4 })
            // TODO: -> Rezultat je 5
        
            // 3)
            // MARK: - TRY_FIRST -> Emitovanje prvog i jedinog elementa ili errora koji zadovoljava postavljene logike
//            .tryFirst(where: { number in
//                if number == 3 {
//                    throw URLError(.badURL)
//                }
//                return number > 4
//            })
            // TODO: -> Rezultat je bacanje errora, jer je logika postavljna tako da se return nikad nece izvrsiti
        
            // 4)
            // MARK: - LAST -> Emitovanje samo poslednjeg i jedinog elementa uz obavezno postavljnje logike zavrsetka emitovanja:
//            .last()
            // TODO: - > Rezultat biti 10
            // TODO: -> Rezultat nece biti nista i delovace kao da ovaj pipeline ne radi, jer publisheri zive "zauvek" i sam publisher ne zna kada je dosao kraj njegovom emitovanju ocekivajuci jos emitovanja. Zato se mora na samom mestu emitovanja postaviti uslov koji publisheru saopstava da je dosao kraj njegovom emitovanju i onda ce
        
            // 5)
            // MARK: - LAST_WHERE -> Emitovanje poslednjeg elementa koji zadovoljava postavljenu logiku uz obavezno postavljnje logike zavrsetka emitovanja:
//            .last(where: { $0 > 4 })
            // TODO: -> Rezultat ce biti 10
            // TODO: -> Rezultat se i ovde dobija tako sto se pre svega na mestu emitovanja saopsti publisheru kada je kraj emitovanja, zatim ce se proci kroz ceo niz i Rezultat ce biti 10. Ovo lastWhere se koristi radi dodavanja dodatnog uslova
            // TODO: -> Da je uslov bio $0 < 4 onda bi Rezultat bio 3, jer zbog postavljene logike za zavrsetak emitovanja publisher-a opet bi se proslo kroz ceo niz emitovanja
        
            // 6)
            // MARK: - TRY_LAST -> Emitovanje poslednjeg elementa ili errora koji zadovoljava postavljene logike uz obavezno postavljnje logike zavrsetka emitovanja:
//            .tryLast(where: { number in
//                if number == 3 {
//                    throw URLError(.badURL)
//                }
//                return number > 4
//            })
            // TODO: -> Rezultat je bacanje errora, jer je logika postavljna tako da se return nikad nece izvrsiti
        
            // 7)
            // MARK: - DROP_FIRST -> Emitovanje svega osim prvog elementa
//            .dropFirst()
            // TODO: -> Rezultat je 1,2,3,4,5,6,7,8,9,10
        
            // 8)
            // MARK: - DROP_FIRST(N) -> Emitovanje svega osim prvih N elementa
//            .dropFirst(3)
            // TODO: -> Rezultat je 3,4,5,6,7,8,9,10
        
            // 9)
            // MARK: - DROP_WHILE -> Emitovanje svega osim PRVIH nekoliko elemenata koji ne ispunjavaju postavljenu logiku
//            .drop(while: { $0 < 5 })
            // TODO: -> Rezultat za { $0 < 5 } 5,6,7,8,9,10
            // TODO: -> Rezultat za { $0 > 5 } 0,1,2,3,4,5,6,7,8,9,10 i ovaj rezulat je cudan na prvi pogled jer se cini da bi trebalo da rezultat bude 0,1,2,3,4 a ne sve. To je zato sto se DROP pipeline-ovi uvek odnose na prve elemente emitovanja, a kako je sa { $0 > 5 } ovakvim uslovom u stvari izbegnuto da se prvi elementi izostave i to elementi 0,1,2,3,4, dalje se emitovanje nastavlja na 5,6,7,8,9,10 jer to vise nisu prvi elementi
            // TODO: -> dropWhile je bolje korisiti za izostavljanje prvog dela nekog odrredjenog  emitovanja, tj za { $0 < 5 } ovakve slucajeve
        
            // 10)
            // MARK: - TRY_DROP -> Emitovanje errora ili svega osim PRVIH nekoliko elemenata koji ne ispunjavaju postavljenu logiku
//            .tryDrop(while: { number in
//                if number == 9 {
//                    throw URLError(.badServerResponse)
//                }
//                return number < 6
//            })
            // TODO: -> Rezultat je 6,7,8,9,10
        
            // 11)
            // MARK: - PREFIX -> Emitovanje prvih N elemenata
//            .prefix(4)
            // TODO: -> Rezultat je 0,1,2,3
        
            // 12)
            // MARK: - PREFIX_WHILE -> Emitovanje prvih N elemenata dok se ne ispuni zadati uslov
//            .prefix(while: { $0 < 5 })
            // TODO: -> Rezultat je 0,1,2,3,4
            // TODO: -> Za .prefix(while: { $0 > 5 }) nece se emitovati nista jer je postavljen uslov odmah ispunjen
        
            // 13)
            // MARK: - TRY_PREFIX -> Emitovanje Errora ili prvih N elemenata dok se ne ispuni zadati uslov
//            .tryPrefix(while: { number in
//                if number == 9 {
//                    throw URLError(.badServerResponse)
//                }
//                return number < 6
//            })
            // TODO: -> Rezultat je 0,1,2,3,4,5
        
            // 14)
            // MARK: - OUTPUT_AT -> Emitovanje elementa na odredjenom indexnom mestu
//            .output(at: 2)
            // TODO: -> Rezultat je 2
        
            // 15)
            // MARK: - OUTPUT_IN -> Emitovanje elemenata na odredjenom indexnom intervalu ili Range-u
//            .output(in: 2..<4)
            // TODO: -> Rezultat je 2,3
        
        // MARK: - II) MATHEMATICS OPERATIONS:
        
            // 1)
            // MARK: - MAX -> Emitovanje maksimalne vrednosti, ali je dobijanje ove vrednosti uslovljeno postavljanjem zavrsetka emitovanja isto kao kod .last() pipeline-a
//            .max()
            // TODO: -> Rezultat je 10
        
            // 2)
            // MARK: - MAX_BY -> Emitovanje prve maksimalne vrednosti koja zadovolji ovaj uslov
//            .max(by: { $0 < $1 })
            // TODO: -> Rezultat je 10
            // TODO: -> .max(by: { $0 > $1 }) za ovo bi rezulktat bio 0
            // TODO: -> Da je npr niz izgledao ovako [1,4,7,23,5,45] rezultat bi bio 45
            // TODO: -> Da je npr niz izgledao ovako [1,4,7,23,5,15] rezultat bi bio 23
        
            // 3)
            // MARK: - MIN -> Emitovanje minimalnih vrednosti po istoj logici kao i emitovanje maksimalnih vrednosti, dakle potrebno je da se postavi zavrsetak emitovanja na publisher, sve ostalo je isto
//            .min()
//            .min(by: { $0 < $1 }) // TODO: -> Rezultat 0
//            .min(by: { $0 > $1 }) // TODO: -> Rezultat 10
//            .tryMin(by: {         // TODO: -> Rezultat error
//                if $0 == 5 {
//                    throw URLError(.badURL)
//                }
//                return $0 < $1
//            })
        
        // MARK: - III) MAPPING OPERATIONS:
        
            // 1)
            // MARK: - MAP -> Mapiranje
//            .map({ String($0) })
            // TODO: -> Rezultat je pretvoren Int u String
        
            // 2)
            // MARK: - TRY_MAP -> Mapiranje sa mogucnoscu bacanja error-a, ali kad se dobije error, stream se zaustavlja i ne publisher se vise ne slusa
//            .tryMap({ number in
//                if number == 5 {
//                    throw URLError(.badURL)
//                }
//                return String(number)
//            })
            // TODO: -> Rezultat je 0,1,2,3,4,Error
        
            // 3)
            // MARK: - COMPACT_MAP -> Mapiranje sa preskakanjem nezeljene vrednosti ili nil-a tako da se stream nastavlja
//            .compactMap({ number in
//                if number == 5 {
//                    return nil
//                }
//                return String(number)
//            })
            // TODO: -> Rezultat je 0,1,2,3,4,_,6,7,8,9,10
        
            // 4)
            // MARK: - TRY_COMPACT_MAP -> Mapiranje sa preskakanjem nezeljene vrednosti ili nil-a i sa mogucnoscu bacanja error-a, ali kad se dobije error, stream se zaustavlja i ne publisher se vise ne slusa
//            .tryCompactMap({ number in
//                if number == 5 {
//                    throw URLError(.badURL)
//                }
//                return String(number)
//            })
            // TODO: -> Rezultat je 0,1,2,3,4,Error
        
            // 5)
            // MARK: - SWITCH TO LATEST -> Pomocu switchToLatest() koristimo value iz AnyPublishera
//            .map({ number -> AnyPublisher<String, Never> in
//                return CurrentValueSubject<String, Never>(String(number))
//                    .eraseToAnyPublisher()
//            })
//            .switchToLatest()
            // TODO: - Zakomentaristi map koji se na dnu koristi i rezultat je isti kao sa njim
        
            // 6)
            // MARK: - FLAT MAP -> Pravi novi publisher, moze da bude i razlicitog tipa od polaznog publishera
//            .flatMap({
//                CurrentValueSubject<Int, Never>($0)
//            })
            // TODO: - nereaktivni .flatMap inace uravnjuje niz, pravi od matrice obican niz
        
        // MARK: - IV) FILTERING & REDUCING OPERATIONS:
        
            // 1)
            // MARK: - FILTER -> Filterovanje
//            .filter({ $0 > 3 && $0 < 7 })
            // TODO: -> Rezultat je 4,5,6
        
            // 2)
            // MARK: - TRY_FILTER -> Filterovanje sa bacanjem Errora
//            .tryFilter({
//                if $0 == 6 { throw URLError(.badServerResponse) }
//                return $0 > 3 && $0 < 7
//            })
            // TODO: -> Rezultat je 4,5,Error
        
        
        // MARK: - V) REPLACING AND REMOVING OPERATIONS:
            
            // 1)
            // MARK: - REMOVE_DUPLICATES -> Uklanjanje susednih duplikata
//            .removeDuplicates()
            // TODO: -> Npr niz [1,2,3,3,4,5] daje Rezultat 1,2,3,4,5
            // TODO: -> Npr niz [1,2,3,3,4,3,5] daje Rezultat 1,2,3,4,3,5
        
            // 2)
            // MARK: - REPLACE_NIL -> Zamena nil vrednosti is stream-a npr nekom default-nom vrednoscu
//            .replaceNil(with: 100)
            // TODO: -> Npr niz [1,2,nil,3,4,5] daje Rezultat 1,2,100,3,4,5
        
            // 3)
            // MARK: - REPLACE_EMPTY -> Zamena praznih vrednosti is stream-a npr nekom default-nom
//            .replaceEmpty(with: 100)
            // TODO: -> Npr prazan niz menjamo default-nom vrednoscu -> [[1,2],[],[3,4,5]] daje Rezultat [[1,2],[100],[3,4,5]]
        
            // 4)
            // MARK: - REPLACE_ERROR -> Zamena error-a iz stream-a npr nekom default-nom, npr kombinacijom sa nekim tryMap ili tryBiloSta
//                .replaceError(with: "VUK")
            // TODO: -> Rezultat za tryMap + replaceError je 0,1,2,3,4,VUK
        
        // MARK: - VI) SCANING & REDUCING OPERATIONS:
        
            // 1)
            // MARK: - SCAN -> skeniranje svih emitovanih vrednosti i pravljenje njihovog kumulativa u svakom sledecem emitovanju
//            .scan(5, { existingValue, newValue in
//                return existingValue + newValue
//            })
            // ISTO STO I:
//            .scan(0, { $0 + $1}) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            // ISTO STO I NAJKRACE:
//            .scan(0, +) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            // TODO: -> Rezultat je 5,6,8,11,15,20,26,32,41,50,60
            // TODO: -> Niz koji se emituje je [0,1,2,3,4,5,6,7,8,9,10]
            // TODO: -> Dakle 0 je zamenjena sa 5, pa je onda 5 + 1 = 6, pa 6 + 2 = 8, pa je 8 + 3 = 11 itd
            // TODO: -> .scan pocinje sa zadatom default-nom vrednoscu, koja se setovana na 5, a mogla je da bude i 0 da se slaze sa inicijalnim nizom ili u nekim drugim slucajevima npr nil i sl.
        
            // 2)
            // MARK: - REDUCE -> To je isto sto i SCAN, samo sto se od svih emitovanih vrednosti i pravi jedna konacna vrednost kao kumulativ svih vrednosti, npr suma svega, i dobija se samo jedno emitovanje
//            .reduce(5, { existingValue, newValue in
//                return existingValue + newValue
//            })
            // TODO: -> Rezultat je 60
        
        // MARK: - VII) COLLECTING OPERATIONS:
        
            // 1)
            // MARK: - COLLECT -> Od pojedinacnih emitovanja pravi niz tako sto ih sve sakuplja i pravi jednu objavu. Takodje mu je potrebno da i kod .last() ili .max() da zna kad se emitovanje zavrsava da bi bio implementiran. Zgodno je kad imamo vise emitera cije vrednosti treba pokupiti i staviti u jedno emitovanje
//            .map({ String($0) }) // TODO: potrebno u ovom primeru
//            .collect()
            // TODO: Rezultat je 0,1,2,3,4,5,6,7,8,9,10
        
            // 2)
            // MARK: - COLLECT(N)
//            .map({ String($0) }) // TODO: potrebno u ovom primeru
//            .collect(3)
            // TODO: Rezultat je 0,1,2,  3,4,5,   6,7,8,  9,10
            // TODO: Dakle nece biti jedno emitovanje vec serija emitovanja kad popuni zadat broj skupljanja, zato prvo emituje 0,1,2 pa kad skupi sledeca 3 bice 3,4,5 itd
            // TODO: Fakticki .collect(3) pravi svaki put novi niz od najmanje 3 elementa i to emituje
        
            // 3)
            // MARK: - ALL SATISFY -> potrebno je da zna kad je kraj emitovanja
//            .allSatisfy({ $0 < 50 })
            // TODO: Rezultat je TRUE, jer je svaki od elemenata niza zaista manji od 50, dakle jedno emitovanje na .allSatisfy ide
            // TODO: .allSatisfy({ $0 > 5 }) Rezultat je FALSE
        
            // 4)
            // MARK: - TRY ALL SATISFY -> sa mogucnoscu bacanja Errora, takodje je potrebno da zna kad je kraj emitovanja
//            .tryAllSatisfy({ $0 < 50 })
            // TODO: Rezultat je TRUE
        
        // MARK: - VIII) TIMING OPERATIONS:
        
            // 1)
            // MARK: - DEBOUNCE -> narocito se koristi kod TextField-a kad treba napraviti vremenski razmak u kom se osluskuje rezultat korisnikovog upisa
//            .debounce(for: 1, scheduler: DispatchQueue.main)
            // TODO: Da samo imali emitovanje na 0.5 sekundi, ovo bi osluskivalo svaku sekundu i to znaci da bi se slusalo svako drugo emitovanje
        
            // 2)
            // MARK: - DELAY -> odlazemo slusanje stream-a za zadato vreme
//            .delay(for: 2, scheduler: DispatchQueue.main)
            // TODO: Rezultat je 0,1,2,3,4,5,6,7,8,9,10 ali ceo stream je odlozen za 2 selunde
        
            // 3)
            // MARK: - MEASURE INTERVAL
//            .measureInterval(using: DispatchQueue.main)
//            .map({ stride in   // TODO: potrebno u ovom primeru
//                "\(stride.timeInterval))"
//            })
            // TODO: Ovo daje interval koji prodje izmedju svakog emitovanja, koristi se nekad za debuging
        
            // 4)
            // MARK: - THROTTLE
//            .throttle(for: 5, scheduler: DispatchQueue.main, latest: true)
            // TODO: Rezultat je 0,5,10
            // TODO: Stream otvara na 5 sekundi i uzima ili poslednje emitovanje u tom intervalu ili prvo emitovanje u tom intervalu u zavisnosti da li je LATEST postavljeno true ili false
        
            // 5)
            // MARK: - RETRY
//            .retry(3)
            // TODO: Probaj 3 puta pre nego sto uskocis u error, dakle dobro je da se kombinuje sa nekim tryMap ili slicno kao npr kod nekih API poziva koje je sad tesko primerom obraditi
        
            // 6)
            // MARK: - TIMEOUT
//            .timeout(0.75, scheduler: DispatchQueue.main)
            // TODO: Rezultat je 0, zato sto je emitovanje podeseno na sekundu, zatim dve, pa tri, odnsnosno da prati indeksno mesto niza, a svako to vreme emitovanje je manje od postavljenih 0.75 i ukoliko se novo emitovanje ne desi u roku od 0.75 prestaje se sa slusanjem emitera
        
        // MARK: - IX) MULTIPLE PUBLISHERS & SUBSCRIBERS:
        
            // 1)
            // MARK: - COMBINE LATEST -> slusa promenu svih naznacenih publishera. Potrebno je da svi publisheri koji se slusaju imaju barem pocetnu vrednost da bi ovaj pipeline radio. Kad su svi publisheri koji se slusaju dobili pocetnu vrednost i kad je pocelo slusanje pipeline-a onda se slusanje obavlja na promenu bilo kog publisher-a, dakle samo za pocetak slusanja je potrebno da su svi dobili pocetnu vrednost
//            .combineLatest(service.boolPublisher)
            /// ILI
///            .compactMap({ numValue, boolValue in
///                if boolValue {
///                    return String(numValue)
///                }
///                return nil
///            })
//            .compactMap({ $1 ? String($0) : nil })
            // TODO: - Rezultat je 5,6,6,7,7,8
            // TODO: - Ovakav rezultat se dobija jer se u petlji tokom jednog prolaza emituje prvo jedan publisher, a odmah zatim i drugi publisher. Posto se koristi COMBINE_LATEST prakticno postoje dva slusanja po prolazu kroz petlju i otuda duplirane 6-ice i 7-ice prema uslovu koji je postavljen.
            // TODO: - Zbog svega toga je ovde zgodno iskoristiti REMOVE_DUPLICATES
//            .removeDuplicates()
            // TODO: - Rezultat je 5,6,7,8
        
            // 2)
            // MARK: - COMBINE LATEST -> PRIMER SA VISE OD DVA PUBLISHERA
//            .combineLatest(service.boolPublisher, service.intPublisher)
//            .compactMap({ (int1, bool, int2) in
//                if bool {
//                    return String(int1)
//                }
//                return nil
//            })
            // TODO: - Rezultat je 6,7,7,8 jer se sad ceka da sva tri publishera dobiju pocetnu vrednost, posle toga se pipeline slusa na promenu bilo kog od ova tri publishera
        
            // 3)
            // MARK: - MERGE -> Slusa se vise publishera ISTOG TIPA i njihovo emitovanje se sjedinjava
//            .merge(with: service.intPublisher)
            // TODO: Rezultat je 0,1,2,3,4,5,6,999,7,8,9,10
        
            // 4)
            // MARK: - ZIP -> Pravi tuple od vise publisher-a ali broj elemenata koji ce se emitovati odgovara broju emitovanja publishera sa najmanjem brojem emitovanja
//            .zip(service.intPublisher, service.boolPublisher)
//            .map({ String($0.0) + String($0.1) + $0.2.description })
            // TODO: Rezultat je 0999false, dakle samo jedno slusanje prolazi
        
            // 5)
            // MARK: - CATCH -> Hvata error i pretvara ga u publisher
//            .tryMap({ _ in throw URLError(.badServerResponse) })
//            .catch({ error in
//                return self.service.intPublisher
//            })
            // TODO: Rezultat je 999
        
        
            
        
            .map({ String($0) })
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] returnedValue in
                self?.data.append(returnedValue)
            }
            .store(in: &cancellables)
        
            // 6)
            // MARK: - SHARE -> Kad se isti publisher koristi za dve potpuno razlicite opcije slusanja, onda ne bi bilo pametno da se koristi jedan te isti izvorni publisher vec bi trebalo oznaciti da ce se taj publisher slusati na vise mesta
      
//        let sharedPublisher = service.passthroughPublisher
//            .dropFirst(3) // TODO: pokazianje da mogu da postoje manipulacije na ovom shareovanom publisheru
//            .share()
        
            // 7)
            // MARK: - MULTICAST -> Ovim se prakticno pravi novi publisher koji postaje CONNECTABLE, a to znaci da se automatski emitovati dogadjaje kao sto publisheri inace rade. Verovatno da bi se multicastom moglo izbeci dupliranje slusanja za dve potrebe koje imamo dole i sa share varijantom, ali to treba istraziti.
        
//        let sharedPublisher = service.passthroughPublisher
//            .share() // TODO: - Ovo jer ga koristimo na vise mesta
/////            .multicast {
/////                PassthroughSubject<Int, Error>()
/////            }
//        ///  ILI
//            .multicast(subject: multicastPublisher)
//        
//        // MARK: - Pomocu .connect() mogu da kazem kad publisher pocinje da se slusa i to hocu npr da bude posle 5 sekundi od starta ekrana
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            sharedPublisher
//                .connect()
//                .store(in: &self.cancellables)
//        }
        
         /*
        sharedPublisher
            .map({ String($0) })
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] returnedValue in
                self?.data.append(returnedValue)
            }
            .store(in: &cancellables)
        
        sharedPublisher
            .map({ ($0 > 5) ? true : false })
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] returnedValue in
                self?.dataBools.append(returnedValue)
            }
            .store(in: &cancellables)
          */
        
    }
}

struct Publishers___Subscribers: View {
    
    @StateObject var viewModel = AdvancedCombineViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
                VStack {
                    ForEach(viewModel.data, id: \.self) { item in
                        Text(item)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    
                    if !viewModel.error.isEmpty {
                        Text(viewModel.error)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    
                }
                
                VStack {
                    ForEach(viewModel.dataBools, id: \.self) { item in
                        Text(String(item))
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    
                    if !viewModel.error.isEmpty {
                        Text(viewModel.error)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    Publishers___Subscribers()
}
