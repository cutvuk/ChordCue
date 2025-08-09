import SwiftUI
import Combine

struct Chord: Identifiable, Codable {
    var id = UUID()
    var name: String
    var diagram: String
}

struct Song: Identifiable, Codable {
    var id = UUID()
    var title: String
    var chords: [Chord]
    var tempo: Double // beats per minute
}

class SongStore: ObservableObject {
    @Published var chords: [Chord] = [
        Chord(name: "C", diagram: "C"),
        Chord(name: "G", diagram: "G"),
        Chord(name: "Am", diagram: "Am"),
        Chord(name: "F", diagram: "F")
    ]
    @Published var songs: [Song] = []

    init() {
        addSong(title: "Sample Song", chordNames: ["C", "G", "Am", "F"], tempo: 120)
    }

    func addSong(title: String, chordNames: [String], tempo: Double) {
        let songChords = chordNames.map { name in
            chords.first(where: { $0.name == name }) ?? Chord(name: name, diagram: name)
        }
        songs.append(Song(title: title, chords: songChords, tempo: tempo))
    }

    func addChord(name: String) {
        chords.append(Chord(name: name, diagram: name))
    }
}
