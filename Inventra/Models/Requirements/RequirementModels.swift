import Foundation

// MARK: - Requirement List
struct Requirement: Decodable, Identifiable {
    let id_requerimiento: Int
    let codigo: String
    let mina: MinaBase?
    let estado: String // PENDIENTE, APROBADO, PARCIAL, COMPLETADO
    let porcentaje_entrega: Int
    
    var id: Int { id_requerimiento }
}

// MARK: - Requirement Detail
struct RequirementDetail: Decodable, Identifiable {
    let id_requerimiento: Int
    let codigo: String
    let detalles: [RequirementDetailItem]?
    
    var id: Int { id_requerimiento }
}

struct RequirementDetailItem: Decodable, Identifiable {
    let id_detalle: Int
    let producto: ProductoBase
    let medida_solicitada: String
    let cantidad_solicitada: Int
    let cantidad_recibida: Int
    
    var id: Int { id_detalle }
}

// MARK: - Create Requirement
struct CreateRequirementRequest: Encodable {
    let id_mina: Int
    let id_proveedor: Int
    let id_supervisor: Int
    let detalles: [RequirementDetailRequest]
}

struct RequirementDetailRequest: Encodable {
    let id_producto: Int
    let cantidad_solicitada: Int
}
