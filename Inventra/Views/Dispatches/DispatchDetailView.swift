import SwiftUI

struct DispatchDetailView: View {
    let id: Int
    @State var viewModel = DispatchDetailViewModel()
    @State var showConfirmDelivery = false
    @State var showConfirmTransit = false

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task { await viewModel.fetchDispatchDetail(id: id) }
                }
            } else if let dispatch = viewModel.dispatch {
                List {
                    // MARK: Info principal
                    Section("Información del Despacho") {
                        LabeledContent("Código", value: dispatch.codigo)
                        LabeledContent("Estado") { Badge(dispatch.estado) }
                        LabeledContent("Mina", value: dispatch.minas?.nombre ?? "—")

                        if let vale = dispatch.numero_vale {
                            LabeledContent("N° Vale", value: vale)
                        }
                        if let fecha = dispatch.fecha_creacion {
                            LabeledContent("Fecha creación", value: formatDate(fecha))
                        }
                        if let fechaSalida = dispatch.fecha_salida {
                            LabeledContent("Fecha salida", value: formatDate(fechaSalida))
                        }
                        if let fechaEntrega = dispatch.fecha_entrega {
                            LabeledContent("Fecha entrega", value: formatDate(fechaEntrega))
                        }
                        if let obs = dispatch.observaciones, !obs.isEmpty {
                            LabeledContent("Observaciones", value: obs)
                        }
                    }

                    // MARK: Vehículo / viaje
                    if let viaje = dispatch.viajes {
                        Section("Transporte") {
                            if let placa = viaje.placa_vehiculo {
                                LabeledContent("Placa", value: placa)
                            }
                            if let conductor = viaje.conductor {
                                LabeledContent("Conductor", value: conductor)
                            }
                            if let nViaje = viaje.numero_viaje {
                                LabeledContent("N° Viaje", value: String(nViaje))
                            }
                        }
                    }

                    // MARK: Productos — usa campos reales del backend
                    Section("Productos despachados (\(dispatch.detalles.count))") {
                        if dispatch.detalles.isEmpty {
                            Text("Sin productos registrados")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(dispatch.detalles) { detalle in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(detalle.nombreProducto)
                                        .fontWeight(.medium)
                                    HStack {
                                        Text(detalle.descripcionMedida)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        // Campo correcto: cantidad_despachada
                                        Text("\(detalle.cantidad_despachada) unid.")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    }
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }

                    // MARK: Acciones por estado
                    if dispatch.estado == "PREPARANDO" {
                        Section {
                            Button(action: { showConfirmTransit = true }) {
                                Label("Enviar a Tránsito", systemImage: "truck.box.fill")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                            }
                            .listRowBackground(Color.blue)
                            .disabled(viewModel.isSubmitting)
                        }
                    }

                    if dispatch.estado == "EN_TRANSITO" {
                        Section {
                            Button(action: { showConfirmDelivery = true }) {
                                Label("Marcar como Entregado", systemImage: "checkmark.circle.fill")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                            }
                            .listRowBackground(Color.green)
                            .disabled(viewModel.isSubmitting)
                        }
                    }
                }
                .navigationTitle("Despacho")
                .navigationBarTitleDisplayMode(.inline)
                // Alerta: Confirmar ENTREGADO
                .alert("Confirmar Entrega", isPresented: $showConfirmDelivery) {
                    Button("Cancelar", role: .cancel) {}
                    Button("Confirmar", role: .destructive) {
                        Task { await viewModel.markAsDelivered() }
                    }
                } message: {
                    Text("¿Confirma que el despacho \(dispatch.codigo) fue entregado?")
                }
                // Alerta: Confirmar EN_TRANSITO
                .alert("Confirmar Tránsito", isPresented: $showConfirmTransit) {
                    Button("Cancelar", role: .cancel) {}
                    Button("Enviar", role: .destructive) {
                        Task { await viewModel.markAsInTransit() }
                    }
                } message: {
                    Text("¿Confirma que el despacho \(dispatch.codigo) salió a su destino?")
                }
                // Alerta: Éxito
                .alert("Éxito", isPresented: .constant(viewModel.successMessage != nil)) {
                    Button("OK") {
                        viewModel.successMessage = nil
                        Task { await viewModel.fetchDispatchDetail(id: id) }
                    }
                } message: {
                    Text(viewModel.successMessage ?? "")
                }
            }
        }
        .onAppear {
            Task { await viewModel.fetchDispatchDetail(id: id) }
        }
    }

    private func formatDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: isoString) {
            let display = DateFormatter()
            display.dateStyle = .medium
            display.timeStyle = .short
            display.locale = Locale(identifier: "es_PE")
            return display.string(from: date)
        }
        return isoString
    }
}

#Preview {
    DispatchDetailView(id: 1)
}
