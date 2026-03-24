import Foundation
import Observation

@Observable
class LoginViewModel {
    var username: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await AuthService.shared.login(username: username, password: password)
            try await AuthService.shared.fetchUserProfile()
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error desconocido"
        }
        
        isLoading = false
    }
}
