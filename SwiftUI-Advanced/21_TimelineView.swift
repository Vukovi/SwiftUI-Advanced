//
//  21_TimelineView.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 28.11.23.
//

import SwiftUI

// MARK: - Na osnovu TimelineViewa, koji se okida non stop, mozemo da pravimo kompleksne animacije

struct TimelineViewBootcamp: View {
    
    @State private var startTime: Date = .now
    @State private var pauseAnimation: Bool = false

    var body: some View {
        VStack {
            TimelineView(.animation(minimumInterval: 1, paused: pauseAnimation)) { context in
                
                Text("\(context.date)")
                Text("\(context.date.timeIntervalSince1970)")
                
                let seconds = Calendar.current.component(.second, from: context.date)
                let seconds2 = context.date.timeIntervalSince(startTime)
                
                Text("\(seconds2)")
                
                if context.cadence == .live {
                    Text("Cadence: Live")
                } else if context.cadence == .minutes {
                    Text("Cadence: Minutes")
                } else if context.cadence == .seconds {
                    Text("Cadence: Seconds")
                }
                
                Rectangle()
                    .frame(
                        width: seconds < 10 ? 50 : seconds < 30 ? 200 : 400,
                        height: 100
                    )
                    .animation(.bouncy, value: seconds2)
                
            }
            
            Button(pauseAnimation ? "PLAY" : "PAUSE") {
                pauseAnimation.toggle()
            }
        }
    }
}

#Preview {
    TimelineViewBootcamp()
}
