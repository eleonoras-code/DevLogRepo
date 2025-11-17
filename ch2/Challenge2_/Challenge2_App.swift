//
//  Challenge2_App.swift
//  Challenge2_
//
//  Created by Eleonora Persico on 11/11/25.
//

import SwiftData
import SwiftUI

@main
struct Challenge2_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }.modelContainer(for: Win.self) // creates storage for the 'Win' object, holds all the model for the app 
    }
}
