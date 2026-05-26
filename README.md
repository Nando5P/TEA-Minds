**TEA-Minds** es una aplicación multiplataforma diseñada para la estimulación de procesos cognitivos en niños con Trastorno del Espectro Autista (TEA). El proyecto ofrece un entorno seguro donde **Tutores** y **Especialistas** pueden gestionar perfiles infantiles y monitorizar su progreso a través de actividades gamificadas y adaptativas.

## 🚀 Estado del Desarrollo (Mayo 2026)
Actualmente, el proyecto se encuentra en la **Fase de Desarrollo de Juegos, Interfaz Accesible y Analítica**. Los hitos alcanzados son:
* **Infraestructura y Autenticación**: Conexión con Firebase, registro por roles (Tutor/Especialista) y PIN de seguridad parental.
* **Gestión de Perfiles**: Dashboard operativo con creación, desvinculación y visualización de "pollitos" en tiempo real. Los avatares se generan dinámicamente mapeando el color hexadecimal seleccionado a *assets* gráficos locales con efectos visuales optimizados (halos translúcidos).
* **Estimulación Matemática**: Motor de cálculo mental adaptativo interactivo. Incorpora herramientas pedagógicas avanzadas activables en tiempo real mediante interruptores (*toggles*):
  * **Ayuda por colores:** Diferenciación visual automática de unidades (azul) y decenas/centenas (rojo) mediante parsing de texto.
  * **Regletas Cuisenaire:** Renderizado algorítmico de bloques matemáticos apilables de forma responsiva (`Wrap` y `ConstrainedBox`), proporcionales en tamaño y con colores estandarizados internacionalmente.
* **Minimalismo Sensorial**: UI/UX rediseñada sin sobrecargas visuales ni ruidos cognitivos, implementando iconografía nativa del sistema mediante `flutter_launcher_icons`.

🔗 **Repositorio oficial:** [https://github.com/Nando5P/TEA-Minds.git](https://github.com/Nando5P/TEA-Minds.git)

---

## 🏗️ Arquitectura del Software
Se ha implementado una **Arquitectura Limpia (Clean Architecture)** para asegurar un código profesional, escalable y fácil de mantener:

1. **DOMAIN**: El núcleo de la lógica pura. Contiene las **Entities** (clases puras como `UserApp` y `Child`) y las interfaces de los repositorios.
2. **DATA**: Implementación técnica de **Firebase** (Firestore/Auth), repositorios reales y modelos con lógica de mapeo y serialización (`fromJson`/`toJson` y factorías).
3. **PRESENTATION**: Gestión de estado reactiva mediante el patrón **BLoC/Cubit** e interfaz de usuario diseñada para evitar sobrecargas sensoriales, aislando completamente la lógica de negocio de la vista.

### 📂 Estructura de Carpetas (`lib/`)
```text
lib/
├── core/             # Configuración base y utilidades compartidas.
├── data/             # Capa de datos (Models y Repositories Impl).
├── domain/           # Capa de dominio (Entities y Repositories Interface).
├── models/           # Constantes visuales globales (TEAColors.dart).
├── presentation/     # Capa visual (Blocs y Pages).
└── main.dart         # Punto de entrada de la aplicación.
````
---

¡Aquí tienes la sección exacta, Nando! Lista para copiar y pegar:

Markdown
## 📊 Modelo de Datos (Cloud Firestore)

La base de datos NoSQL se estructura en tres colecciones principales que permiten una sincronización en tiempo real y un diseño jerárquico flexible y escalable (Schemaless):

### Colección: `users` (Tutores / Especialistas)
* **ID**: `UID` único generado por Firebase Auth.
* **Campos**: 
    * `nombreCompleto`: (string) Nombre del tutor o especialista.
    * `email`: (string) Correo electrónico de acceso.
    * `rol`: (string) Rol asignado (Tutor/Especialista).
    * `pinSeguridad`: (string) PIN de 4 dígitos para control parental y bloqueo de salida.

### Colección: `children` (Perfiles Infantiles)
* **ID**: Automático generado por Firestore.
* **Campos**:
    * `nombre`: (string) Nombre del niño/a.
    * `tutor_ids`: (array de strings) Lista de UIDs de los tutores asignados (Relación M:N).
    * `color`: (string) Código Hexadecimal (ej. `#f8bbd0`) para el avatar y la UI personalizada.
    * `tiene_gafas`: (bool) Atributo visual latente para el personaje, preparado para futura personalización.
    * `created_at`: (timestamp) Fecha de creación para ordenación en el Dashboard.

### Colección: `sessions` (Motor Analítico)
* **ID**: Automático generado por Firestore.
* **Campos**:
    * `child_id`: (string) Referencia al perfil del niño.
    * `game_type`: (string) Tipo de actividad (ej. "matematicas").
    * `aciertos`: (number) Cantidad de respuestas correctas.
    * `fallos`: (number) Cantidad de respuestas incorrectas.
    * `timestamp`: (timestamp) Fecha y hora exacta de la actividad para gráficas de evolución pedagógica.

---

## 🛠️ Stack Tecnológico
* **Framework**: Flutter (Dart) con compilación nativa ARM.
* **Backend**: Firebase (Auth & Cloud Firestore Serverless).
* **Gestión de Estado**: BLoC / Cubit.
* **Diseño y Recursos**: Iconografía nativa automatizada vía `flutter_launcher_icons`.
* **Entorno**: Visual Studio Code.

---
**Alumno**: Fernando Parga Fernández  
**Centro**: I.E.S. Fernando Wirtz Suárez  
**Curso**: DAM2 - 2025-2026
