import SwiftUI

struct DispatchDetailView: View {
    let id: Int
    @State var viewModel = DispatchDetailViewModel()
    @State var comentarios = ""
    @State var showConfirmation = false
    
    var body: some View {
        if viewModel.isLoading {
            LoadingView()
        } else if let errorMessage = viewModel.errorMessage {
            ErrorView(message: errorMessage) {
                Task {
                    await viewModel.fetchDispatchDetail(id: id)
                }
            }
        } else if let dispatch = viewModel.dispatch {
            List {
                Section(header: Text("Información del Despacho")) {
                    HStack {
                        Text("Código")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(dispatch.codigo)
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Estado")
                            .fontWeight(.semibold)
                        Spacer()
                        Badge(dispatch.estado)
                    }
                    
                    if let observacion = dispatch.observacion {
                        HStack {
                            Text("Observación")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(observacion)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                
                Section(header: Text("Productos")) {
                    if let detalles = dispatch.detalles, !detalles.isEmpty {
                        ForEach(detalles) { detalle in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(detalle.producto.nombre)
                                    .fontWeight(.semibold)
                                
                                if let medida = detalle.producto.medida?.descripcion {
                                    Text(medida)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Text("Cantidad: \(detalle.cantidad)")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                
                if dispatch.estado == "EN_TRANSITO" {
                    Section(header: Text("Confirmar Entrega")) {
                        TextField("Comentarios (opcional)", text: $comentarios, axis: .vertical)
                            .lineLimit(3...5)
                        
                        Button(action: { showConfirmation = true }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Marcar como Entregado")
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                        }
                        .listRowBackground(Color.green)
                        .disabled(viewModel.isSubmitting)
                    }
                }
            }
            .navigationTitle("Detalle Despacho")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Confirmar Entrega", isPresented: $showConfirmation) {
                Button("Cancelar", role: .cancel) {}
                Button("Confirmar", role: .destructive) {
                    Task {
                        await viewModel.markAsDelivered(comentarios: comentarios)
                    }
                }
            } message: {
                Text("¿Confirma que el despacho ha sido entregado correctamente?")
            }
            .alert("Éxito", isPresented: .constant(viewModel.successMessage != nil)) {
                Button("OK") {
                    Task {
                        await viewModel.fetchDispatchDetail(id: id)
                    }
                }
            } message: {
                Text(viewModel.successMessage ?? "")
            }
        }
    }
}

#Preview {
    DispatchDetailView(id: 1)
}
