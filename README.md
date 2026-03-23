# TEA-Minds: Neuro-estimulación con Pollitos 🐥

**TEA-Minds** es una aplicación multiplataforma diseñada para la estimulación de procesos cognitivos en niños con Trastorno del Espectro Autista (TEA). El proyecto ofrece un entorno seguro donde **Tutores** y **Especialistas** pueden gestionar perfiles infantiles y monitorizar su progreso a través de actividades gamificadas.

## 🚀 Estado del Desarrollo (Marzo 2026)
Actualmente, el proyecto se encuentra en la **Fase de Gestión de Perfiles y Persistencia**. Los hitos alcanzados son:
* **Infraestructura**: Conexión con Firebase y arquitectura base configurada.
* **Autenticación**: Sistema de registro y login funcional por roles (Tutor/Especialista).
* **Gestión de Niños**: Dashboard operativo con creación y visualización de "pollitos" en tiempo real.

🔗 **Repositorio oficial:** [https://github.com/Nando5P/TEA-Minds.git](https://github.com/Nando5P/TEA-Minds.git)

---

## 🏗️ Arquitectura del Software
Se ha implementado una **Arquitectura Limpia (Clean Architecture)** para asegurar un código profesional, escalable y fácil de mantener:

1.  **DOMAIN**: El núcleo de la lógica. Contiene las **Entities** (clases puras como `UserApp` y `Child`) y las interfaces de los repositorios.
2.  **DATA**: Implementación técnica de **Firebase** (Firestore/Auth), repositorios reales y modelos con lógica de mapeo (`fromMap`/`toMap`).
3.  **PRESENTATION**: Gestión de estado mediante el patrón **BLoC/Cubit** y una interfaz diseñada para evitar ruidos visuales y priorizar la accesibilidad cognitiva.

### 📂 Estructura de Carpetas Actual (`lib/`)
```text
lib/
├── core/             # Configuración base y utilidades compartidas.
├── data/             # Capa de datos (Models y Repositories Impl).
├── domain/           # Capa de dominio (Entities y Repositories Interface).
├── models/           # Constantes visuales globales (TEAColors.dart).
├── presentation/     # Capa visual (Blocs y Pages).
└── main.dart         # Punto de
````
---

## 📊 Modelo de Datos (Cloud Firestore)

### Colección: `users`
* **ID**: `UID` generado por Firebase Auth.
* **Campos**: 
    * `nombreCompleto`: (string) Nombre del tutor o especialista.
    * `email`: (string) Correo electrónico de acceso.
    * `rol`: (string) Rol asignado (Tutor/Especialista).
    * `pinSeguridad`: (string) PIN de 4 dígitos para control parental.

### Colección: `children`
* **ID**: Automático generado por Firestore.
* **Campos**:
    * `nombre`: (string) Nombre del niño/a.
    * `tutor_id`: (string) UID del tutor que creó el perfil.
    * `color`: (string) Código Hexadecimal para el avatar personalizado.
    * `tiene_gafas`: **(bool)** Atributo visual para el personaje (pollito).
    * `created_at`: (timestamp) Fecha de creación para ordenación en el Dashboard.

---

## 📝 Metodología de Documentación
El proyecto sigue un proceso de documentación continua:

* **Memoria Técnica**: Actualización periódica de objetivos, planificación y presupuesto en la documentación oficial del módulo.
* **Comentarios de Código**: Uso de estándares de Dart para documentar la lógica de negocio y facilitar el mantenimiento.
* **Control de Versiones**: Gestión de cambios y evolución del software mediante commits descriptivos en GitHub.
* **Asistencia Técnica**: Validación de patrones de diseño y depuración mediante herramientas de IA avanzada.

---

## 🛠️ Stack Tecnológico
* **Framework**: Flutter (Dart).
* **Backend**: Firebase (Auth & Firestore).
* **Gestión de Estado**: BLoC / Cubit.
* **Entorno**: VS Code.

---
**Alumno**: Fernando Parga Fernández  
**Centro**: I.E.S. Fernando Wirtz Suárez
