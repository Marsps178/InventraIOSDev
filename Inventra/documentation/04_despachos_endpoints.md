# 04 - Despachos (Entrega en Mina)

Los despachos son probablemente la funcionalidad más importante para el personal en la Mina con la aplicación iOS. Un despacho representa la entrega física de madera en el destino.

## 1. Listar Despachos en Tránsito
**`GET /api/despachos?estado=EN_TRANSITO`**

*   **Descripción:** Usado en la mina para ver qué camiones están por llegar y listar las entregas que requieren confirmación física o revisión.
*   **Filtros Clave:** `estado=EN_TRANSITO`, `id_mina=2`
*   **Response (200 OK):**
    ```json
    {
      "status": "success",
      "data": {
        "data": [
          {
            "id_despacho": 1,
            "codigo": "DSP-2026-0001",
            "estado": "EN_TRANSITO",
            "mina": { "nombre": "ESPERANZA" },
            "total_productos": 100
          }
        ],
        "pagination": { ... }
      }
    }
    ```

---

## 2. Detalle del Despacho (Manifiesto de Recepción)
**`GET /api/despachos/:id`**

*   **Descripción:** Carga los productos exactos que trae ese despacho en específico, para que el operador de mina verifique las cantidades.
*   **Response (200 OK):**
    ```json
    {
      "id_despacho": 1,
      "codigo": "DSP-2026-0001",
      "estado": "EN_TRANSITO",
      "observacion": "Confirmado por logistica",
      "detalles": [
        {
          "id_detalle": 15,
          "cantidad": 100,
          "producto": {
            "nombre": "POSTES",
            "medida": { "descripcion": "1.80 MTS x 8" }
          }
        }
      ]
    }
    ```

---

## 3. Marcar como Entregado o Recibido
**`PUT /api/despachos/:id/entregar`** (o `PATCH`)

*   **Descripción:** Una vez el usuario de iPhone valida matemáticamente y visualmente la madera en la mina, presiona "Confirmar Entrega". Esto emite un request al backend que efectúa la rebaja del Kardex y finaliza la operación.
*   **Body (JSON):**
    ```json
    {
      "fecha_entrega": "2026-03-24T10:00:00Z",
      "comentarios_mina": "Todo OK, sin daños observados."
    }
    ```
*   **Response (200 OK):** Despacho actualizado a `ENTREGADO`.
