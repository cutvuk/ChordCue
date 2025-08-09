//
//  ContentView.swift
//  ChordCue
//
//  Created by Aleksandr Khrebtov on 03/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = SongStore()

    var body: some View {
        TabView {
            SongListView(store: store)
                .tabItem {
                    Label("Songs", systemImage: "music.note.list")
                }
            ChordListView(store: store)
                .tabItem {
                    Label("Chords", systemImage: "list.bullet")
                }
        }
    }
}

struct SongListView: View {
    @ObservedObject var store: SongStore
    @State private var title = ""
    @State private var tempo = ""
    @State private var repeatCount = ""
    @State private var sequence: [Chord] = []

    var body: some View {
        NavigationView {
            List {
                Section("Songs") {
                    ForEach(store.songs) { song in
                        VStack(alignment: .leading) {
                            Text(song.title).font(.headline)
                            Text(song.chords.map { $0.name }.joined(separator: " "))
                                .font(.caption)
                        }
                    }
                }
                Section("Add Song") {
                    TextField("Title", text: $title)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(store.chords) { chord in
                                Button(chord.name) {
                                    sequence.append(chord)
                                }
                                .padding(4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                            }
                        }
                    }
                    if !sequence.isEmpty {
                        Text("Sequence: " + sequence.map { $0.name }.joined(separator: " "))
                            .font(.caption)
                    }
                    TextField("Repeat Count", text: $repeatCount)
                        .keyboardType(.numberPad)
                    TextField("Tempo BPM", text: $tempo)
                        .keyboardType(.decimalPad)
                    Button("Add") {
                        if let bpm = Double(tempo), let reps = Int(repeatCount), !sequence.isEmpty {
                            store.addSong(title: title, chords: sequence, tempo: bpm, repeatCount: reps)
                            title = ""
                            tempo = ""
                            repeatCount = ""
                            sequence = []
                        }
                    }
                }
            }
            .navigationTitle("Songs")
        }
    }
}

struct ChordListView: View {
    @ObservedObject var store: SongStore
    @State private var newChord = ""

    var body: some View {
        NavigationView {
            List {
                Section("Chords") {
                    ForEach(store.chords) { chord in
                        Text(chord.name)
                    }
                }
                Section("Add Chord") {
                    TextField("Name", text: $newChord)
                    Button("Add") {
                        store.addChord(name: newChord)
                        newChord = ""
                    }
                }
            }
            .navigationTitle("Chords")
        }
    }
}

#Preview {
    ContentView()
}
