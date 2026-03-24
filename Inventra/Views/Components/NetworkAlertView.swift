import SwiftUI
import Observation

struct NetworkAlertView: View {
    @State private var networkMonitor = NetworkMonitor.shared
    
    var body: some View {
        VStack(spacing: 0) {
            if !networkMonitor.isConnected {
                HStack(spacing: 8) {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Sin conexión a internet")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.red.opacity(0.15))
                .foregroundColor(.red)
                .transition(.move(edge: .top))
            }
            
            if networkMonitor.isExpensive && networkMonitor.isConnected {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Usando datos móviles")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.orange.opacity(0.15))
                .foregroundColor(.orange)
                .transition(.move(edge: .top))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: networkMonitor.isConnected)
    }
}

#Preview {
    NetworkAlertView()
}
