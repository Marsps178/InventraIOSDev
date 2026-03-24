import Foundation
import Security

class TokenManager {
    static let shared = TokenManager()
    
    private let keychainService = "com.inventra.tokens"
    
    // MARK: - Save Tokens
    func saveTokens(accessToken: String, refreshToken: String) {
        saveToKeychain(key: "accessToken", value: accessToken)
        saveToKeychain(key: "refreshToken", value: refreshToken)
    }
    
    // MARK: - Get Access Token
    var accessToken: String? {
        getFromKeychain(key: "accessToken")
    }
    
    // MARK: - Get Refresh Token
    var refreshToken: String? {
        getFromKeychain(key: "refreshToken")
    }
    
    // MARK: - Delete Tokens (Logout)
    func deleteTokens() {
        deleteFromKeychain(key: "accessToken")
        deleteFromKeychain(key: "refreshToken")
    }
    
    // MARK: - Private Keychain Methods
    private func saveToKeychain(key: String, value: String) {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func getFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data,
           let token = String(data: data, encoding: .utf8) {
            return token
        }
        return nil
    }
    
    private func deleteFromKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
