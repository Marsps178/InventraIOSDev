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

    // PATCH /despachos/:id/entregar — el backend solo necesita fecha_entrega (opcional)
    func markAsDelivered() async {
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
            let updated = try await DispatchService.shared.markAsDelivered(
                id: dispatchId,
                fechaEntrega: fechaEntrega
            )
            self.dispatch = updated
            successMessage = "Despacho marcado como entregado exitosamente"
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error desconocido"
        }

        isSubmitting = false
    }

    // PATCH /despachos/:id/transito
    func markAsInTransit() async {
        isSubmitting = true
        errorMessage = nil
        successMessage = nil

        guard let dispatchId = dispatch?.id_despacho else {
            errorMessage = "Error: Despacho no encontrado"
            isSubmitting = false
            return
        }

        do {
            let updated = try await DispatchService.shared.markAsInTransit(id: dispatchId)
            self.dispatch = updated
            successMessage = "Despacho enviado a tránsito"
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error desconocido"
        }

        isSubmitting = false
    }

    // PATCH /despachos/:id/anular
    func cancelDispatch(motivo: String) async {
        isSubmitting = true
        errorMessage = nil
        successMessage = nil

        guard let dispatchId = dispatch?.id_despacho else {
            errorMessage = "Error: Despacho no encontrado"
            isSubmitting = false
            return
        }

        do {
            let updated = try await DispatchService.shared.cancelDispatch(id: dispatchId, motivo: motivo)
            self.dispatch = updated
            successMessage = "Despacho anulado"
        } catch let error as APIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error desconocido"
        }

        isSubmitting = false
    }
}
