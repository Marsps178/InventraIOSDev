import Foundation

// MARK: - Login Request
struct LoginRequest: Encodable {
    let username: String
    let password: String
}

// MARK: - Refresh Token Request
struct RefreshTokenRequest: Encodable {
    let refreshToken: String
}

// MARK: - Auth Response (Login)
// El backend devuelve: { accessToken, refreshToken, user: { id, username, nombre, rol } }
// SIN wrapper { status, data }
struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let user: User
}

// MARK: - Refresh Token Response
// El endpoint /auth/refresh solo devuelve: { accessToken }
struct RefreshTokenResponse: Decodable {
    let accessToken: String
}

// MARK: - User
// Backend devuelve: { id, username, nombre, rol }
struct User: Decodable, Identifiable {
    let id_usuario: Int
    let username: String
    let nombreCompleto: String
    let rol: String // ADMIN, SUPERVISOR, MINA, LOGISTICA

    var id: Int { id_usuario }

    var displayName: String { nombreCompleto }

    // Mapear "id" del backend → id_usuario, y "nombre" → nombreCompleto
    enum CodingKeys: String, CodingKey {
        case id_usuario = "id"
        case username
        case nombreCompleto = "nombre"
        case rol
    }
}
