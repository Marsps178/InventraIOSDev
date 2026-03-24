import Foundation

class InventoryService {
    static let shared = InventoryService()
    
    private init() {}
    
    func fetchStock(
        search: String? = nil,
        page: Int = 1
    ) async throws -> (stocks: [Stock], pagination: Pagination) {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        return try await APIClient.shared.requestPaginated(
            endpoint: .getStock(search: search, page: page),
            token: token
        )
    }
    
    func fetchProducts(page: Int = 1) async throws -> (products: [Product], pagination: Pagination) {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        return try await APIClient.shared.requestPaginated(
            endpoint: .getProducts(page: page),
            token: token
        )
    }
    
    func fetchMines() async throws -> [Mine] {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        return try await APIClient.shared.request(
            endpoint: .getMines,
            token: token
        )
    }
}
