import Foundation

// Respuesta envolvente genérica del API
struct APIResponse<T: Decodable>: Decodable {
    let status: String
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case status
        case data
    }
}

// Para respuestas paginadas
struct APIPaginatedResponse<T: Decodable>: Decodable {
    let status: String
    let data: PaginatedData<T>?
    
    enum CodingKeys: String, CodingKey {
        case status
        case data
    }
}

struct PaginatedData<T: Decodable>: Decodable {
    let data: [T]
    let pagination: Pagination
}

struct Pagination: Decodable {
    let page: Int
    let limit: Int
    let total: Int
    let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case limit
        case total
        case totalPages = "totalPages"
    }
}
