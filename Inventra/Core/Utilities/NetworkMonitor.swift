import Foundation
import Network
import Observation

@Observable
class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    var isConnected: Bool = true
    var isExpensive: Bool = false  // Datos móviles
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let wasConnected = self?.isConnected ?? true
                self?.isConnected = path.status == .satisfied
                self?.isExpensive = path.isExpensive
                
                // Log cambios de estado
                if wasConnected != (path.status == .satisfied) {
                    Logger.log(
                        "Network: \(path.status == .satisfied ? "✅ CONNECTED" : "❌ OFFLINE")",
                        level: .info
                    )
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
