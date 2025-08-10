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
        NavigationStack {
            List(store.songs) { song in
                NavigationLink(song.title) {
                    SongPlayerView(song: song)
                }
            }
            .navigationTitle("Songs")
            .onAppear {
                WatchSessionManager.shared.start(store: store)
            }
        }
    }
}

#Preview {
    ContentView()
}
