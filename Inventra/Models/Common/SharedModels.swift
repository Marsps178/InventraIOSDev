import Foundation

// ============================================================
// SharedModels.swift — Modelos compartidos entre módulos
// Estos tipos son embebidos por Prisma en múltiples respuestas
// ============================================================

// MARK: - Producto embed (incluido en detalles de requerimientos, despachos, viajes)
struct ProductoEmbed: Decodable {
    let id_producto: Int?
    let nombre: String
    let medidas: MedidaBase?
}

// MARK: - Medida base
struct MedidaBase: Decodable {
    let id_medida: Int?
    let descripcion: String
}

// MARK: - Clasificacion base
struct ClasificacionBase: Decodable {
    let id_clasificacion: Int?
    let nombre: String?
}

// MARK: - Mina ref simple (usada en listas)
struct MinaRef: Decodable {
    let nombre: String?
}

// MARK: - Proveedor ref simple
struct ProveedorRef: Decodable {
    let nombre: String?
}

// MARK: - Supervisor ref simple
struct SupervisorRef: Decodable {
    let nombre: String?
}

// MARK: - Mina ref completa
struct MinaRefFull: Decodable {
    let id_mina: Int?
    let nombre: String?
    let razon_social: String?
    let ubicacion: String?
}

// MARK: - Supervisor ref completa
struct SupervisorRefFull: Decodable {
    let id_supervisor: Int?
    let nombre: String?
    let telefono: String?
    let email: String?
}

// MARK: - Proveedor ref completa
struct ProveedorRefFull: Decodable {
    let id_proveedor: Int?
    let nombre: String?
    let razon_social: String?
}

// MARK: - Requerimiento ref
struct RequerimientoRef: Decodable {
    let id_requerimiento: Int?
    let codigo: String?
}

struct RequerimientoRefFull: Decodable {
    let id_requerimiento: Int?
    let codigo: String?
    let estado: String?
}
