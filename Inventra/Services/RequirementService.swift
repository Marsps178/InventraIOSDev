import Foundation

class RequirementService {
    static let shared = RequirementService()

    private init() {}

    // GET /requirements — respuesta: { status, data: { data: [...], pagination } }
    func fetchRequirements(
        page: Int = 1,
        limit: Int = 20,
        estado: String? = nil
    ) async throws -> (requirements: [Requirement], pagination: Pagination) {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        // requerimientos SÍ tienen wrapper { status, data } → requestPaginated
        let result: (data: [Requirement], pagination: Pagination) = try await APIClient.shared.requestPaginated(
            endpoint: .getRequirements(page: page, limit: limit, estado: estado),
            token: token
        )
        return (requirements: result.data, pagination: result.pagination)
    }

    // GET /requirements/:id — respuesta: { status, data: { ... } }
    func fetchRequirementDetail(id: Int) async throws -> RequirementDetail {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        return try await APIClient.shared.request(
            endpoint: .getRequirement(id: id),
            token: token
        )
    }

    // GET /requirements/:id/progress — respuesta: { status, data: { ... } }
    func fetchRequirementProgress(id: Int) async throws -> RequirementProgress {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        return try await APIClient.shared.request(
            endpoint: .getRequirementProgress(id: id),
            token: token
        )
    }

    // POST /requirements
    func createRequirement(_ request: CreateRequirementRequest) async throws -> RequirementDetail {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        return try await APIClient.shared.request(
            endpoint: .createRequirement,
            body: request,
            token: token
        )
    }
}
