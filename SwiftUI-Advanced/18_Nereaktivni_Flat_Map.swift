//
//  PROBA.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 24.11.23.
//

import SwiftUI
import Combine

class ProbaViewModel: ObservableObject {
    
    private let matrixPublisher = PassthroughSubject<[[Int]], Never>()
    @Published var array: [Int] = []
    var cancellable: AnyCancellable?
    
    init() {
        publishData()
        addSubscribers()
    }
    
    private func publishData() {
        let matrix: [[Int]] = [
            Array((0..<Int.random(in: 1...5))),
            Array((0..<Int.random(in: 1...5))),
            Array((0..<Int.random(in: 1...5)))
        ]
        
        for index in matrix.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                self.matrixPublisher.send([matrix[index]])
            }
        }
    }
    
    private func addSubscribers() {
        cancellable = matrixPublisher
            .map { arrMatric -> [Int] in
                arrMatric.flatMap { $0 }
            }
            .sink { arr in
                self.array.append(contentsOf: arr)
            }
    }
}

struct PROBA: View {
    @StateObject var viewmodel = ProbaViewModel()
    var body: some View {
        ForEach(viewmodel.array, id: \.self) { item in
            Text(String(item))
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    PROBA()
}
