import Foundation

// MARK: - Stock
struct Stock: Decodable, Identifiable {
    let producto: String
    let medida: String
    let clasificacion: String
    let stock_actual: Int
    
    var id: String { "\(producto)-\(medida)" }
}

// MARK: - Product
struct Product: Decodable, Identifiable {
    let id_producto: Int
    let nombre: String
    let medida: MedidaBase?
    
    var id: Int { id_producto }
}

struct MedidaBase: Decodable {
    let id_medida: Int?
    let descripcion: String
}

// MARK: - Mine
struct Mine: Decodable, Identifiable {
    let id_mina: Int
    let nombre: String
    
    var id: Int { id_mina }
}

// MARK: - Base Models (Usados en múltiples respuestas)
struct MinaBase: Decodable {
    let id_mina: Int?
    let nombre: String?
}

struct ProductoBase: Decodable {
    let id_producto: Int?
    let nombre: String
    let medida: MedidaBase?
}
