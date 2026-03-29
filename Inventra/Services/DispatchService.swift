import Foundation

class DispatchService {
    static let shared = DispatchService()

    private init() {}

    // GET /despachos — respuesta: { status, data: { data: [...], pagination } }
    // (normalizado en backend)
    func fetchDispatches(
        page: Int = 1,
        limit: Int = 20,
        estado: String? = nil,
        idMina: Int? = nil
    ) async throws -> (dispatches: [Dispatch], pagination: Pagination) {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        let result: (data: [Dispatch], pagination: Pagination) = try await APIClient.shared.requestPaginated(
            endpoint: .getDispatches(page: page, limit: limit, estado: estado, idMina: idMina),
            token: token
        )
        return (dispatches: result.data, pagination: result.pagination)
    }

    // GET /despachos/:id — respuesta: { status, data: { ... } }
    func fetchDispatchDetail(id: Int) async throws -> DispatchDetail {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        return try await APIClient.shared.request(
            endpoint: .getDispatch(id: id),
            token: token
        )
    }

    // PATCH /despachos/:id/transito
    func markAsInTransit(id: Int, fechaSalida: String? = nil) async throws -> DispatchDetail {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        let body = DispatchTransitRequest(fechaSalida: fechaSalida)
        return try await APIClient.shared.request(
            endpoint: .markDispatchInTransit(id: id),
            body: body,
            token: token
        )
    }

    // PATCH /despachos/:id/entregar
    func markAsDelivered(id: Int, fechaEntrega: String? = nil) async throws -> DispatchDetail {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        let body = DispatchDeliveryRequest(fechaEntrega: fechaEntrega)
        return try await APIClient.shared.request(
            endpoint: .markDispatchDelivered(id: id),
            body: body,
            token: token
        )
    }

    // PATCH /despachos/:id/anular
    func cancelDispatch(id: Int, motivo: String) async throws -> DispatchDetail {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }

        let body = AnularDespachoRequest(motivo_anulacion: motivo)
        return try await APIClient.shared.request(
            endpoint: .cancelDispatch(id: id),
            body: body,
            token: token
        )
    }
}
