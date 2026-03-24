import Foundation

class APIClient {
    static let shared = APIClient()
    
    private let baseURL: String
    private let session: URLSession
    
    init(baseURL: String = "http://tu-dominio/api", session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: - Generic Request
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        body: Encodable? = nil,
        token: String? = nil
    ) async throws -> T {
        guard var urlComponents = URLComponents(string: baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        
        urlComponents.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpError(statusCode: httpResponse.statusCode, message: "Error en la solicitud")
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedResponse = try decoder.decode(APIResponse<T>.self, from: data)
            
            if let decodedData = decodedResponse.data {
                return decodedData
            } else {
                throw APIError.serverError
            }
        } catch let error as APIError {
            throw error
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // Para respuestas paginadas
    func requestPaginated<T: Decodable>(
        endpoint: APIEndpoint,
        token: String? = nil
    ) async throws -> (data: [T], pagination: Pagination) {
        let response: PaginatedData<T> = try await request(endpoint: endpoint, token: token)
        return (data: response.data, pagination: response.pagination)
    }
}
