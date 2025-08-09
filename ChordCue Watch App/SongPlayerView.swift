import SwiftUI

struct SongPlayerView: View {
    let song: Song
    @State private var index = 0
    @State private var timer: Timer?
    private var totalSteps: Int { song.chords.count * song.repeatCount }

    var body: some View {
        VStack {
            Text(song.chords[index % song.chords.count].diagram)
                .font(.title)
            if index + 1 < totalSteps {
                Text("Next: \(song.chords[(index + 1) % song.chords.count].name)")
                    .font(.footnote)
                    .padding(.top, 4)
            }
        }
        .onAppear(perform: start)
        .onDisappear { timer?.invalidate() }
    }

    func start() {
        timer?.invalidate()
        index = 0
        guard song.tempo > 0, totalSteps > 0 else { return }
        let interval = 60.0 / song.tempo
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if index + 1 < totalSteps {
                index += 1
            } else {
                timer?.invalidate()
            }
        }
    }
}
