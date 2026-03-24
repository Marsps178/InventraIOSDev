import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(DecodingError)
    case httpError(statusCode: Int, message: String)
    case unauthorized
    case serverError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .networkError(let error):
            return "Error de red: \(error.localizedDescription)"
        case .decodingError:
            return "Error al procesar respuesta del servidor"
        case .httpError(let statusCode, let message):
            return "Error \(statusCode): \(message)"
        case .unauthorized:
            return "No autorizado. Por favor, inicia sesión nuevamente"
        case .serverError:
            return "Error del servidor. Intenta más tarde"
        case .unknown:
            return "Error desconocido"
        }
    }
}
