import Foundation

// MARK: - Dispatch List (GET /despachos)
struct Dispatch: Decodable, Identifiable {
    let id_despacho: Int
    let codigo: String
    let estado: String
    let fecha_creacion: String?
    let fecha_salida: String?
    let fecha_entrega: String?
    let observaciones: String?
    let numero_vale: String?

    let minas: MinaRef?
    let supervisores: SupervisorRef?
    let despacho_detalles: [DispatchDetailItem]?

    var id: Int { id_despacho }
    var nombreMina: String { minas?.nombre ?? "—" }
    var cantidadProductos: Int { despacho_detalles?.count ?? 0 }

    var estadoDisplay: String {
        switch estado {
        case "PREPARANDO":    return "Preparando"
        case "EN_TRANSITO":   return "En Tránsito"
        case "ENTREGADO":     return "Entregado"
        case "ANULADO":       return "Anulado"
        default:              return estado
        }
    }
}

// MARK: - Dispatch Detail (GET /despachos/:id)
struct DispatchDetail: Decodable, Identifiable {
    let id_despacho: Int
    let codigo: String
    let estado: String
    let observaciones: String?
    let fecha_creacion: String?
    let fecha_salida: String?
    let fecha_entrega: String?
    let numero_vale: String?

    let minas: MinaRefFull?
    let supervisores: SupervisorRefFull?
    let viajes: ViajeRefFull?
    let despacho_detalles: [DispatchDetailItem]?

    var id: Int { id_despacho }
    var detalles: [DispatchDetailItem] { despacho_detalles ?? [] }
}

struct ViajeRefFull: Decodable {
    let id_viaje: Int?
    let numero_viaje: Int?
    let placa_vehiculo: String?
    let conductor: String?
}

// MARK: - Dispatch Detail Item
struct DispatchDetailItem: Decodable, Identifiable {
    let id_despacho_detalle: Int
    let id_producto: Int
    let id_medida: Int
    let cantidad_despachada: Int
    let observacion: String?

    let productos: ProductoEmbed?
    let medidas: MedidaDispatchEmbed?

    var id: Int { id_despacho_detalle }
    var nombreProducto: String { productos?.nombre ?? "—" }
    var descripcionMedida: String { medidas?.descripcion ?? productos?.medidas?.descripcion ?? "—" }
}

struct MedidaDispatchEmbed: Decodable {
    let id_medida: Int?
    let descripcion: String?
}

// MARK: - Requests

struct DispatchDeliveryRequest: Encodable {
    let fecha_entrega: String?
    init(fechaEntrega: String? = nil) { self.fecha_entrega = fechaEntrega }
}

struct DispatchTransitRequest: Encodable {
    let fecha_salida: String?
    init(fechaSalida: String? = nil) { self.fecha_salida = fechaSalida }
}

struct AnularDespachoRequest: Encodable {
    let motivo_anulacion: String
}
