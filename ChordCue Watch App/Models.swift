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
    @Published var songs: [Song] = []

    func updateSongs(_ newSongs: [Song]) {
        songs = newSongs
    }
}
