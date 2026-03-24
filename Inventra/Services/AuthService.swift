import Foundation

class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    func login(username: String, password: String) async throws {
        try await AuthManager.shared.login(username: username, password: password)
    }
    
    func fetchUserProfile() async throws {
        try await AuthManager.shared.fetchUserProfile()
    }
    
    func logout() {
        AuthManager.shared.logout()
    }
    
    func refreshToken() async throws {
        try await AuthManager.shared.refreshAccessToken()
    }
}
