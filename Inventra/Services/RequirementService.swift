import Foundation

class RequirementService {
    static let shared = RequirementService()
    
    private init() {}
    
    func fetchRequirements(
        page: Int = 1,
        estado: String? = nil
    ) async throws -> (requirements: [Requirement], pagination: Pagination) {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        return try await APIClient.shared.requestPaginated(
            endpoint: .getRequirements(page: page, estado: estado),
            token: token
        )
    }
    
    func fetchRequirementDetail(id: Int) async throws -> RequirementDetail {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        return try await APIClient.shared.request(
            endpoint: .getRequirement(id: id),
            token: token
        )
    }
    
    func createRequirement(
        idMina: Int,
        idProveedor: Int,
        idSupervisor: Int,
        detalles: [RequirementDetailRequest]
    ) async throws -> Requirement {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        let request = CreateRequirementRequest(
            id_mina: idMina,
            id_proveedor: idProveedor,
            id_supervisor: idSupervisor,
            detalles: detalles
        )
        
        return try await APIClient.shared.request(
            endpoint: .createRequirement,
            body: request,
            token: token
        )
    }
}
