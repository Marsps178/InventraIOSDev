import Foundation
import Observation

@Observable
class DispatchesListViewModel {
    var dispatches: [Dispatch] = []
    var pagination: Pagination?
    var isLoading: Bool = false
    var errorMessage: String?
    var selectedEstado: String? = "EN_TRANSITO" // Por defecto, mostrar en tránsito
    
    func fetchDispatches(page: Int = 1) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await DispatchService.shared.fetchDispatches(
                page: page,
                estado: selectedEstado
            )
            self.dispatches = result.dispatches
            self.pagination = result.pagination
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error desconocido"
        }
        
        isLoading = false
    }
}
