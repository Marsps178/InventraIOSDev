import Foundation
import Observation

@Observable
class LoginViewModel {
    var username: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    
    // TIER 1 #3: Form Validation
    var usernameError: String?
    var passwordError: String?
    
    private let validator = FormValidator.loginValidator()
    
    // MARK: - Validation Methods
    
    func validateUsername() {
        let errors = validator.validate(field: "username", value: username)
        usernameError = errors.first?.message
    }
    
    func validatePassword() {
        let errors = validator.validate(field: "password", value: password)
        passwordError = errors.first?.message
    }
    
    var isFormValid: Bool {
        let usernameErrors = validator.validate(field: "username", value: username)
        let passwordErrors = validator.validate(field: "password", value: password)
        return usernameErrors.isEmpty && passwordErrors.isEmpty
    }
    
    // MARK: - Login
    
    func login() async {
        // TIER 1 #3: Validate before submit
        validateUsername()
        validatePassword()
        
        guard isFormValid else {
            Logger.log("Formulario inválido, bloqueando login", level: .warning)
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await AuthService.shared.login(username: username, password: password)
            try await AuthService.shared.fetchUserProfile()
            Logger.log("Login exitoso para usuario: \(username)", level: .info)
        } catch let error as APIError {
            errorMessage = error.localizedDescription
            Logger.log("Error en login: \(error.localizedDescription)", level: .error)
        } catch {
            errorMessage = "Error desconocido"
            Logger.log("Error desconocido en login: \(error)", level: .error)
        }
        
        isLoading = false
    }
}
