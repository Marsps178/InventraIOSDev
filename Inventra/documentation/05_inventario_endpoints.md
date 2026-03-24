# 05 - Inventario y Tablas Maestras

Para poder llenar listados (List/Picker en SwiftUI), crear órdenes nuevas, o simplemente para que un supervisor o ingeniero de mina sepa si hay material antes de pedirlo.

## 1. Consultar Stock (Kardex Simplificado)
**`GET /api/inventory/stock`**

*   **Descripción:** Buscador nativo de existencias. Súper útil para el campo.
*   **Query Params sugeridos:**
    *   `?search=POSTE`
    *   `?id_medida=3`
*   **Response (200 OK):**
    ```json
    {
      "status": "success",
      "data": {
        "data": [
          {
            "producto": "POSTES",
            "medida": "1.80 MTS x 8",
            "clasificacion": "Oregón",
            "stock_actual": 1500
          }
        ],
        "pagination": { ... }
      }
    }
    ```

---

## 2. Catálogo de Productos (Para formulario de Pedidos)
**`GET /api/products`**

*   **Descripción:** Devuelve la lista maestra de productos que un usuario puede seleccionar en el Picker de `RequirementCreateView`.
*   **Persistencia iOS:** Idealmente cacheado en memoria `SwiftData` en el inicio (App Launch) para no hacer este Request repetidamente, ya que los productos no cambian a diario.
*   **Response (200 OK):**
    ```json
    {
      "status": "success",
      "data": {
        "data": [
          {
            "id_producto": 10,
            "nombre": "POSTES",
            "medida": { "id_medida": 2, "descripcion": "1.80 MTS x 8" }
          }
        ],
        "pagination": { "total": 45 }
      }
    }
    ```

---

## 3. Listado de Minas (Destinos)
**`GET /api/mines`**

*   **Descripción:** Para asignar el destino de un Requerimiento.
*   **Persistencia iOS:** También se sugiere guardarlo en local Database/Cache.
*   **Response (200 OK):** Lista de minas habilitadas (`estado=ACTIVO`).
