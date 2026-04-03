import Foundation

// MARK: - Stock (desde vista SQL v_stock_disponible)
struct Stock: Decodable, Identifiable {
    let id_producto: Int
    let id_medida: Int
    let producto: String
    let medida: String
    let clasificacion: String?
    let stock_actual: Int

    var id: String { "\(id_producto)-\(id_medida)" }

    var stockLevel: StockLevel {
        if stock_actual <= 0 { return .empty }
        if stock_actual < 50 { return .low }
        if stock_actual < 200 { return .medium }
        return .high
    }
}

enum StockLevel {
    case empty, low, medium, high
}

// MARK: - Product (GET /products)
struct Product: Decodable, Identifiable {
    let id_producto: Int
    let nombre: String
    let stock_actual: Int?
    let precio_venta_base: Double?
    let medidas: MedidaBase?
    let clasificaciones: ClasificacionBase?

    var id: Int { id_producto }
    var medidaDescripcion: String { medidas?.descripcion ?? "—" }
    var clasificacionNombre: String { clasificaciones?.nombre ?? "—" }
}

// MARK: - Mine (GET /mines)
struct Mine: Decodable, Identifiable {
    let id_mina: Int
    let nombre: String
    let razon_social: String?
    let ubicacion: String?
    let contacto: String?

    var id: Int { id_mina }
}

// MARK: - Supervisor (GET /supervisors)
struct Supervisor: Decodable, Identifiable {
    let id_supervisor: Int
    let nombre: String
    let telefono: String?
    let email: String?

    var id: Int { id_supervisor }
}

// MARK: - Provider (GET /providers)
struct Provider: Decodable, Identifiable {
    let id_proveedor: Int
    let nombre: String
    let razon_social: String?
    let ruc: String?
    let contacto: String?
    let telefono: String?

    var id: Int { id_proveedor }
}
