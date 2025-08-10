//
//  ChordCueApp.swift
//  ChordCue
//
//  Created by Aleksandr Khrebtov on 03/08/2025.
//

import SwiftUI

@main
struct ChordCueApp: App {
    init() {
        WatchSessionManager.shared.start()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
