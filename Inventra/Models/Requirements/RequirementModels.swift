import Foundation

// MARK: - Requirement List (GET /requirements)
struct Requirement: Decodable, Identifiable {
    let id_requerimiento: Int
    let codigo: String
    let estado: String
    let fecha_emision: String?
    let fecha_prometida: String?

    // Relaciones (nombres de tabla Prisma en plural)
    let minas: MinaRef?
    let proveedores: ProveedorRef?
    let supervisores: SupervisorRef?
    let _count: ReqCount?

    var id: Int { id_requerimiento }
    var nombreMina: String { minas?.nombre ?? "—" }
    var nombreProveedor: String { proveedores?.nombre ?? "—" }
    var nombreSupervisor: String { supervisores?.nombre ?? "—" }
    var cantidadProductos: Int { _count?.requerimiento_detalles ?? 0 }
}

struct ReqCount: Decodable {
    let requerimiento_detalles: Int?
}

// MARK: - Requirement Detail (GET /requirements/:id)
struct RequirementDetail: Decodable, Identifiable {
    let id_requerimiento: Int
    let codigo: String
    let estado: String
    let fecha_emision: String?
    let fecha_prometida: String?
    let observaciones: String?

    let minas: MinaRef?
    let proveedores: ProveedorRefFull?
    let supervisores: SupervisorRefFull?

    // Detalles: Prisma usa "requerimiento_detalles"
    let requerimiento_detalles: [RequirementDetailItem]?

    var id: Int { id_requerimiento }
    var detalles: [RequirementDetailItem] { requerimiento_detalles ?? [] }
}

// MARK: - Requirement Detail Item
struct RequirementDetailItem: Decodable, Identifiable {
    let id_detalle: Int
    let id_producto: Int
    let cantidad_solicitada: Int
    let cantidad_entregada: Int?
    let precio_proveedor: Double
    let precio_mina: Double
    let observacion: String?

    let productos: ProductoEmbed?

    var id: Int { id_detalle }
    var nombreProducto: String { productos?.nombre ?? "—" }
    var medida: String { productos?.medidas?.descripcion ?? "—" }
    var entregado: Int { cantidad_entregada ?? 0 }
    var porcentaje: Double {
        guard cantidad_solicitada > 0 else { return 0 }
        return min(100, Double(entregado) / Double(cantidad_solicitada) * 100)
    }
}

// MARK: - Requirement Progress (GET /requirements/:id/progress)
struct RequirementProgress: Decodable {
    let id_requerimiento: Int
    let codigo: String
    let estado: String
    let porcentaje_total: Int
    let detalles: [ProductProgress]
}

struct ProductProgress: Decodable {
    let id_producto: Int
    let producto: String
    let solicitado: Int
    let entregado: Int
    let porcentaje: Int
}

// MARK: - Create Requirement Request
struct CreateRequirementRequest: Encodable {
    let id_mina: Int
    let id_proveedor: Int
    let id_supervisor: Int
    let observaciones: String?
    let fecha_prometida: String?
    let detalles: [RequirementDetailRequest]
}

struct RequirementDetailRequest: Encodable {
    let id_producto: Int
    let cantidad_solicitada: Int
    let precio_proveedor: Double
    let precio_mina: Double
    let observacion: String?
}
