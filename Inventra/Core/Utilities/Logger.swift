import Foundation

struct Logger {
    enum Level {
        case debug
        case info
        case warning
        case error
        
        var prefix: String {
            switch self {
            case .debug: return "🔍 DEBUG"
            case .info: return "ℹ️ INFO"
            case .warning: return "⚠️ WARNING"
            case .error: return "🔴 ERROR"
            }
        }
    }
    
    static func log(_ message: String, level: Level = .info, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let logMessage = "[\(timestamp)] [\(level.prefix)] [\(fileName):\(line)] \(function) → \(message)"
        print(logMessage)
        #else
        // En producción, enviar a servicio (Firebase Crashlytics, etc)
        // Crashlytics.crashlytics().record(error: ...)
        if level == .error {
            // Registrar errores con contexto
            let errorInfo: [String: Any] = [
                "message": message,
                "file": file,
                "function": function,
                "line": line
            ]
            // Analytics.logEvent("api_error", parameters: errorInfo as? [String: Any])
        }
        #endif
    }
}
