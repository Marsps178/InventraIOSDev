# 01 - Autenticación y Usuarios (Auth)

Estos endpoints son la puerta de entrada para la aplicación iOS. Todas las demás rutas de la aplicación requerirán que el usuario envíe su `accessToken` obtenido aquí.

## 1. Login
**`POST /api/auth/login`**

*   **Descripción:** Autentica a un usuario y le entrega tokens de seguridad.
*   **Body (JSON):**
    ```json
    {
      "username": "admin",
      "password": "contraseña_segura"
    }
    ```
*   **Response (200 OK - JSON):**
    ```json
    {
      "status": "success",
      "data": {
        "accessToken": "eyJhbG...",
        "refreshToken": "def502...",
        "user": {
          "id_usuario": 1,
          "username": "admin",
          "rol": "ADMIN",
          "id_mina": null,
          "nombre": "Administrador",
          "apellidos": "Sistema"
        }
      }
    }
    ```
*   **Implementación Swift:** Almacenar `accessToken` en *Keychain*. Enviar en `URLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")`.

---

## 2. Refrescar Token
**`POST /api/auth/refresh`**

*   **Descripción:** Cuando el `accessToken` (15 mins) expira, envía el `refreshToken` (7 días) para obtener uno nuevo sin pedirle al usuario su contraseña de nuevo.
*   **Body (JSON):**
    ```json
    {
      "refreshToken": "def502..."
    }
    ```
*   **Response (200 OK):** Devuelve un nuevo `accessToken` y `refreshToken`.

---

## 3. Obtener Mi Perfil (Me)
**`GET /api/users/me`**

*   **Descripción:** Permite a la app iOS descargar la información completa del perfil del usuario (ideal para mostrar en la pestaña "Configuración/Perfil" de la app).
*   **Headers:** `Authorization: Bearer <accessToken>`
*   **Response (200 OK):** Objeto de usuario completo.
