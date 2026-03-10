# TEA-Minds: Neuro-estimulación con Pollitos 🐥

**TEA-Minds** es una aplicación móvil diseñada para la estimulación cognitiva de niños con Trastorno del Espectro Autista (TEA). El proyecto establece un ecosistema seguro donde **Tutores** y **Especialistas** pueden monitorizar el progreso del menor a través de la gamificación con un personaje personalizable.

## 🚀 Propuesta de Valor
* **Gamificación Adaptada**: Interfaz diseñada para las necesidades sensoriales y cognitivas del niño.
* **Sincronización en Red**: Vinculación en tiempo real entre el entorno familiar y el profesional.
* **Seguridad Avanzada**: "Modo Niño" blindado mediante PIN y privacidad estricta de datos.

---

## 🏗️ Arquitectura del Software (Clean Architecture)

Para garantizar un desarrollo escalable, profesional y fácil de testear, se ha implementado una **Arquitectura Limpia** organizada en capas de responsabilidad:

### 1. Capa de DOMAIN (El "Qué")
Es el núcleo de la aplicación, independiente de cualquier tecnología externa o framework.
* **Entities**: Definición de clases puras (User, Child, Session).
* **Repositories Interface**: Contratos que definen cómo debe comportarse la obtención de datos.

### 2. Capa de DATA (El "Cómo")
Gestiona la comunicación con servicios externos y la persistencia.
* **Models**: Objetos con lógica de mapeo (JSON/Map) para Firebase y APIs.
* **Sources**: Implementación técnica de Firebase (Firestore/Auth) y servicios de red (API ARASAAC).
* **Repositories**: Ejecución real de los contratos definidos en la capa de Domain.

### 3. Capa de FEATURES / PRESENTATION (Vistas)
Organización modular orientada a funcionalidades para facilitar la expansión de mini-juegos.
* **Auth**: Módulo de registro y gestión de roles (Tutor/Especialista).
* **Games**: Catálogo de actividades (Igualar imágenes, Matemáticas, etc.).
* **Dashboard**: Paneles de control diferenciados según el rol de usuario.

---

## 📂 Estructura de Carpetas (lib/)

```text
lib/
├── core/                # Constantes, temas visuales y componentes globales.
├── domain/              # Lógica de negocio pura (Entidades e Interfaces).
│   └── entities/        # Clases base (User, Child, Session).
├── data/                # Implementación de datos y persistencia.
│   ├── models/          # Modelos con toMap() y fromMap().
│   └── sources/         # Conectores de Firebase y APIs.
├── features/            # Módulos y funcionalidades de la app.
│   ├── auth/            # Registro, Login y Gestión de Roles.
│   ├── dashboard/       # Paneles de gestión de perfiles.
│   └── games/           # Carpeta raíz de mini-juegos escalables.
└── main.dart            # Configuración de arranque y servicios.
````
---

## 📊 Diseño de la Base de Datos (Cloud Firestore)

### Colección: `users`
* **ID**: `UID` (Proporcionado por Firebase Auth).
* **Campos**:
    * `nombre_completo`: (string) Nombre del tutor o especialista.
    * `email`: (string) Correo electrónico de acceso.
    * `rol`: (string) "tutor" o "especialista".
    * `pin_seguridad`: (string) Hash del PIN de 4 dígitos para control parental.
    * `lista_ninos`: (array) Referencias a los documentos de la colección 'ninos'.

### Colección: `ninos`
* **ID**: Automático (Generado por Firestore).
* **Campos**:
    * `id_publico`: (string) Código único de 8 caracteres (ej: #1aVt77aJ).
    * `nombre`: (string) Nombre del niño.
    * `tutor_principal`: (string) UID del usuario creador.
    * `especialistas`: (array) UIDs de profesionales autorizados.
    * `config_avatar`: (map) Atributos visuales: {color: string, accesorio: string}.


---

## 🔒 Lógica de Seguridad y Persistencia

### Unicidad del ID Público
Para evitar colisiones de datos y asegurar que el vínculo entre especialista y niño sea correcto, el sistema implementa un flujo de verificación por existencia:
* **Generación**: Creación aleatoria de un ID alfanumérico de 8 caracteres.
* **Consulta**: Validación asíncrona en Firestore para confirmar que el código no existe previamente en la base de datos.
* **Validación**: Registro del perfil solo tras garantizar la exclusividad del ID en toda la plataforma.

### Persistencia de Sesión Automatizada
La aplicación utiliza la persistencia nativa de Firebase Auth para mantener la sesión abierta tras el cierre del proceso. Esto permite que el niño acceda al entorno de juego de forma inmediata, evitando que el tutor deba introducir credenciales complejas en cada uso.

### Control Parental (PIN)
La salida del entorno gamificado requiere la validación de un PIN de 4 dígitos. Este PIN se almacena de forma segura en Firestore para permitir el control parental y la gestión de la configuración desde cualquier dispositivo vinculado del tutor.

---

## 🛠️ Stack Tecnológico
* **Framework**: Flutter (Dart)
* **Backend**: Firebase (Auth & Firestore)
* **API Externa**: ARASAAC (REST API para Pictogramas con intercambio de datos en formato JSON)
* **Persistencia Local**: Hive / Sqflite (Para cumplir con el requerimiento de persistencia en el dispositivo)
* **Testing**: Implementación de una estrategia de Unit y Widget Testing para asegurar la solvencia del software

---
**Responsable Técnico**: Fernando Parga Fernández
