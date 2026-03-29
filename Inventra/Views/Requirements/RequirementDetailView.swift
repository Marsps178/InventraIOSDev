import SwiftUI

struct RequirementDetailView: View {
    let id: Int
    @State var viewModel = RequirementDetailViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task { await viewModel.fetchRequirementDetail(id: id) }
                }
            } else if let requirement = viewModel.requirement {
                List {
                    // MARK: Información General
                    Section("Información General") {
                        LabeledContent("Código", value: requirement.codigo)

                        if let estado = requirement.estado as String? {
                            LabeledContent("Estado") { Badge(estado) }
                        }

                        if let mina = requirement.minas?.nombre {
                            LabeledContent("Mina", value: mina)
                        }
                        if let proveedor = requirement.proveedores?.nombre {
                            LabeledContent("Proveedor", value: proveedor)
                        }
                        if let supervisor = requirement.supervisores?.nombre {
                            LabeledContent("Supervisor", value: supervisor)
                        }
                        if let obs = requirement.observaciones, !obs.isEmpty {
                            LabeledContent("Observaciones", value: obs)
                        }
                    }

                    // MARK: Productos/Detalles
                    // Usa requirement.detalles (computed property de requerimiento_detalles)
                    // y los campos reales: nombreProducto, medida, cantidad_solicitada, entregado, porcentaje
                    Section("Productos (\(requirement.detalles.count))") {
                        if requirement.detalles.isEmpty {
                            Text("No hay detalles registrados")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(requirement.detalles) { detalle in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(detalle.nombreProducto)   // computed helper
                                        .fontWeight(.semibold)

                                    Text(detalle.medida)           // computed helper (medida.descripcion)
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Solicitado")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            Text("\(detalle.cantidad_solicitada)")
                                                .fontWeight(.semibold)
                                        }

                                        Spacer()

                                        VStack(alignment: .center, spacing: 2) {
                                            Text("Entregado")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            Text("\(detalle.entregado)")  // computed helper
                                                .fontWeight(.semibold)
                                        }

                                        Spacer()

                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text("Avance")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            Text("\(Int(detalle.porcentaje))%")  // computed helper
                                                .fontWeight(.semibold)
                                                .foregroundColor(detalle.porcentaje >= 100 ? .green : .orange)
                                        }
                                    }

                                    // Barra de progreso real
                                    ProgressView(value: detalle.porcentaje / 100.0)
                                        .tint(detalle.porcentaje >= 100 ? .green : .orange)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .navigationTitle("Requerimiento")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            Task { await viewModel.fetchRequirementDetail(id: id) }
        }
    }
}

#Preview {
    RequirementDetailView(id: 1)
}
