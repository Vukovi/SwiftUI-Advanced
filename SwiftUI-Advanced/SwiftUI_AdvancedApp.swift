//
//  SwiftUI_AdvancedApp.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 14.11.23.
//

import SwiftUI

@main
struct SwiftUI_AdvancedApp: App {
    let persistenceController = PersistenceController.shared
    
    let currentUserSignedIn: Bool
    init() {
        let userSignedIn: Bool = CommandLine.arguments.contains("-UITest_startSignedIn") ? true : false
        self.currentUserSignedIn = userSignedIn
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
