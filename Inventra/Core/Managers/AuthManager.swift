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
    func login(username: String, password: String) async throws {
        let loginRequest = LoginRequest(username: username, password: password)
        let response: AuthResponse = try await APIClient.shared.request(
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
    func refreshAccessToken() async throws {
        guard let refreshToken = TokenManager.shared.refreshToken else {
            throw APIError.unauthorized
        }
        
        let refreshRequest = RefreshTokenRequest(refreshToken: refreshToken)
        let response: AuthResponse = try await APIClient.shared.request(
            endpoint: .refreshToken,
            body: refreshRequest
        )
        
        TokenManager.shared.saveTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
    }
    
    // MARK: - Get User Profile
    func fetchUserProfile() async throws {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
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
