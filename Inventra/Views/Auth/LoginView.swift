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
                        // TIER 1 #3: Username field with validation
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Usuario", text: $viewModel.username)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .onChange(of: viewModel.username) { _, _ in
                                    viewModel.validateUsername()
                                }
                            
                            if let error = viewModel.usernameError {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.caption)
                                    Text(error)
                                        .font(.caption)
                                }
                                .foregroundColor(.red)
                                .padding(.horizontal, 4)
                            }
                        }
                        
                        // TIER 1 #3: Password field with validation
                        VStack(alignment: .leading, spacing: 4) {
                            SecureField("Contraseña", text: $viewModel.password)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .onChange(of: viewModel.password) { _, _ in
                                    viewModel.validatePassword()
                                }
                            
                            if let error = viewModel.passwordError {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.caption)
                                    Text(error)
                                        .font(.caption)
                                }
                                .foregroundColor(.red)
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color(.systemRed).opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    // TIER 1 #3: Button disabled if form invalid
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
                    .background(viewModel.isFormValid ? Color.blue : Color.blue.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(viewModel.isLoading || !viewModel.isFormValid)
                    
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
