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
                        NavigationLink(destination: SongEditorView(store: store, song: song)) {
                            VStack(alignment: .leading) {
                                Text(song.title).font(.headline)
                                Text(song.chords.map { $0.name }.joined(separator: " "))
                                    .font(.caption)
                            }
                        }
                    }
                    .onDelete(perform: store.deleteSong)
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
                        NavigationLink(destination: ChordEditorView(store: store, chord: chord)) {
                            Text(chord.name)
                        }
                    }
                    .onDelete(perform: store.deleteChord)
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

struct SongEditorView: View {
    @ObservedObject var store: SongStore
    var song: Song
    @State private var title: String
    @State private var tempo: String
    @State private var repeatCount: String
    @State private var sequence: [Chord]
    @Environment(\.dismiss) private var dismiss

    init(store: SongStore, song: Song) {
        self.store = store
        self.song = song
        _title = State(initialValue: song.title)
        _tempo = State(initialValue: String(song.tempo))
        _repeatCount = State(initialValue: String(song.repeatCount))
        _sequence = State(initialValue: song.chords)
    }

    var body: some View {
        List {
            Section("Title") {
                TextField("Title", text: $title)
            }
            Section("Chords") {
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
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(sequence.enumerated()), id: \.offset) { index, chord in
                                Text(chord.name)
                                    .padding(4)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(4)
                                    .onTapGesture {
                                        sequence.remove(at: index)
                                    }
                            }
                        }
                    }
                }
            }
            Section("Settings") {
                TextField("Repeat Count", text: $repeatCount)
                    .keyboardType(.numberPad)
                TextField("Tempo BPM", text: $tempo)
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle("Edit Song")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    if let bpm = Double(tempo), let reps = Int(repeatCount), !sequence.isEmpty {
                        store.updateSong(song, title: title, chords: sequence, tempo: bpm, repeatCount: reps)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ChordEditorView: View {
    @ObservedObject var store: SongStore
    var chord: Chord
    @State private var name: String
    @State private var diagram: String
    @Environment(\.dismiss) private var dismiss

    init(store: SongStore, chord: Chord) {
        self.store = store
        self.chord = chord
        _name = State(initialValue: chord.name)
        _diagram = State(initialValue: chord.diagram)
    }

    var body: some View {
        Form {
            Section("Chord") {
                TextField("Name", text: $name)
                TextField("Diagram", text: $diagram)
            }
        }
        .navigationTitle("Edit Chord")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    store.updateChord(chord, name: name, diagram: diagram)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
