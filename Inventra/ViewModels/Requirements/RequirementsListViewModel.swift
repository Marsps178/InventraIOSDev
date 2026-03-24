import Foundation
import Observation

@Observable
class RequirementsListViewModel {
    var requirements: [Requirement] = []
    var pagination: Pagination?
    var isLoading: Bool = false
    var errorMessage: String?
    var selectedEstado: String? = nil
    
    func fetchRequirements(page: Int = 1) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await RequirementService.shared.fetchRequirements(
                page: page,
                estado: selectedEstado
            )
            self.requirements = result.requirements
            self.pagination = result.pagination
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error desconocido"
        }
        
        isLoading = false
    }
}
