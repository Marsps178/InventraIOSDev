import Foundation

class TripService {
    static let shared = TripService()
    
    private init() {}
    
    func fetchTrips(
        page: Int = 1,
        estado: String? = nil
    ) async throws -> (trips: [Trip], pagination: Pagination) {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        return try await APIClient.shared.requestPaginated(
            endpoint: .getTrips(page: page, estado: estado),
            token: token
        )
    }
    
    func fetchTripDetail(id: Int) async throws -> TripDetail {
        guard let token = TokenManager.shared.accessToken else {
            throw APIError.unauthorized
        }
        
        return try await APIClient.shared.request(
            endpoint: .getTrip(id: id),
            token: token
        )
    }
}
