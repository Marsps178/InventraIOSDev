import Foundation

// MARK: - Validation Rules

enum ValidationRule {
    case required(fieldName: String)
    case email
    case minLength(Int)
    case maxLength(Int)
    case pattern(String)  // Regex pattern
    case custom((String) -> Bool)
    
    func validate(_ value: String) -> ValidationError? {
        switch self {
        case .required(let fieldName):
            return value.trimmingCharacters(in: .whitespaces).isEmpty
                ? ValidationError(field: fieldName, message: "\(fieldName) es obligatorio")
                : nil
            
        case .email:
            let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let predicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
            return !predicate.evaluate(with: value)
                ? ValidationError(field: "email", message: "Email inválido")
                : nil
            
        case .minLength(let minChars):
            return value.count < minChars
                ? ValidationError(field: "", message: "Mínimo \(minChars) caracteres")
                : nil
            
        case .maxLength(let maxChars):
            return value.count > maxChars
                ? ValidationError(field: "", message: "Máximo \(maxChars) caracteres")
                : nil
            
        case .pattern(let pattern):
            let regex = try? NSRegularExpression(pattern: pattern)
            let range = NSRange(value.startIndex..., in: value)
            let match = regex?.firstMatch(in: value, range: range) != nil
            return !match
                ? ValidationError(field: "", message: "Formato inválido")
                : nil
            
        case .custom(let closure):
            return !closure(value)
                ? ValidationError(field: "", message: "Validación fallida")
                : nil
        }
    }
}

// MARK: - Validation Error

struct ValidationError: Identifiable {
    let id = UUID()
    let field: String
    let message: String
}

// MARK: - Form Validator

class FormValidator {
    private var rules: [String: [ValidationRule]] = [:]
    
    // MARK: - Configuration
    
    func addRule(_ rule: ValidationRule, for field: String) {
        if rules[field] == nil {
            rules[field] = []
        }
        rules[field]?.append(rule)
    }
    
    // MARK: - Validation
    
    func validate(field: String, value: String) -> [ValidationError] {
        guard let fieldRules = rules[field] else { return [] }
        
        var errors: [ValidationError] = []
        for rule in fieldRules {
            if let error = rule.validate(value) {
                errors.append(ValidationError(field: field, message: error.message))
                break  // Solo mostrar primer error por campo
            }
        }
        return errors
    }
    
    func validateAll(fields: [String: String]) -> [ValidationError] {
        var allErrors: [ValidationError] = []
        
        for (field, value) in fields {
            allErrors.append(contentsOf: validate(field: field, value: value))
        }
        
        return allErrors
    }
    
    func hasErrors(for field: String, value: String) -> Bool {
        return !validate(field: field, value: value).isEmpty
    }
}

// MARK: - Preset Validators

extension FormValidator {
    static func loginValidator() -> FormValidator {
        let validator = FormValidator()
        
        // Username/Email field
        validator.addRule(.required(fieldName: "Usuario"), for: "username")
        validator.addRule(.minLength(3), for: "username")
        
        // Password field
        validator.addRule(.required(fieldName: "Contraseña"), for: "password")
        validator.addRule(.minLength(6), for: "password")
        
        return validator
    }
    
    static func requirementValidator() -> FormValidator {
        let validator = FormValidator()
        
        validator.addRule(.required(fieldName: "Código"), for: "codigo")
        validator.addRule(.required(fieldName: "Cantidad"), for: "cantidad")
        validator.addRule(.required(fieldName: "Descripción"), for: "descripcion")
        
        return validator
    }
    
    static func dispatchValidator() -> FormValidator {
        let validator = FormValidator()
        
        validator.addRule(.required(fieldName: "Comentarios"), for: "comments")
        validator.addRule(.minLength(5), for: "comments")
        
        return validator
    }
}
