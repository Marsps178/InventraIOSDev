import Foundation
import Observation

@Observable
class RequirementDetailViewModel {
    var requirement: RequirementDetail?
    var isLoading: Bool = false
    var errorMessage: String?
    
    func fetchRequirementDetail(id: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.requirement = try await RequirementService.shared.fetchRequirementDetail(id: id)
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error desconocido"
        }
        
        isLoading = false
    }
}
