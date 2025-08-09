//
//  ContentView.swift
//  ChordCue Watch App
//
//  Created by Aleksandr Khrebtov on 03/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = SongStore()

    var body: some View {
        if let song = store.songs.first {
            SongPlayerView(song: song)
        } else {
            Text("No songs")
        }
    }
}

#Preview {
    ContentView()
}
