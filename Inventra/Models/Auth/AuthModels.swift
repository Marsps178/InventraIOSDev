import Foundation

struct LoginRequest: Encodable {
    let username: String
    let password: String
}

struct RefreshTokenRequest: Encodable {
    let refreshToken: String
}

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case user
    }
}

struct User: Decodable, Identifiable {
    let id_usuario: Int
    let username: String
    let rol: String // ADMIN, SUPERVISOR, MINA, LOGISTICA
    let id_mina: Int?
    let nombre: String
    let apellidos: String
    
    var id: Int { id_usuario }
    
    var fullName: String {
        "\(nombre) \(apellidos)"
    }
}
