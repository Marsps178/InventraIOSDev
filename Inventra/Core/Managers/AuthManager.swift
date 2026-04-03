import Foundation
import Observation

@Observable
class AuthManager {
    static let shared = AuthManager()

    var isAuthenticated: Bool {
        TokenManager.shared.accessToken != nil
    }

    var currentUser: User?

    private init() {}

    // MARK: - Login
    // POST /auth/login — respuesta directa SIN wrapper { status, data }
    // Devuelve: { accessToken, refreshToken, user: { id, username, nombre, rol } }
    func login(username: String, password: String) async throws {
        let loginRequest = LoginRequest(username: username, password: password)

        // Usar requestDirect porque auth/login NO tiene wrapper { status, data }
        let response: AuthResponse = try await APIClient.shared.requestDirect(
            endpoint: .login,
            body: loginRequest
        )

        TokenManager.shared.saveTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )

        self.currentUser = response.user
    }

    // MARK: - Refresh Token
    // POST /auth/refresh — respuesta directa: { accessToken }  (sin user ni refreshToken)
    func refreshAccessToken() async throws {
        guard let refreshToken = TokenManager.shared.refreshToken else {
            throw APIError.unauthorized
        }

        let refreshRequest = RefreshTokenRequest(refreshToken: refreshToken)

        // Usar RefreshTokenResponse (solo accessToken) con requestDirect
        let response: RefreshTokenResponse = try await APIClient.shared.requestDirect(
            endpoint: .refreshToken,
            body: refreshRequest
        )

        // Actualizar solo el access token; mantener el refresh token existente
        TokenManager.shared.saveTokens(
            accessToken: response.accessToken,
            refreshToken: refreshToken          // conservar el refresh token actual
        )
    }

    // MARK: - Get User Profile
    // GET /auth/me — respuesta envuelta: { status, data: { ... } }
    func fetchUserProfile() async throws {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        // /auth/me sí usa wrapper { status, data } — usar request() normal
        let user: User = try await APIClient.shared.request(
            endpoint: .getUserProfile,
            token: token
        )

        self.currentUser = user
    }

    // MARK: - Logout
    func logout() {
        TokenManager.shared.deleteTokens()
        self.currentUser = nil
    }
}
