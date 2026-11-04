# Evidencias — Recetario UTEZ

**Nombre:** Ximena Pulido Gutiérrez
**Matrícula:** I20233TN125
**Fecha:** 3 de noviembre de 2026
**Dispositivo donde se probó:** Windows (desktop)

## 1. Del JSON a Dart

| JSON | Campo Dart | Tipo | Regla (obligatorio, tolerado, valor por defecto) |
|---|---|---|---|
| id | id | int | Obligatorio |
| name | nombre | String | Obligatorio |
| cuisine | cocina | String | Obligatorio |
| difficulty | dificultad | Dificultad | Tolerado (Dificultad.desconocida si es nulo o inválido) |
| prepTimeMinutes | minutosPreparacion | int | Obligatorio |
| cookTimeMinutes | minutosCoccion | int | Obligatorio |
| servings | porciones | int | Obligatorio |
| rating | calificacion | double | Obligatorio (acepta entero o decimal y se convierte a double) |
| tags | etiquetas | List<String> | Tolerado (lista vacía [] por defecto) |
| ingredients | ingredientes | List<String> | Tolerado (lista vacía [] por defecto) |

## 2. Escenarios probados con el servicio real

| Escenario | Cómo lo provoqué | Qué vio la persona | Línea de la bitácora | Captura | Prueba del kit que lo cubre |
|---|---|---|---|---|---|
| Éxito | Búsqueda de "chicken" | Lista de tarjetas con las recetas encontradas | `[http] ← 200 GET /recipes/search (736 ms)` | capturas/01_exito.png | DummyJsonRepositorio 200 → PaginaRecetas |
| Vacío | Búsqueda de "zzzz" | Mensaje: No encontramos recetas para "zzzz". | `[http] ← 200 GET /recipes/search (772 ms)` | capturas/02_vacio.png | DummyJsonRepositorio 200 sin resultados → página vacía |
| Error del servidor | Interceptor temporal A (`o.path = '/http/503'`) | Mensaje: El recetario no está disponible (503). Intenta más tarde. | `[http] ✗ badResponse 503 GET /http/503 (740 ms)` | capturas/03_servidor.png | DummyJsonRepositorio 503 → ErrorDelServidor(503) |
| Sin red | Interceptor C / Modo avión | Mensaje: Sin conexión. Revisa tu red e intenta de nuevo. | `[http] ✗ connectionError GET /http/503 (31 ms)` | capturas/04_sin_red.png | DummyJsonRepositorio sin red → SinConexion |
| Tiempo agotado | Interceptor B (`delay: 5000` y timeouts a 2s) | Mensaje: El recetario tardó demasiado en responder. Intenta de nuevo. | `[http] ✗ connectionTimeout GET /recipes/search (2080 ms)` | capturas/05_timeout.png | DummyJsonRepositorio receiveTimeout → TiempoAgotado |

## 3. Preguntas de reflexión

1. **¿En qué se diferencian el escenario "Error del servidor" y "Sin red" desde el punto de vista de HTTP?**  
   En "Error del servidor" existe una conexión exitosa a nivel de red (TCP/TLS) y la petición llega al servidor, pero este responde explícitamente con un código de estado HTTP (como 503). En "Sin red", la petición HTTP nunca llega a enviarse ni a conectar con ningún servidor, ya que el fallo ocurre localmente en el dispositivo del cliente (nivel socket/interfaz de red).

2. **¿Por qué "Vacío" no es un error?**  
   Porque la comunicación HTTP concluye con un código 200 OK y el servidor responde con una estructura JSON totalmente válida que contiene una lista sin elementos (`"recipes": []`). Es un resultado válido de una búsqueda sin coincidencias, no un fallo en el transporte ni en el servidor.

3. **La búsqueda de la persona viaja en la query. ¿Por qué tu bitácora no la escribe?**  
   Por seguridad y privacidad: en las consultas URL pueden transmitirse parámetros sensibles, tokens de autenticación o datos personales. La bitácora registra `options.path` en lugar de `options.uri` para omitir los `queryParameters` de la cadena de registro.

4. **Si DummyJSON cambiara `rating` por `score`, ¿qué archivos tendrías que modificar y por qué solo esos?**  
   Únicamente `lib/datos/recetas_json.dart`. Gracias a la separación en capas de la arquitectura limpia, ni la entidad del dominio (`Receta`) ni las tarjetas/vistas de la interfaz dependen de las claves del JSON original. Solo el deserializador de la capa de datos necesita cambiar la propiedad que lee del Map (`json['score']`).