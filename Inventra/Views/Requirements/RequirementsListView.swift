import SwiftUI

struct RequirementsListView: View {
    @State var viewModel = RequirementsListViewModel()

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task { await viewModel.fetchRequirements() }
                }
            } else {
                List {
                    ForEach(viewModel.requirements) { requirement in
                        NavigationLink(destination: RequirementDetailView(id: requirement.id)) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(requirement.codigo)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Badge(requirement.estado)
                                }

                                // Usa el helper .nombreMina del modelo corregido
                                Text(requirement.nombreMina)
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                HStack {
                                    Image(systemName: "shippingbox")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    Text("\(requirement.cantidadProductos) producto(s)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    if let proveedor = requirement.proveedores?.nombre {
                                        Text(proveedor)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .navigationTitle("Requerimientos")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            Task { await viewModel.fetchRequirements() }
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
        }
        .onAppear {
            Task { await viewModel.fetchRequirements() }
        }
    }
}

#Preview {
    RequirementsListView()
}
