import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    private let session = WCSession.default
    private weak var store: SongStore?

    override private init() {
        super.init()
    }

    func start(store: SongStore) {
        self.store = store
        guard WCSession.isSupported() else { return }
        session.delegate = self
        session.activate()
    }

    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let data = applicationContext["songs"] as? Data,
              let decoded = try? JSONDecoder().decode([Song].self, from: data) else { return }
        DispatchQueue.main.async {
            self.store?.updateSongs(decoded)
        }
    }
}

