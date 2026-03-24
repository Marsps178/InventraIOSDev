# 02 - Requerimientos

Los requerimientos son creados por el personal de la MINA y aprobados por LOGÍSTICA/ADMINISTRADORES para iniciar los viajes.

## 1. Listar Requerimientos
**`GET /api/requirements`**

*   **Descripción:** Devuelve los pedidos generados.
*   **Filtros Opcionales (Query Params):** 
    *   `?search=REQ-2026-0001` (Buscar por código)
    *   `?estado=PENDIENTE` (PENDIENTE, APROBADO, PARCIAL, COMPLETADO)
    *   `?id_mina=2` (Para filtrar los de una mina en específico)
    *   `?page=1&limit=20` (Paginación)
*   **Response (200 OK - JSON):**
    ```json
    {
      "status": "success",
      "data": {
        "data": [
          {
            "id_requerimiento": 1,
            "codigo": "REQ-2026-0001",
            "mina": { "nombre": "Mina Esperanza" },
            "estado": "PENDIENTE",
            "porcentaje_entrega": 0
          }
        ],
        "pagination": { "page": 1, "total": 150 }
      }
    }
    ```

---

## 2. Detalle del Requerimiento
**`GET /api/requirements/:id`**

*   **Descripción:** Retorna el detalle completo, incluyendo todos los ítems solicitados, para la vista `RequirementDetailView` en iOS.
*   **Response (200 OK):**
    ```json
    {
      "status": "success",
      "data": {
        "id_requerimiento": 1,
        "codigo": "REQ-2026-0001",
        "detalles": [
          {
            "id_detalle": 10,
            "producto": { "nombre": "POSTES" },
            "medida_solicitada": "1.80 MTS x 8",
            "cantidad_solicitada": 500,
            "cantidad_recibida": 100
          }
        ]
      }
    }
    ```

---

## 3. Crear Requerimiento
**`POST /api/requirements`**

*   **Descripción:** Enviar un pedido nuevo desde el celular.
*   **Body (JSON):**
    ```json
    {
      "id_mina": 1,
      "id_proveedor": 2,
      "id_supervisor": 3,
      "detalles": [
        {
          "id_producto": 10,
          "cantidad_solicitada": 50
        }
      ]
    }
    ```
