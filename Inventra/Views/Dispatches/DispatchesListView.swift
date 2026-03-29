import SwiftUI

struct DispatchesListView: View {
    @State var viewModel = DispatchesListViewModel()

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task { await viewModel.fetchDispatches() }
                }
            } else {
                List {
                    ForEach(viewModel.dispatches) { dispatch in
                        NavigationLink(destination: DispatchDetailView(id: dispatch.id)) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(dispatch.codigo)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Badge(dispatch.estado)
                                }

                                // usa .nombreMina computed helper del modelo corregido
                                Text(dispatch.nombreMina)
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                HStack {
                                    // usa .cantidadProductos (despacho_detalles?.count)
                                    Image(systemName: "shippingbox")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    Text("\(dispatch.cantidadProductos) producto(s)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)

                                    Spacer()

                                    if let vale = dispatch.numero_vale {
                                        Text("Vale: \(vale)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
                .navigationTitle("Despachos")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            Task { await viewModel.fetchDispatches() }
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
        }
        .onAppear {
            Task { await viewModel.fetchDispatches() }
        }
    }
}

#Preview {
    DispatchesListView()
}
