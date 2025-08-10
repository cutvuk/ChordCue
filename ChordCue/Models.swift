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
    var repeatCount: Int
}

class SongStore: ObservableObject {
    @Published var chords: [Chord] = [
        Chord(name: "C", diagram: "C"),
        Chord(name: "G", diagram: "G"),
        Chord(name: "Am", diagram: "Am"),
        Chord(name: "F", diagram: "F")
    ]
    @Published var songs: [Song] = [] {
        didSet {
            WatchSessionManager.shared.sendSongs(songs)
        }
    }

    init() {
        addSong(title: "Sample Song", chordNames: ["C", "G", "Am", "F"], tempo: 120, repeatCount: 1)
        WatchSessionManager.shared.sendSongs(songs)
    }

    func addSong(title: String, chordNames: [String], tempo: Double, repeatCount: Int) {
        let songChords = chordNames.map { name in
            chords.first(where: { $0.name == name }) ?? Chord(name: name, diagram: name)
        }
        addSong(title: title, chords: songChords, tempo: tempo, repeatCount: repeatCount)
    }

    func addSong(title: String, chords: [Chord], tempo: Double, repeatCount: Int) {
        songs.append(Song(title: title, chords: chords, tempo: tempo, repeatCount: repeatCount))
    }

    func addChord(name: String) {
        chords.append(Chord(name: name, diagram: name))
    }

    func updateSong(_ song: Song, title: String, chords: [Chord], tempo: Double, repeatCount: Int) {
        guard let index = songs.firstIndex(where: { $0.id == song.id }) else { return }
        songs[index] = Song(id: song.id, title: title, chords: chords, tempo: tempo, repeatCount: repeatCount)
    }

    func updateChord(_ chord: Chord, name: String, diagram: String? = nil) {
        guard let index = chords.firstIndex(where: { $0.id == chord.id }) else { return }
        let updated = Chord(id: chord.id, name: name, diagram: diagram ?? chord.diagram)
        chords[index] = updated
        // Update chord in all songs
        songs = songs.map { song in
            var newSong = song
            newSong.chords = song.chords.map { $0.id == chord.id ? updated : $0 }
            return newSong
        }
    }

    func deleteSong(at offsets: IndexSet) {
        songs.remove(atOffsets: offsets)
    }

    func deleteChord(at offsets: IndexSet) {
        let ids = offsets.map { chords[$0].id }
        chords.remove(atOffsets: offsets)
        for i in songs.indices {
            songs[i].chords.removeAll { ids.contains($0.id) }
        }
    }
}
