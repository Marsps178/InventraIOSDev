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
        
        let result: (data: [Stock], pagination: Pagination) = try await APIClient.shared.requestPaginated(
            endpoint: .getStock(search: search, page: page),
            token: token
        )
        return (stocks: result.data, pagination: result.pagination)
    }
    
    func fetchProducts(page: Int = 1) async throws -> (products: [Product], pagination: Pagination) {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        let result: (data: [Product], pagination: Pagination) = try await APIClient.shared.requestPaginated(
            endpoint: .getProducts(page: page),
            token: token
        )
        return (products: result.data, pagination: result.pagination)
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
