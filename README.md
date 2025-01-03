# Gestión de Gastos

Aplicación móvil desarrollada en Flutter para la gestión personal de ingresos y gastos.

## Características

- **Dashboard Principal**: Visualización rápida de balance mensual con gráficos
- **Gestión de Usuarios**: Múltiples usuarios pueden gestionar sus finanzas
- **Categorización**: Organización de ingresos y gastos por categorías personalizables
- **Frecuencias**: Seguimiento de gastos periódicos (diarios, semanales, mensuales, anuales)
- **Reportes**: Resumen mensual detallado de movimientos financieros

## Estructura del Proyecto

### Base de Datos
- SQLite como motor de base de datos local
- Tablas principales:
  - Usuarios
  - Categorías
  - Frecuencias
  - Gastos
  - Ingresos

### Modelos
- `Usuario`: Gestión de perfiles de usuarios
- `Categoria`: Clasificación de ingresos y gastos
- `Frecuencia`: Periodicidad de los gastos
- `Gasto`: Registro de egresos
- `Ingreso`: Registro de ingresos

### Repositorios
- `CategoriaRepository`: CRUD de categorías
- `FrecuenciaRepository`: CRUD de frecuencias
- `GastoRepository`: CRUD de gastos
- `IngresoRepository`: CRUD de ingresos
- `ResumenRepository`: Cálculos y reportes financieros
- `UsuarioRepository`: CRUD de usuarios

### Pantallas
- `DashboardScreen`: Vista principal con resumen y gráficos
- `UserScreen`: Gestión de usuarios
- `CategoriasScreen`: Gestión de categorías
- `FrecuenciaScreen`: Gestión de frecuencias
- `GastosScreen`: Registro y visualización de gastos
- `IngresosScreen`: Registro y visualización de ingresos
- `ResumenScreen`: Reportes detallados

## Requisitos

- Flutter SDK
- Dart SDK
- SQLite

## Dependencias Principales

- `sqflite`: Base de datos SQLite
- `fl_chart`: Visualización de gráficos
- `intl`: Formateo de fechas y números
- `path`: Manejo de rutas para la base de datos

## Configuración del Entorno

1. Clonar el repositorio
2. Ejecutar `flutter pub get` para instalar dependencias
3. Ejecutar `flutter run` para iniciar la aplicación

## Migraciones

El proyecto incluye sistema de migraciones para la base de datos:
- Versión actual: 5
- Archivo principal: `database_helper.dart`
- Scripts de migración en carpeta `migrations`

## Uso

1. Crear usuario(s)
2. Configurar categorías de ingresos y gastos
3. Registrar movimientos financieros
4. Consultar dashboard y reportes para análisis

## Características de Seguridad

- Almacenamiento local de datos
- Sin sincronización en la nube
- Acceso directo sin autenticación

## Consideraciones Técnicas

- Material Design como guía de diseño
- Arquitectura basada en repositorios
- Gestión de estado con StatefulWidget
- Manejo de formularios con validación

## Contribución

1. Fork del repositorio
2. Crear rama para feature (`git checkout -b feature/nombre`)
3. Commit cambios (`git commit -m 'Descripción del cambio'`)
4. Push a la rama (`git push origin feature/nombre`)
5. Crear Pull Request
