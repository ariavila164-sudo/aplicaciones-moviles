# Dolores AR

App turística con realidad aumentada para visitar Dolores Hidalgo, desarrollada
paso a paso con TDD a partir del *Manual TDD de Realidad Aumentada*.

## Qué incluye

- **Dominio puro (Dart, sin Flutter):** Haversine, rumbo inicial, manejo del
  salto 359°/0°, campo de visión, motor de RA, catálogo y pasaporte turístico.
- **Contratos de datos:** `FuentePosicion` y `FuenteBrujula`, con
  implementaciones reales (GPS + brújula) y simuladas (modo demo).
- **Presentación:** ViewModel observable, fondo de cámara con degradado de
  respaldo, etiquetas de RA, panel de estado, detalle de lugares y pantalla de
  modelo 3D (`model_viewer_plus`).
- **Persistencia:** el pasaporte guarda solo los IDs de lugares visitados con
  `shared_preferences`; no se guardan coordenadas.
- **Privacidad:** pantalla de aviso dentro de la app y procesamiento local.
- **Recuperación de errores:** botones para reintentar y abrir los ajustes de
  ubicación o permisos.
- **Contenido local:** ícono propio y campana 3D en `assets/modelos/campana.glb`,
  sin depender de internet ni de licencias de terceros.
- **Seguridad:** permiso de ubicación solo en uso, aviso de seguridad física,
  mensajes de error sin detalles internos y modo demo sin GPS.

## Estructura

```
lib/
  dominio/       geo, lugar, catálogo, motor_ar, pasaporte, almacén, fuentes
  datos/         fuentes reales/simuladas, almacén de preferencias, ajustes
  presentacion/  viewmodel, cámara, pantalla AR, inicio, privacidad y modelo 3D
test/
  geo_test.dart, motor_ar_test.dart, pasaporte_test.dart,
  ar_viewmodel_test.dart, ayudas_geo.dart
tool/
  generar_icono.py      genera assets/icon/*.png
  generar_campana.py    genera assets/modelos/campana.glb
```

## Pruebas

```bash
flutter test
flutter analyze
```

Las **47 pruebas** cubren distancia, rumbo, ángulos, campo de visión, motor de
RA, sellos del pasaporte, persistencia, ViewModel, reintentos, suavizado de
brújula y manejo seguro de errores.

## Ejecutar

```bash
flutter pub get
flutter run
```

Para probar la RA completa usa un teléfono real (cámara + brújula). En el salón
de clases o en un emulador, entra a **Modo demo**: te teletransporta a la Plaza
Principal y el deslizador "Gira" simula la brújula.

## Regenerar recursos

```bash
python3 tool/generar_icono.py
python3 tool/generar_campana.py
dart run flutter_launcher_icons
```

El modelo 3D es una malla propia; para iPhone habría que exportar una versión
`.usdz` y pasarla con `iosSrc` en `PantallaModelo3D`.
