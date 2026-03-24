import SwiftUI

struct DispatchesListView: View {
    @State var viewModel = DispatchesListViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                LoadingView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task {
                        await viewModel.fetchDispatches()
                    }
                }
            } else {
                List {
                    ForEach(viewModel.dispatches) { dispatch in
                        NavigationLink(destination: DispatchDetailView(id: dispatch.id)) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(dispatch.codigo)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Badge(dispatch.estado)
                                }
                                
                                if let mina = dispatch.mina?.nombre {
                                    Text(mina)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Text("\(dispatch.total_productos) producto(s)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .navigationTitle("Despachos")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            Task {
                                await viewModel.fetchDispatches()
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
                await viewModel.fetchDispatches()
            }
        }
    }
}

#Preview {
    DispatchesListView()
}
