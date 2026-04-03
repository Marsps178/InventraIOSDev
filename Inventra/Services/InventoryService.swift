import Foundation

class InventoryService {
    static let shared = InventoryService()

    private init() {}

    // GET /inventory/stock
    // Respuesta: { status, data: { data: [...], pagination } }
    // inventario.controller sí usa wrapper { status, data }
    func fetchStock(
        search: String? = nil,
        page: Int = 1,
        limit: Int = 20
    ) async throws -> (stocks: [Stock], pagination: Pagination) {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        let result: (data: [Stock], pagination: Pagination) = try await APIClient.shared.requestPaginated(
            endpoint: .getStock(search: search, page: page, limit: limit),
            token: token
        )
        return (stocks: result.data, pagination: result.pagination)
    }

    // GET /products
    // Respuesta: { status, data: { data: [...], pagination } }
    func fetchProducts(
        page: Int = 1,
        limit: Int = 50
    ) async throws -> (products: [Product], pagination: Pagination) {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        let result: (data: [Product], pagination: Pagination) = try await APIClient.shared.requestPaginated(
            endpoint: .getProducts(page: page, limit: limit),
            token: token
        )
        return (products: result.data, pagination: result.pagination)
    }

    // GET /mines
    // Respuesta: { status, data: { data: [...], pagination } }
    func fetchMines(page: Int = 1) async throws -> [Mine] {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        let result: (data: [Mine], pagination: Pagination) = try await APIClient.shared.requestPaginated(
            endpoint: .getMines,
            token: token
        )
        return result.data
    }

    // GET /supervisors
    // Respuesta: { status, data: { data: [...], pagination } }
    func fetchSupervisors() async throws -> [Supervisor] {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        let result: (data: [Supervisor], pagination: Pagination) = try await APIClient.shared.requestPaginated(
            endpoint: .getSupervisors,
            token: token
        )
        return result.data
    }

    // GET /providers
    func fetchProviders() async throws -> [Provider] {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        let result: (data: [Provider], pagination: Pagination) = try await APIClient.shared.requestPaginated(
            endpoint: .getProviders,
            token: token
        )
        return result.data
    }
}
