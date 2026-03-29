import Foundation

// ============================================================
// APIClient — Cliente HTTP genérico con auto-refresh de token
// ============================================================

class APIClient {
    static let shared = APIClient()

    private let baseURL: String
    private let session: URLSession
    private var isRefreshing = false
    private var refreshTask: Task<Void, Error>?

    // ⚠️ CONFIGURAR: cambiar por la IP real del servidor
    // Simulador iOS  → http://localhost:3000/api
    // Dispositivo físico → http://192.168.X.X:3000/api
    init(baseURL: String = "http://localhost:3000/api", session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    // MARK: - Request genérico (respuesta envuelta en { status, data })
    // Usado por: requerimientos, inventario
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        body: Encodable? = nil,
        token: String? = nil
    ) async throws -> T {
        do {
            return try await performRequest(endpoint: endpoint, body: body, token: token)
        } catch let error as APIError {
            if case .unauthorized = error {
                return try await handleUnauthorized(endpoint: endpoint, body: body)
            }
            throw error
        }
    }

    // MARK: - Request directo (respuesta SIN wrapper)
    // Usado por: auth/login, auth/refresh (devuelven el objeto directamente)
    func requestDirect<T: Decodable>(
        endpoint: APIEndpoint,
        body: Encodable? = nil,
        token: String? = nil
    ) async throws -> T {
        guard NetworkMonitor.shared.isConnected else {
            Logger.log("No hay conexión a internet", level: .error)
            throw APIError.networkError(URLError(.networkConnectionLost))
        }

        guard var urlComponents = URLComponents(string: baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        urlComponents.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems
        guard let url = urlComponents.url else { throw APIError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 15.0

        if let token = token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        if httpResponse.statusCode == 401 { throw APIError.unauthorized }
        guard (200...299).contains(httpResponse.statusCode) else {
            // Intentar leer mensaje de error del backend
            if let errBody = try? JSONDecoder().decode(BackendErrorResponse.self, from: data) {
                throw APIError.httpError(statusCode: httpResponse.statusCode, message: errBody.message ?? "Error en la solicitud")
            }
            throw APIError.httpError(statusCode: httpResponse.statusCode, message: "Error \(httpResponse.statusCode)")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            Logger.log("DecodingError directo: \(decodingError)", level: .error)
            throw APIError.decodingError(decodingError)
        }
    }

    // MARK: - Paginado — respuesta { data: [T], pagination: {...} } SIN wrapper { status }
    // Usado por: despachos (que no tiene wrapper status)
    func requestPaginatedDirect<T: Decodable>(
        endpoint: APIEndpoint,
        token: String? = nil
    ) async throws -> (data: [T], pagination: Pagination) {
        do {
            let response: PaginatedData<T> = try await requestDirect(endpoint: endpoint, token: token)
            return (data: response.data, pagination: response.pagination)
        } catch let error as APIError {
            if case .unauthorized = error {
                // Refresh y reintentar
                try await handleUnauthorizedRefresh()
                let newToken = TokenManager.shared.accessToken
                let response: PaginatedData<T> = try await requestDirect(endpoint: endpoint, token: newToken)
                return (data: response.data, pagination: response.pagination)
            }
            throw error
        }
    }

    // MARK: - Paginado estándar — respuesta { status, data: { data: [T], pagination } }
    // Usado por: requerimientos, inventario
    func requestPaginated<T: Decodable>(
        endpoint: APIEndpoint,
        token: String? = nil
    ) async throws -> (data: [T], pagination: Pagination) {
        let response: PaginatedData<T> = try await request(endpoint: endpoint, token: token)
        return (data: response.data, pagination: response.pagination)
    }

    // MARK: - Handle 401: Refresh automático
    private func handleUnauthorized<T: Decodable>(
        endpoint: APIEndpoint,
        body: Encodable?
    ) async throws -> T {
        Logger.log("Token expirado (401). Intentando refrescar...", level: .warning)
        try await handleUnauthorizedRefresh()
        let newToken = TokenManager.shared.accessToken
        return try await performRequest(endpoint: endpoint, body: body, token: newToken)
    }

    private func handleUnauthorizedRefresh() async throws {
        if isRefreshing {
            try await refreshTask?.value
        } else {
            isRefreshing = true
            refreshTask = Task {
                defer { self.isRefreshing = false }
                do {
                    try await AuthManager.shared.refreshAccessToken()
                    Logger.log("Token refrescado exitosamente", level: .debug)
                } catch {
                    Logger.log("Error refrescando token: \(error.localizedDescription)", level: .error)
                    AuthManager.shared.logout()
                    throw APIError.unauthorized
                }
            }
            try await refreshTask?.value
        }
    }

    // MARK: - Perform HTTP Request (con wrapper { status, data })
    private func performRequest<T: Decodable>(
        endpoint: APIEndpoint,
        body: Encodable? = nil,
        token: String? = nil
    ) async throws -> T {
        guard NetworkMonitor.shared.isConnected else {
            Logger.log("No hay conexión a internet", level: .error)
            throw APIError.networkError(URLError(.networkConnectionLost))
        }

        guard var urlComponents = URLComponents(string: baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        urlComponents.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems
        guard let url = urlComponents.url else { throw APIError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 15.0

        if let token = token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }

            if httpResponse.statusCode == 401 { throw APIError.unauthorized }

            guard (200...299).contains(httpResponse.statusCode) else {
                if let errBody = try? JSONDecoder().decode(BackendErrorResponse.self, from: data) {
                    throw APIError.httpError(statusCode: httpResponse.statusCode, message: errBody.message ?? "Error en la solicitud")
                }
                throw APIError.httpError(statusCode: httpResponse.statusCode, message: "Error \(httpResponse.statusCode)")
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            // Intentar decodificar como respuesta envuelta { status, data }
            let decodedResponse = try decoder.decode(APIResponse<T>.self, from: data)

            if let decodedData = decodedResponse.data {
                return decodedData
            } else {
                throw APIError.serverError
            }
        } catch let error as APIError {
            throw error
        } catch let error as DecodingError {
            Logger.log("DecodingError: \(error)", level: .error)
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
}

// MARK: - Backend Error Response helper
private struct BackendErrorResponse: Decodable {
    let message: String?
    let error: String?
    let status: String?
}
