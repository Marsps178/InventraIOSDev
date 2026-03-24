import Foundation

// MARK: - Dispatch List
struct Dispatch: Decodable, Identifiable {
    let id_despacho: Int
    let codigo: String
    let estado: String // EN_TRANSITO, ENTREGADO
    let mina: MinaBase?
    let total_productos: Int
    
    var id: Int { id_despacho }
}

// MARK: - Dispatch Detail
struct DispatchDetail: Decodable, Identifiable {
    let id_despacho: Int
    let codigo: String
    let estado: String
    let observacion: String?
    let detalles: [DispatchDetailItem]?
    
    var id: Int { id_despacho }
}

struct DispatchDetailItem: Decodable, Identifiable {
    let id_detalle: Int
    let cantidad: Int
    let producto: ProductoBase
    
    var id: Int { id_detalle }
}

// MARK: - Mark as Delivered
struct DispatchDeliveryRequest: Encodable {
    let fecha_entrega: String
    let comentarios_mina: String
}
