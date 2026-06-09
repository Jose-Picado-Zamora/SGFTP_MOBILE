# SGFTP Mobile — Fundación Tamarindo Park

Aplicación móvil Android construida con Flutter que actúa como cliente del sistema SGFTP.

## Requisitos
- Flutter 3.x con Dart SDK ≥ 3.0
- Android Studio o VS Code con extensión Flutter
- Emulador Android 8.0+ (API 26) o dispositivo físico

## Estructura del proyecto
```
lib/
├── data/
│   ├── models/          # Proyecto, Actividad, Voluntario
│   └── repositories/    # SgftpRepository (simula API REST desde JSON)
├── presentation/
│   ├── screens/         # 7 pantallas
│   └── widgets/         # Widgets reutilizables
├── theme/               # Tema Material Design 3 (#1A237E)
├── router.dart          # Rutas con go_router
└── main.dart
assets/
└── data/
    └── db.json          # Datos simulados (reemplazar por llamadas Dio cuando la API esté lista)
```

## Instalación
```bash
flutter pub get
flutter run
```

## Generar APK
```bash
flutter build apk --release
# Salida: build/app/outputs/flutter-apk/app-release.apk
```

## Migración a API real
Cuando el backend SGFTP esté disponible, en `lib/data/repositories/sgftp_repository.dart`:
1. Reemplaza `rootBundle.loadString(...)` por llamadas `Dio` a los endpoints.
2. Agrega el header `Authorization: Bearer <token>` en cada petición.
3. Mantén los mismos métodos públicos — las pantallas no requieren cambios.

## Pantallas implementadas
| Ruta | Pantalla |
|------|----------|
| `/` | Dashboard |
| `/proyectos` | Lista de Proyectos (búsqueda + filtro estado) |
| `/proyectos/:id` | Detalle de Proyecto + botón a Actividades |
| `/proyectos/:id/actividades` | Lista de Actividades (filtro estado + DateRange) |
| `/actividades/:id` | Detalle de Actividad + chips de Voluntarios |
| `/voluntarios` | Lista de Voluntarios (búsqueda por nombre/cédula) |
| `/voluntarios/:id` | Perfil de Voluntario + proyectos + actividades |
