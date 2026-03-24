# Arquitectura y Diseño - Inventra iOS App

## 1. Visión General
La aplicación iOS de **Inventra** estará enfocada en las **operaciones de campo**. A diferencia de la versión web (que es un panel administrativo completo), la app móvil permitirá a Supervisores, personal de Mina y Logística interactuar con el ERP en tiempo real y desde cualquier lugar.

---

## 2. Módulos y Vistas (Views en SwiftUI)

### 2.1. Módulo de Autenticación (Auth)
*   **`LoginView`**: Pantalla de inicio de sesión conectada al JWT del backend.
*   **`ProfileView`**: Perfil del usuario autenticado, mostrando su rol (Ej. *MINA* o *SUPERVISOR*) y opción de cerrar sesión.

### 2.2. Módulo de Requerimientos (Mina / Supervisor)
*   **`RequirementsListView`**: Lista de requerimientos (pendientes, en tránsito, completados).
*   **`RequirementCreateView`**: Formulario ágil para que la mina solicite nuevo material operando con selectores nativos de iOS (Pickers).
*   **`RequirementDetailView`**: Visualización del pedido, incluyendo porcentaje de entrega.

### 2.3. Módulo de Logística y Viajes (Transporte)
*   **`TripsListView`**: Lista de viajes en ruta o históricos.
*   **`TripDetailView`**: Detalle del viaje, conductor, camión y manifiesto de carga.

### 2.4. Módulo de Despachos (Recepción en Mina)
*   **`DispatchListView`**: Lista de despachos actualmente `EN_TRANSITO` hacia la mina.
*   **`DispatchReceiveView`**: Pantalla crítica. Permitirá al personal de la mina confirmar la recepción física caja por caja, marcando entregas como "OK" o "DAÑADO". 
    *   *Sugerencia:* Se podría integrar la cámara del iPhone para adjuntar evidencia fotográfica del estado de la madera.

### 2.5. Módulo de Inventario (Consulta)
*   **`StockIndexView`**: Buscador de stock disponible (Kardex simplificado).
*   **`ProductDetailView`**: Ficha del producto, foto referencial y stock actual.

---

## 3. Endpoints (APIs) a Consumir

La aplicación se conectará al backend existente (`http://tu-dominio/api`) adjuntando el **Bearer Token** en las cabeceras.

### 🔐 Autenticación y Seguridad
*   `POST /api/auth/login` - Iniciar sesión y guardar Token JWT en *Keychain*.
*   `GET /api/users/me` - Validar sesión y descargar datos del perfil/rol.

### 📦 Requerimientos
*   `GET /api/requirements` - Listar los pedidos generados (soporta filtros `?estado=PENDIENTE`).
*   `GET /api/requirements/:id` - Detalles de los ítems a enviar.
*   `POST /api/requirements` - Si el rol lo permite, crear un Requerimiento directamente desde el iPhone.

### 🚛 Viajes Logísticos
*   `GET /api/viajes` - Obtener bitácora de viajes.
*   `GET /api/viajes/:id` - Ver qué productos físicos van dentro de un camión (Guía de remisión).

### 📤 Despachos (Operación Principal Móvil)
*   `GET /api/despachos` - Ver lista de Despachos (`estado=EN_TRANSITO` es ideal para las minas).
*   `GET /api/despachos/:id` - Cargar lista de empaque.
*   `PUT /api/despachos/:id` - Cambiar a estado `ENTREGADO` una vez verificado físicamente en la mina. *(Se usaría o adaptaría un endpoint existente como el `marcarEntregado` del servicio de despachos)*.

### 🗄️ Inventario y Tablas Maestras (Caché Offline)
*   `GET /api/inventory/stock` - Buscar materiales rápidamente.
*   `GET /api/products` - Catálogo para la creación de requerimientos.
*   `GET /api/mines` - Descubrir las minas habilitadas en el sistema.

---

## 4. Stack Tecnológico Sugerido (iOS Nativo)
Para el desarrollo de la app, esta es la arquitectura recomendada para integrarse fluidamente con el ERP:

*   **Lenguaje:** Swift 5.0+
*   **UI Framework:** **SwiftUI** (Perfecto para hacer apps empresariales modernas muy rápido).
*   **Arquitectura:** MVVM (Model-View-ViewModel).
*   **Persistencia:** `SwiftData` o `CoreData`. Es vital para guardar en caché la lista de Productos y Minas por si el usuario pierde la señal en la cordillera.
*   **Networking:** `URLSession` genérico con decodificación estricta (`Codable`) para mapear los mismos schemas Zod que ya tienes en el backend de Node.js.

---

## 5. Estructura de Datos (JSON Responses)

Las llamadas a la API de **Inventra** devuelven la información de manera estructurada y estandarizada. Para consumir estas APIs en Swift, puedes crear estructuras (Structs) conformes al protocolo `Decodable`.

### 5.1. Respuesta Base Estandarizada
La mayoría de los endpoints que tienen paginación responden con un objeto principal envolvente:

```json
{
  "status": "success",
  "data": {
    "data": [
      // Arreglo de objetos (Requerimientos, Despachos, etc.)
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 50,
      "totalPages": 5
    }
  }
}
```

#### Modelo en Swift (Ejemplo Genérico)
```swift
struct APIResponse<T: Decodable>: Decodable {
    let status: String
    let data: APIPaginatedData<T>
}

struct APIPaginatedData<T: Decodable>: Decodable {
    let data: [T]
    let pagination: Pagination
}

struct Pagination: Decodable {
    let page: Int
    let limit: Int
    let total: Int
    let totalPages: Int
}
```

### 5.2. Ejemplo: Detalle de un Despacho (`/api/despachos/:id`)
```json
{
  "id_despacho": 1,
  "codigo": "DSP-2026-0001",
  "fecha_creacion": "2026-03-24T10:00:00Z",
  "estado": "EN_TRANSITO",
  "observacion": "Envío a zona sur",
  "mina": {
    "id_mina": 3,
    "nombre": "ESPERANZA"
  },
  "detalles": [
    {
      "id_detalle": 15,
      "cantidad": 100,
      "producto": {
        "id_producto": 10,
        "nombre": "POSTES",
        "medida": {
          "descripcion": "1.80 MTS x 8"
        }
      }
    }
  ]
}
```

#### Modelo en Swift (Ejemplo para Despachos)
```swift
struct Despacho: Decodable, Identifiable {
    let id_despacho: Int
    let codigo: String
    let fecha_creacion: String // Parsear con ISO8601DateFormatter
    let estado: String
    let observacion: String?
    let mina: MinaBase?
    let detalles: [DespachoDetalle]?
    
    var id: Int { id_despacho }
}

struct DespachoDetalle: Decodable, Identifiable {
    let id_detalle: Int
    let cantidad: Int
    let producto: ProductoBase
    
    var id: Int { id_detalle }
}
```

### 5.3. Requerimientos de Autenticación (`Auth`)
Para casi todas las rutas, debes extraer el token devuelto por `POST /api/auth/login`:
```json
{
  "status": "success",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1...",
    "refreshToken": "eyJhbGciOiJIUzI1...",
    "user": {
      "id_usuario": 1,
      "username": "admin",
      "rol": "ADMIN",
      "nombre": "Juan",
      "apellidos": "Pérez"
    }
  }
}
```
*   Debes inyectar el valor de `accessToken` en la cabecera HTTP de todas las demás peticiones:
    `Authorization: Bearer eyJhbGciOiJIUzI1...`
