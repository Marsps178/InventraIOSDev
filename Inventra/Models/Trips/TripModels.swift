import Foundation

// MARK: - Trip List
struct Trip: Decodable, Identifiable {
    let id_viaje: Int
    let codigo_viaje: String
    let estado: String // EN_TRANSITO, FINALIZADO
    let fecha_llegada: String?
    let placa_vehiculo: String?
    
    var id: Int { id_viaje }
}

// MARK: - Trip Detail
struct TripDetail: Decodable, Identifiable {
    let id_viaje: Int
    let guia_remision: String?
    let detalles: [TripDetailItem]?
    
    var id: Int { id_viaje }
}

struct TripDetailItem: Decodable, Identifiable {
    let producto: ProductoBase
    let cantidad_enviada: Int
    let estado_entrega: String // OK, DAÑADO
    
    var id: String { producto.nombre }
}
