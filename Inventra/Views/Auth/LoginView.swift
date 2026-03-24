import SwiftUI

struct LoginView: View {
    @State var viewModel = LoginViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            NavigationStack {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "cube.box.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)
                        Text("Inventra")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Gestión de Inventario")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 16) {
                        TextField("Usuario", text: $viewModel.username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        SecureField("Contraseña", text: $viewModel.password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color(.systemRed).opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.login()
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Iniciar Sesión")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(viewModel.isLoading || viewModel.username.isEmpty || viewModel.password.isEmpty)
                    
                    Spacer()
                }
                .padding(24)
                .navigationBarTitleDisplayMode(.inline)
            }
            
            // TIER 1 #2: Network status indicator
            NetworkAlertView()
        }
    }
}

#Preview {
    LoginView()
}
