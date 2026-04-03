import Foundation

// ============================================================
// APIEndpoint — Rutas centralizadas del backend
// Base URL: http://<host>:3000/api
// ============================================================

enum APIEndpoint {
    // MARK: — Auth
    case login
    case refreshToken
    case getUserProfile         // GET /auth/me

    // MARK: — Requerimientos
    case getRequirements(page: Int = 1, limit: Int = 20, estado: String? = nil)
    case getRequirement(id: Int)
    case getRequirementProgress(id: Int)
    case createRequirement

    // MARK: — Viajes
    case getTrips(page: Int = 1, estado: String? = nil)
    case getTrip(id: Int)

    // MARK: — Despachos
    case getDispatches(page: Int = 1, limit: Int = 20, estado: String? = nil, idMina: Int? = nil)
    case getDispatch(id: Int)
    case markDispatchInTransit(id: Int)     // PATCH /despachos/:id/transito
    case markDispatchDelivered(id: Int)     // PATCH /despachos/:id/entregar
    case cancelDispatch(id: Int)            // PATCH /despachos/:id/anular

    // MARK: — Inventario
    case getStock(search: String? = nil, page: Int = 1, limit: Int = 20)
    case getKardex(idProducto: Int? = nil, page: Int = 1)
    case getProducts(page: Int = 1, limit: Int = 50)
    case getMines
    case getSupervisors
    case getProviders

    // MARK: - path
    var path: String {
        switch self {
        // Auth
        case .login:            return "/auth/login"
        case .refreshToken:     return "/auth/refresh"
        case .getUserProfile:   return "/auth/me"           // ← corregido: era /users/me

        // Requerimientos
        case .getRequirements:              return "/requirements"
        case .getRequirement(let id):       return "/requirements/\(id)"
        case .getRequirementProgress(let id): return "/requirements/\(id)/progress"
        case .createRequirement:            return "/requirements"

        // Viajes
        case .getTrips:                     return "/viajes"
        case .getTrip(let id):              return "/viajes/\(id)"

        // Despachos
        case .getDispatches:                return "/despachos"
        case .getDispatch(let id):          return "/despachos/\(id)"
        case .markDispatchInTransit(let id):  return "/despachos/\(id)/transito"
        case .markDispatchDelivered(let id):  return "/despachos/\(id)/entregar"
        case .cancelDispatch(let id):         return "/despachos/\(id)/anular"

        // Inventario
        case .getStock:         return "/inventory/stock"
        case .getKardex:        return "/inventory/kardex"
        case .getProducts:      return "/products"
        case .getMines:         return "/mines"
        case .getSupervisors:   return "/supervisors"
        case .getProviders:     return "/providers"
        }
    }

    // MARK: - method
    var method: String {
        switch self {
        case .createRequirement, .login, .refreshToken:
            return "POST"
        // PATCH para todos los cambios de estado de despachos
        case .markDispatchDelivered, .markDispatchInTransit, .cancelDispatch:
            return "PATCH"                  // ← corregido: era PUT
        default:
            return "GET"
        }
    }

    // MARK: - queryItems
    var queryItems: [URLQueryItem] {
        switch self {
        case .getRequirements(let page, let limit, let estado):
            var items = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
            if let estado = estado { items.append(URLQueryItem(name: "estado", value: estado)) }
            return items

        case .getTrips(let page, let estado):
            var items = [URLQueryItem(name: "page", value: String(page))]
            if let estado = estado { items.append(URLQueryItem(name: "estado", value: estado)) }
            return items

        case .getDispatches(let page, let limit, let estado, let idMina):
            var items = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
            if let estado = estado  { items.append(URLQueryItem(name: "estado", value: estado)) }
            if let idMina = idMina  { items.append(URLQueryItem(name: "id_mina", value: String(idMina))) }
            return items

        case .getStock(let search, let page, let limit):
            var items = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
            if let search = search { items.append(URLQueryItem(name: "search", value: search)) }
            return items

        case .getKardex(let idProducto, let page):
            var items = [URLQueryItem(name: "page", value: String(page))]
            if let id = idProducto { items.append(URLQueryItem(name: "id_producto", value: String(id))) }
            return items

        case .getProducts(let page, let limit):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]

        default:
            return []
        }
    }
}
