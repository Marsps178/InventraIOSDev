# 📱 Inventra iOS App - Guía de Arquitectura

## 🏗️ Estructura Implementada

Tu app está construida en **MVVM + Async/Await** con una arquitectura limpia y profesional:

```
Core/
  ├── Networking/
  │   ├── APIClient.swift ..................... Cliente HTTP genérico (peticiones)
  │   ├── APIEndpoint.swift ................... Rutas y endpoints centralizados
  │   └── APIError.swift ...................... Manejo de errores de red
  │
  └── Managers/
      ├── AuthManager.swift ................... Gestión de sesión y autenticación
      └── TokenManager.swift .................. Almacenamiento seguro (Keychain)

Models/
  ├── Auth/ ................................. LoginRequest, User, AuthResponse
  ├── Requirements/ .......................... Requirement, RequirementDetail
  ├── Trips/ ................................ Trip, TripDetail
  ├── Dispatches/ ........................... Dispatch, DispatchDetail
  ├── Inventory/ ............................ Stock, Product, Mine
  └── Common/ ............................... APIResponse, Pagination, Errors

Services/
  ├── AuthService.swift ..................... Login, logout, refresh token
  ├── RequirementService.swift .............. Obtener y crear requerimientos
  ├── TripService.swift ..................... Listar viajes
  ├── DispatchService.swift ................. Despachos y confirmación de entrega
  └── InventoryService.swift ................ Stock, productos, minas

ViewModels/
  ├── Auth/
  │   └── LoginViewModel.swift .............. Lógica de login
  ├── Requirements/
  │   ├── RequirementsListViewModel.swift ... Lista de requerimientos
  │   └── RequirementDetailViewModel.swift .. Detalle de requerimiento
  └── Dispatches/
      ├── DispatchesListViewModel.swift .... Lista de despachos
      └── DispatchDetailViewModel.swift ... Detalle y confirmación

Views/
  ├── Auth/
  │   └── LoginView.swift ................... Pantalla de inicio de sesión
  ├── Home/
  │   └── HomeView.swift .................... TabView principal con perfil
  ├── Requirements/ ......................... Listado y detalle
  ├── Dispatches/ .......................... Listado y detalle
  └── Components/ ........................... LoadingView, ErrorView, Badge
```

---

## 🔐 Flujo de Autenticación

1. **Usuario ingresa credenciales** → `LoginView` → `LoginViewModel`
2. **ViewModel llama** → `AuthService.login()` → `AuthManager.login()`
3. **AuthManager realiza POST** → `APIClient.request(endpoint: .login)`
4. **Tokens guardados en Keychain** → `TokenManager.saveTokens()`
5. **AuthManager actualiza `isAuthenticated`** → App recarga a `HomeView`
6. **Token automático** → Todos los servicios lo inyectan en headers

---

## 🔌 Consumir un Endpoint en tu API

### Paso 1: Crear un Model (si no existe)
```swift
struct MyData: Decodable {
    let id: Int
    let name: String
}
```

### Paso 2: Agregar al APIEndpoint (si es nuevo)
```swift
case getMyData(id: Int)

var path: String {
    case .getMyData(let id):
        return "/my-data/\(id)"
}
```

### Paso 3: Llamar desde un ViewModel
```swift
let myData: MyData = try await APIClient.shared.request(
    endpoint: .getMyData(id: 123),
    token: TokenManager.shared.accessToken
)
```

---

## 📊 Endpoints Mapeados Actualmente

| Módulo | Endpoint | Implementado |
|--------|----------|--------------|
| **Auth** | `POST /auth/login` | ✅ |
| | `POST /auth/refresh` | ✅ |
| | `GET /users/me` | ✅ |
| **Requirements** | `GET /requirements` | ✅ |
| | `GET /requirements/:id` | ✅ |
| | `POST /requirements` | ✅ (Model) |
| **Trips** | `GET /viajes` | ✅ |
| | `GET /viajes/:id` | ✅ |
| **Dispatches** | `GET /despachos` | ✅ |
| | `GET /despachos/:id` | ✅ |
| | `PUT /despachos/:id/entregar` | ✅ |
| **Inventory** | `GET /inventory/stock` | ✅ |
| | `GET /products` | ✅ |
| | `GET /mines` | ✅ |

---

## 🚀 Próximos Pasos (TODO)

### 1. **Configurar URL Base** (CRÍTICO)
   - En `APIClient.init()`, cambiar `baseURL` a tu servidor:
   ```swift
   init(baseURL: String = "http://tu-dominio-real/api", session: URLSession = .shared)
   ```

### 2. **Implementar Refresh Token Automático**
   - En `APIClient`, capturar error 401 → llamar `AuthManager.refreshAccessToken()`
   - Re-intentar request original con nuevo token

### 3. **Agregar Más ViewModels**
   - `TripListViewModel` y `TripDetailViewModel`
   - `InventoryViewModel` (búsqueda de stock)
   - Crear vistas correspondientes

### 4. **Cache Local**
   - Agregar `SwiftData` para caché offline
   - Guardar productos, minas al iniciar sesión

### 5. **Manejo de Errores Avanzado**
   - Alerts con retry automático
   - Network reachability check
   - Offline mode indicator

### 6. **Pruebas**
   - Unit tests para ViewModels
   - UI tests para flujo de login

---

## 💡 Patrones Clave

### Enviar Token en Toda Solicitud
```swift
guard let token = TokenManager.shared.accessToken else {
    throw APIError.unauthorized
}
return try await APIClient.shared.request(
    endpoint: .getRequirements(),
    token: token
)
```

### Manejar Errores en ViewModel
```swift
do {
    self.items = try await SomeService.fetchItems()
} catch let error as APIError {
    self.errorMessage = error.localizedDescription
} catch {
    self.errorMessage = "Error desconocido"
}
```

### Observable para State Management
```swift
@Observable
class MyViewModel {
    var data: [Item] = []
    var isLoading = false
    var errorMessage: String?
}
```

---

## 📝 Resumen

✅ **Completado:**
- Arquitectura MVVM moderna
- Networking genérico y reutilizable  
- Autenticación con Keychain
- Todos los modelos decodificables
- 5 módulos con vistas básicas
- Error handling estructurado

⚠️ **Falta:**
- Configurar URL del backend real
- Implementar refresh token automático
- ViewModels para Trips e Inventory
- Caché local (SwiftData)
- Validación de formularios avanzada
- Tests

**Estado:** Prototipo funcional 🎉 → Listo para conectar con backend real
