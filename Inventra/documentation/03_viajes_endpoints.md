# 03 - Viajes (Logística)

Los viajes representan el transporte (camión) físico de la madera hacia un destino. Son clave para el módulo del Conductor o Logística en la app.

## 1. Listar Viajes
**`GET /api/viajes`**

*   **Descripción:** Lista el histórico logístico de camiones en ruta o completados.
*   **Filtros (Query Params):**
    *   `?search=REQ-2026-0001-V1` (Buscar por código de viaje)
    *   `?estado=EN_TRANSITO` (o FINALIZADO)
    *   `?fecha_inicio=2026-01-01`
*   **Response (200 OK):**
    ```json
    {
      "status": "success",
      "data": {
        "data": [
          {
            "id_viaje": 5,
            "codigo_viaje": "REQ-2026-0001-V1",
            "estado": "FINALIZADO",
            "fecha_llegada": "2026-02-16T21:04:18Z",
            "placa_vehiculo": "ABC-123"
          }
        ],
        "pagination": { ... }
      }
    }
    ```

---

## 2. Detalle de Carga del Viaje
**`GET /api/viajes/:id`**

*   **Descripción:** Obtiene los productos físicos (manifiesto de carga) que van en ese viaje en específico. Ideal para que el conductor o el almacenero tengan su check-list digital.
*   **Response (200 OK):**
    ```json
    {
      "status": "success",
      "data": {
        "id_viaje": 5,
        "guia_remision": "001-000456",
        "detalles": [
          {
            "producto": { "nombre": "MARCHABANTES" },
            "cantidad_enviada": 150,
            "estado_entrega": "OK"
          }
        ]
      }
    }
    ```
