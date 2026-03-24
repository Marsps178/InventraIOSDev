import SwiftUI

struct RequirementDetailView: View {
    let id: Int
    @State var viewModel = RequirementDetailViewModel()
    
    var body: some View {
        if viewModel.isLoading {
            LoadingView()
        } else if let errorMessage = viewModel.errorMessage {
            ErrorView(message: errorMessage) {
                Task {
                    await viewModel.fetchRequirementDetail(id: id)
                }
            }
        } else if let requirement = viewModel.requirement {
            List {
                Section(header: Text("Información General")) {
                    HStack {
                        Text("Código")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(requirement.codigo)
                            .foregroundColor(.blue)
                    }
                }
                
                Section(header: Text("Detalles del Requerimiento")) {
                    if let detalles = requirement.detalles, !detalles.isEmpty {
                        ForEach(detalles) { detalle in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(detalle.producto.nombre)
                                    .fontWeight(.semibold)
                                
                                HStack {
                                    Text("Medida: \(detalle.medida_solicitada)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Solicitado")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(String(detalle.cantidad_solicitada))
                                            .fontWeight(.semibold)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading) {
                                        Text("Recibido")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(String(detalle.cantidad_recibida))
                                            .fontWeight(.semibold)
                                    }
                                }
                            }
                        }
                    } else {
                        Text("No hay detalles")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Detalle Requerimiento")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RequirementDetailView(id: 1)
}
