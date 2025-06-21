# 🏥 Farmacias El Sol — App Móvil

![Farmacias El Sol Banner](https://images.pexels.com/photos/4021779/pexels-photo-4021779.jpeg)

> Aplicación móvil que permite consultar medicamentos, escanear recetas, ver farmacias cercanas y generar recordatorios, sin realizar compras.

## 📑 Tabla de Contenidos

- [🌟 Descripción del Proyecto](#descripción-del-proyecto)
- [⚡ Funcionalidades](#funcionalidades)
- [🛠️ Tecnologías Utilizadas](#tecnologías-utilizadas)
- [📁 Estructura del Proyecto](#estructura-del-proyecto)
- [🚀 Instrucciones de Instalación](#instrucciones-de-instalación)
- [🗺️ Roadmap](#roadmap)
- [📄 Licencia](#licencia)
- [👤 Autor](#autor)

## 🌟 Descripción del Proyecto

Farmacias El Sol es una aplicación móvil diseñada para facilitar la gestión y consulta de información farmacéutica. Desarrollada para Android e iOS utilizando Flutter, la aplicación permite a los usuarios encontrar medicamentos, gestionar recetas y configurar recordatorios, todo desde la comodidad de su dispositivo móvil.

## ⚡ Funcionalidades

- 🔍 **Búsqueda de Medicamentos**
  - Búsqueda por nombre, categoría o principio activo
  - Información detallada de cada medicamento
  - Guía de uso y contraindicaciones

- 📍 **Localización de Farmacias**
  - Mapa interactivo con farmacias cercanas
  - Información de horarios y disponibilidad
  - Direcciones y rutas optimizadas

- 📱 **Escaneo de Recetas**
  - Digitalización mediante OCR
  - Almacenamiento seguro de recetas
  - Historial de medicamentos recetados

- ⏰ **Sistema de Recordatorios**
  - Alertas personalizables
  - Seguimiento de tratamientos
  - Notificaciones push configurables

- 👥 **Gestión de Perfiles**
  - Soporte para múltiples usuarios
  - Perfiles para dependientes
  - Historial médico personalizado

## 🛠️ Tecnologías Utilizadas

- **Frontend:**
  - Flutter
  - Dart
  - Material Design

- **Backend:**
  - Node.js + Express
  - RESTful APIs

- **Base de Datos:**
  - Firebase Realtime Database
  - Cloud Firestore

- **Servicios:**
  - Firebase Authentication
  - Google Maps API
  - Firebase Cloud Messaging
  - Google ML Kit (OCR)


# Estructura del Proyecto: farmacias-el-sol

```
farmacias-el-sol/
├── lib/
│   ├── pantallas/
│   │   ├── inicio/
│   │   ├── buscar/
│   │   ├── mapa/
│   │   ├── perfil/
│   │   └── ajustes/
│   ├── componentes/
│   │   ├── común/
│   │   └── widgets/
│   ├── servicios/
│   │   ├── api/
│   │   ├── auth/
│   │   └── almacenamiento/
│   └── utilidades/
├── recursos/
│   ├── imágenes/
│   └── iconos/
├── prueba/
└── documentos/
```


## 🚀 Instrucciones de Instalación

1. **Clonar el repositorio**
   \`\`\`bash
   git clone https://github.com/username/farmacias-el-sol.git
   cd farmacias-el-sol
   \`\`\`

2. **Instalar dependencias**
   \`\`\`bash
   flutter pub get
   \`\`\`

3. **Configurar variables de entorno**
   \`\`\`bash
   cp .env.example .env
   # Editar .env con tus credenciales
   \`\`\`

4. **Ejecutar la aplicación**
   \`\`\`bash
   flutter run
   \`\`\`

## 🗺️ Roadmap

1. **Q1 2024**
   - ✅ Módulo de búsqueda básica
   - ✅ Integración de mapas
   - 🔄 Sistema de recordatorios

2. **Q2 2024**
   - 📋 Integración con farmacias para stock
   - 📱 Mejoras en el escáner de recetas
   - 👥 Soporte multiusuario

3. **Q3 2024**
   - 🔄 Sistema de notificaciones avanzado
   - 🌐 Expansión a nuevas regiones
   - 📊 Analytics y reportes

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE.md](LICENSE.md) para más detalles.

## 👤 Autor

**Fernando Troncoso Ortiz**
- GitHub: [@fernandotroncoso](https://github.com/fernandotroncoso)
- LinkedIn: [Fernando Troncoso](https://linkedin.com/in/fernandotroncoso)

---

<p align="center">
  Desarrollado con ❤️ por el equipo de Farmacias El Sol
</p>
