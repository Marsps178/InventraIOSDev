import SwiftUI

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    let user: User
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView {
                // Despachos Tab
                DispatchesListView()
                    .tabItem {
                        Label("Despachos", systemImage: "truck.box.fill")
                    }
                
                // Requerimientos Tab
                RequirementsListView()
                    .tabItem {
                        Label("Requerimientos", systemImage: "list.clipboard.fill")
                    }
                
                // Perfil Tab
                ProfileView(user: user)
                    .tabItem {
                        Label("Perfil", systemImage: "person.fill")
                    }
            }
            
            // TIER 1 #2: Network status indicator
            NetworkAlertView()
        }
    }
}

struct ProfileView: View {
    let user: User
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Información del Usuario")) {
                    HStack {
                        Text("Nombre")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(user.fullName)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Usuario")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(user.username)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Rol")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(user.rol)
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        AuthManager.shared.logout()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left.circle.fill")
                            Text("Cerrar Sesión")
                        }
                    }
                }
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomeView(user: User(
        id_usuario: 1,
        username: "admin",
        rol: "ADMIN",
        id_mina: nil,
        nombre: "Juan",
        apellidos: "Pérez"
    ))
}
