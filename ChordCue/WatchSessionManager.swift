import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    private let session = WCSession.default

    override private init() {
        super.init()
    }

    func start() {
        guard WCSession.isSupported() else { return }
        session.delegate = self
        session.activate()
    }

    func sendSongs(_ songs: [Song]) {
        guard session.isPaired && session.isWatchAppInstalled else { return }
        if let data = try? JSONEncoder().encode(songs) {
            do {
                try session.updateApplicationContext(["songs": data])
            } catch {
                print("Failed to send songs: \(error)")
            }
        }
    }

    // MARK: - WCSessionDelegate
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}

