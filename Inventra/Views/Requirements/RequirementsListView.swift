import SwiftUI

struct RequirementsListView: View {
    @State var viewModel = RequirementsListViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task {
                        await viewModel.fetchRequirements()
                    }
                }
            } else {
                List {
                    ForEach(viewModel.requirements) { requirement in
                        NavigationLink(destination: RequirementDetailView(id: requirement.id)) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(requirement.codigo)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Badge(requirement.estado)
                                }
                                
                                if let mina = requirement.mina?.nombre {
                                    Text(mina)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                ProgressView(value: Double(requirement.porcentaje_entrega) / 100.0)
                                    .tint(.green)
                            }
                        }
                    }
                }
                .navigationTitle("Requerimientos")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            Task {
                                await viewModel.fetchRequirements()
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchRequirements()
            }
        }
    }
}

#Preview {
    RequirementsListView()
}
