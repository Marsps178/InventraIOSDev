import SwiftUI

struct Badge: View {
    let status: String
    
    init(_ status: String) {
        self.status = status
    }
    
    var color: Color {
        switch status {
        case "EN_TRANSITO":
            return .orange
        case "PENDIENTE":
            return .yellow
        case "ENTREGADO", "COMPLETADO", "APROBADO":
            return .green
        case "DAÑADO":
            return .red
        default:
            return .gray
        }
    }
    
    var displayText: String {
        switch status {
        case "EN_TRANSITO":
            return "En Tránsito"
        case "PENDIENTE":
            return "Pendiente"
        case "ENTREGADO":
            return "Entregado"
        case "COMPLETADO":
            return "Completado"
        case "APROBADO":
            return "Aprobado"
        case "PARCIAL":
            return "Parcial"
        case "DAÑADO":
            return "Dañado"
        default:
            return status
        }
    }
    
    var body: some View {
        Text(displayText)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(4)
    }
}

#Preview {
    VStack(spacing: 8) {
        Badge("EN_TRANSITO")
        Badge("PENDIENTE")
        Badge("ENTREGADO")
        Badge("DAÑADO")
    }
}
