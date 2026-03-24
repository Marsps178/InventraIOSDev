import Foundation

enum APIEndpoint {
    // Auth
    case login
    case refreshToken
    case getUserProfile
    
    // Requirements
    case getRequirements(page: Int = 1, limit: Int = 20, estado: String? = nil)
    case getRequirement(id: Int)
    case createRequirement
    
    // Trips
    case getTrips(page: Int = 1, estado: String? = nil)
    case getTrip(id: Int)
    
    // Dispatches
    case getDispatches(page: Int = 1, estado: String? = nil, idMina: Int? = nil)
    case getDispatch(id: Int)
    case markDispatchDelivered(id: Int)
    
    // Inventory
    case getStock(search: String? = nil, page: Int = 1)
    case getProducts(page: Int = 1)
    case getMines
    
    var path: String {
        switch self {
        // Auth
        case .login:
            return "/auth/login"
        case .refreshToken:
            return "/auth/refresh"
        case .getUserProfile:
            return "/users/me"
        
        // Requirements
        case .getRequirements:
            return "/requirements"
        case .getRequirement(let id):
            return "/requirements/\(id)"
        case .createRequirement:
            return "/requirements"
        
        // Trips
        case .getTrips:
            return "/viajes"
        case .getTrip(let id):
            return "/viajes/\(id)"
        
        // Dispatches
        case .getDispatches:
            return "/despachos"
        case .getDispatch(let id):
            return "/despachos/\(id)"
        case .markDispatchDelivered(let id):
            return "/despachos/\(id)/entregar"
        
        // Inventory
        case .getStock:
            return "/inventory/stock"
        case .getProducts:
            return "/products"
        case .getMines:
            return "/mines"
        }
    }
    
    var method: String {
        switch self {
        case .createRequirement, .login, .refreshToken:
            return "POST"
        case .markDispatchDelivered:
            return "PUT"
        default:
            return "GET"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getRequirements(let page, let limit, let estado):
            var items = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
            if let estado = estado {
                items.append(URLQueryItem(name: "estado", value: estado))
            }
            return items
        
        case .getTrips(let page, let estado):
            var items = [URLQueryItem(name: "page", value: String(page))]
            if let estado = estado {
                items.append(URLQueryItem(name: "estado", value: estado))
            }
            return items
        
        case .getDispatches(let page, let estado, let idMina):
            var items = [URLQueryItem(name: "page", value: String(page))]
            if let estado = estado {
                items.append(URLQueryItem(name: "estado", value: estado))
            }
            if let idMina = idMina {
                items.append(URLQueryItem(name: "id_mina", value: String(idMina)))
            }
            return items
        
        case .getStock(let search, let page):
            var items = [URLQueryItem(name: "page", value: String(page))]
            if let search = search {
                items.append(URLQueryItem(name: "search", value: search))
            }
            return items
        
        case .getProducts(let page):
            return [URLQueryItem(name: "page", value: String(page))]
        
        default:
            return []
        }
    }
}
