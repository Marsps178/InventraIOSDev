import Foundation

class DispatchService {
    static let shared = DispatchService()
    
    private init() {}
    
    func fetchDispatches(
        page: Int = 1,
        estado: String? = nil,
        idMina: Int? = nil
    ) async throws -> (dispatches: [Dispatch], pagination: Pagination) {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        return try await APIClient.shared.requestPaginated(
            endpoint: .getDispatches(page: page, estado: estado, idMina: idMina),
            token: token
        )
    }
    
    func fetchDispatchDetail(id: Int) async throws -> DispatchDetail {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        return try await APIClient.shared.request(
            endpoint: .getDispatch(id: id),
            token: token
        )
    }
    
    func markAsDelivered(
        id: Int,
        fechaEntrega: String,
        comentarios: String
    ) async throws -> Dispatch {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        let request = DispatchDeliveryRequest(
            fecha_entrega: fechaEntrega,
            comentarios_mina: comentarios
        )
        
        return try await APIClient.shared.request(
            endpoint: .markDispatchDelivered(id: id),
            body: request,
            token: token
        )
    }
}
