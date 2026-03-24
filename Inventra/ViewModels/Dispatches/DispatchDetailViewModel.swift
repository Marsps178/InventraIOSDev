import Foundation
import Observation

@Observable
class DispatchDetailViewModel {
    var dispatch: DispatchDetail?
    var isLoading: Bool = false
    var isSubmitting: Bool = false
    var errorMessage: String?
    var successMessage: String?
    
    func fetchDispatchDetail(id: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.dispatch = try await DispatchService.shared.fetchDispatchDetail(id: id)
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error desconocido"
        }
        
        isLoading = false
    }
    
    func markAsDelivered(comentarios: String) async {
        isSubmitting = true
        errorMessage = nil
        successMessage = nil
        
        guard let dispatchId = dispatch?.id_despacho else {
            errorMessage = "Error: Despacho no encontrado"
            isSubmitting = false
            return
        }
        
        let formatter = ISO8601DateFormatter()
        let fechaEntrega = formatter.string(from: Date())
        
        do {
            _ = try await DispatchService.shared.markAsDelivered(
                id: dispatchId,
                fechaEntrega: fechaEntrega,
                comentarios: comentarios
            )
            successMessage = "Despacho marcado como entregado"
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error desconocido"
        }
        
        isSubmitting = false
    }
}
