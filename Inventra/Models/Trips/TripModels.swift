import Foundation

// MARK: - Trip List (GET /viajes)
// Schema: id_viaje, id_requerimiento, numero_viaje, numero_vale,
// etiqueta_viaje, fecha_salida, fecha_ingreso, placa_vehiculo, conductor, observaciones
struct Trip: Decodable, Identifiable {
    let id_viaje: Int
    let id_requerimiento: Int
    let numero_viaje: Int
    let numero_vale: String?
    let etiqueta_viaje: String?
    let fecha_salida: String?
    let fecha_ingreso: String?
    let placa_vehiculo: String?
    let conductor: String?
    let observaciones: String?

    let requerimientos: RequerimientoRef?

    var id: Int { id_viaje }
    var displayTitle: String { etiqueta_viaje ?? "Viaje #\(numero_viaje)" }
}

// MARK: - Trip Detail (GET /viajes/:id)
struct TripDetail: Decodable, Identifiable {
    let id_viaje: Int
    let id_requerimiento: Int
    let numero_viaje: Int
    let numero_vale: String?
    let etiqueta_viaje: String?
    let fecha_salida: String?
    let fecha_ingreso: String?
    let placa_vehiculo: String?
    let conductor: String?
    let observaciones: String?

    let viaje_detalles: [TripDetailItem]?
    let requerimientos: RequerimientoRefFull?

    var id: Int { id_viaje }
    var detalles: [TripDetailItem] { viaje_detalles ?? [] }
}

// MARK: - Trip Detail Item
// Schema: id_viaje_detalle, es_extra, cantidad_recibida, estado_entrega
// viaje_detalles_estado_entrega: OK | RECHAZADO | PARCIAL | MUESTRA | DAÑADO
struct TripDetailItem: Decodable, Identifiable {
    let id_viaje_detalle: Int
    let es_extra: Bool?
    let cantidad_recibida: Int
    let estado_entrega: String?

    let productos: ProductoEmbed?
    let medidas: MedidaBase?

    var id: Int { id_viaje_detalle }
    var nombreProducto: String { productos?.nombre ?? "—" }
    var descripcionMedida: String { medidas?.descripcion ?? productos?.medidas?.descripcion ?? "—" }

    var estadoDisplay: String {
        switch estado_entrega {
        case "OK":        return "Conforme"
        case "RECHAZADO": return "Rechazado"
        case "PARCIAL":   return "Parcial"
        case "MUESTRA":   return "Muestra"
        case "DAÑADO":    return "Dañado"
        default:          return estado_entrega ?? "—"
        }
    }
}
