import Foundation
import Observation

@Observable
class DispatchesListViewModel {
    var dispatches: [Dispatch] = []
    var pagination: Pagination?
    var isLoading: Bool = false
    var errorMessage: String?
    // Por defecto mostrar todos los despachos activos
    var selectedEstado: String? = nil

    func fetchDispatches(page: Int = 1) async {
        isLoading = true
        errorMessage = nil

        do {
            // DispatchService.fetchDispatches ahora acepta (page, limit, estado, idMina)
            let result = try await DispatchService.shared.fetchDispatches(
                page: page,
                estado: selectedEstado
            )
            self.dispatches = result.dispatches
            self.pagination = result.pagination
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error desconocido: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
