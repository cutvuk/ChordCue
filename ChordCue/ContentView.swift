//
//  ContentView.swift
//  ChordCue
//
//  Created by Aleksandr Khrebtov on 03/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = SongStore()
    @State private var title = ""
    @State private var chordString = ""
    @State private var tempo = ""

    var body: some View {
        NavigationView {
            List {
                Section("Songs") {
                    ForEach(store.songs) { song in
                        VStack(alignment: .leading) {
                            Text(song.title).font(.headline)
                            Text(song.chords.map { $0.name }.joined(separator: " ")).font(.caption)
                        }
                    }
                }

                Section("Add Song") {
                    TextField("Title", text: $title)
                    TextField("Chords (space-separated)", text: $chordString)
                    TextField("Tempo BPM", text: $tempo)
                        .keyboardType(.decimalPad)
                    Button("Add") {
                        let names = chordString.split(separator: " ").map(String.init)
                        if let bpm = Double(tempo) {
                            store.addSong(title: title, chordNames: names, tempo: bpm)
                            title = ""
                            chordString = ""
                            tempo = ""
                        }
                    }
                }
            }
            .navigationTitle("ChordCue")
        }
    }
}

#Preview {
    ContentView()
}
