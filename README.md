# 📱 oFRAUD - Aplicación Móvil iOS

## 🎯 Descripción

**oFRAUD** es una aplicación móvil nativa de iOS diseñada para facilitar el reporte y gestión de incidentes de fraude y ciberseguridad. La aplicación permite a los usuarios registrar incidentes, hacer seguimiento de sus reportes, visualizar estadísticas y acceder a guías de prevención.

### Características Principales

- 🔐 Autenticación segura de usuarios
- 📝 Registro y seguimiento de incidentes
- 📊 Dashboard con estadísticas en tiempo real
- 📚 Guías de prevención y educación
- 👤 Gestión de perfil de usuario
- 🔔 Historial completo de incidentes
- 🏢 Vista organizacional de reportes
- 🔒 Política de privacidad integrada

---

## 📋 Requisitos Previos

### Requisitos del Sistema

- **macOS**: Ventura 13.0 o superior
- **Xcode**: 15.0 o superior
- **iOS**: 17.0 o superior (para dispositivos de prueba)
- **Swift**: 5.9 o superior
- **Conexión a Internet**: Requerida para conectar con el backend

### Conocimientos Necesarios

- Conocimientos básicos de Xcode
- Familiaridad con el ecosistema de Apple (opcional)
- Cuenta de Apple Developer (opcional, solo para distribución)

---

## 🚀 Instalación

### Paso 1: Clonar o Descargar el Proyecto

```bash
# Si el proyecto está en un repositorio Git:
git clone <URL_DEL_REPOSITORIO>
cd RegistroUsuarioSUI

# O simplemente descomprimir el archivo ZIP del proyecto
```

### Paso 2: Abrir el Proyecto en Xcode

1. Localiza el archivo `RegistroUsuarioSUI.xcodeproj` en el directorio del proyecto
2. Haz doble clic en el archivo `.xcodeproj` para abrir Xcode
3. Espera a que Xcode indexe el proyecto (puede tardar unos minutos)

### Paso 3: Configurar la URL del Backend

**IMPORTANTE:** Antes de ejecutar la aplicación, debes configurar la URL del servidor backend.

1. Navega a: `Settings/URLSettings.swift`
2. Localiza la estructura `APIConfig`
3. Modifica la URL base según tu entorno:

```swift
struct APIConfig {
    // Para desarrollo local:
    static let baseURL = "http://localhost:3000/api"
    
    // Para servidor de pruebas:
    // static let baseURL = "https://tu-servidor-pruebas.com/api"
    
    // Para producción:
    // static let baseURL = "https://tu-servidor-produccion.com/api"
}
```

**Nota:** Si estás probando en un dispositivo físico con un servidor local, usa la dirección IP de tu computadora en lugar de `localhost`:

```swift
static let baseURL = "http://192.168.1.100:3000/api"
```

### Paso 4: Verificar Dependencias

Este proyecto no utiliza dependencias externas (CocoaPods, SPM, etc.), por lo que no requiere instalación adicional de paquetes.

### Paso 5: Seleccionar el Destino de Compilación

1. En la barra superior de Xcode, haz clic en el menú de destino
2. Selecciona uno de los siguientes:
   - **iPhone 15** (simulador, recomendado para pruebas)
   - **iPad Pro** (simulador, si necesitas probar en tablet)
   - **Tu dispositivo físico** (si está conectado y configurado)

### Paso 6: Compilar y Ejecutar

```bash
# Opción 1: Atajo de teclado
Cmd + R

# Opción 2: Desde el menú
Product → Run

# Opción 3: Botón Play
Click en el botón ▶️ en la esquina superior izquierda
```

La aplicación se compilará y abrirá automáticamente en el simulador o dispositivo seleccionado.

---

## 🏗️ Arquitectura del Proyecto

### Estructura de Carpetas

```
RegistroUsuarioSUI/
├── RegistroUsuarioSUIApp.swift    # Punto de entrada de la app
├── ContentView.swift               # Vista raíz
│
├── Controllers/                    # Lógica de negocio
│   ├── AuthenticationController.swift
│   ├── CategoriesController.swift
│   ├── IncidentsController.swift
│   └── ProfileController.swift
│
├── DTOs/                          # Objetos de transferencia de datos
│   ├── CategoryDTO.swift
│   ├── IncidentDTO.swift
│   ├── LoginDTO.swift
│   ├── UserProfileDTO.swift
│   └── UserRegistrationDTO.swift
│
├── Extensions/                    # Extensiones de Swift
│   ├── EnvironmentExtension.swift
│   └── ValidaCampos.swift
│
├── Models/                        # Modelos de datos
│   └── ProfileObs.swift
│
├── Networking/                    # Capa de red
│   ├── CategoriesClient.swift
│   ├── Config.swift
│   ├── HTTPClient.swift
│   ├── IncidentsClient.swift
│   └── ProfileClient.swift
│
├── Screens/                       # Pantallas principales
│   ├── HomeScreen.swift
│   ├── LoginScreen.swift
│   └── UserRegistration.swift
│
├── Settings/                      # Configuraciones
│   └── URLSettings.swift
│
├── Storage/                       # Almacenamiento local
│   └── TokenStorage.swift
│
└── Views/                         # Componentes de UI
    ├── CategoryCardView.swift
    ├── CategoryDetailView.swift
    ├── DashboardView.swift
    ├── GuidesView.swift
    ├── HistorialView.swift
    ├── IncidentCardView.swift
    ├── IncidentDetailView.swift
    ├── OrganizationView.swift
    ├── PrivacyPolicyView.swift
    ├── ProfileView.swift
    ├── ReportView.swift
    ├── ResultsView.swift
    ├── StatisticsView.swift
    └── ValidationSummary.swift
```

### Patrón de Arquitectura

La aplicación sigue una arquitectura **MVC** (Model-View-Controller) con separación de responsabilidades:

- **Models**: Definen las estructuras de datos
- **Views**: Componentes de interfaz de usuario en SwiftUI
- **Controllers**: Lógica de negocio y coordinación entre la UI y el backend
- **Networking**: Capa de abstracción para comunicación HTTP
- **Storage**: Manejo de persistencia local (tokens, preferencias)

---

## 🔧 Configuración Adicional

### Configurar para Dispositivos Físicos

Si deseas probar en un iPhone o iPad físico:

1. **Conecta tu dispositivo** a la Mac mediante USB
2. **Confía en la computadora** (aparecerá un mensaje en el dispositivo)
3. En Xcode, ve a **Signing & Capabilities**
4. Selecciona tu **Team** (cuenta de Apple Developer)
5. Cambia el **Bundle Identifier** si es necesario:
   ```
   com.tu-empresa.RegistroUsuarioSUI
   ```
6. Xcode gestionará automáticamente el perfil de aprovisionamiento

### Configurar Capacidades (Capabilities)

Si el proyecto requiere capacidades especiales (notificaciones, ubicación, etc.):

1. Selecciona el proyecto en el navegador
2. Ve a la pestaña **Signing & Capabilities**
3. Haz clic en **+ Capability**
4. Agrega las capacidades necesarias

---

## 🧪 Pruebas (Testing)

### Ejecutar Pruebas Unitarias

El proyecto incluye pruebas unitarias para los Controllers:

```bash
# Ejecutar todas las pruebas
Cmd + U

# O desde el menú
Product → Test
```

### Pruebas Incluidas

- ✅ `ProfileControllerTests`: Pruebas de gestión de perfil
- ✅ `CategoriesControllerTests`: Pruebas de lectura de categorías
- ✅ `IncidentsControllerTests`: Pruebas de gestión de incidentes
- ✅ `AuthenticationControllerTests`: Pruebas de autenticación y registro

### Ver Resultados de Pruebas

1. Presiona `Cmd + 6` para abrir el **Test Navigator**
2. Verás todas las pruebas con indicadores de estado:
   - ✅ Verde = Prueba pasó
   - ❌ Rojo = Prueba falló
3. Haz clic en cualquier prueba para ver detalles

---

## 📱 Uso de la Aplicación

### Flujo de Usuario

1. **Registro**: El usuario crea una cuenta con nombre, apellido, email y contraseña
2. **Login**: Autenticación con credenciales registradas
3. **Dashboard**: Vista principal con estadísticas y accesos rápidos
4. **Reportar Incidente**: Crear nuevos reportes de fraude
5. **Historial**: Ver y dar seguimiento a incidentes reportados
6. **Estadísticas**: Visualizar métricas y tendencias
7. **Guías**: Acceder a material educativo sobre prevención
8. **Perfil**: Gestionar información personal

### Pantallas Principales

#### 1. **Login / Registro**
- Pantalla de inicio de sesión
- Opción para registrar nuevos usuarios
- Validación de campos en tiempo real

#### 2. **Dashboard**
- Resumen de incidentes
- Estadísticas rápidas
- Accesos directos a funcionalidades principales

#### 3. **Reportar Incidente**
- Formulario completo de reporte
- Selección de categoría
- Opción de reporte anónimo
- Adjuntar evidencias (opcional)

#### 4. **Historial**
- Lista de incidentes del usuario
- Estados: Pendiente, Aprobado, Rechazado
- Detalle completo de cada incidente

#### 5. **Categorías**
- Catálogo de tipos de fraude
- Información detallada por categoría
- Nivel de riesgo
- Guías de prevención

#### 6. **Estadísticas**
- Gráficos de incidentes
- Distribución por categoría
- Tendencias temporales

#### 7. **Perfil**
- Información del usuario
- Cambio de contraseña
- Cerrar sesión

---

## 🔒 Seguridad

### Almacenamiento de Tokens

La aplicación utiliza **Keychain** de iOS para almacenar de forma segura:
- Access Token (JWT)
- Refresh Token

```swift
// Ejemplo de uso interno (TokenStorage.swift)
TokenStorage.set(identifier: "accessToken", value: token)
let token = TokenStorage.get(identifier: "accessToken")
```

### Comunicación con el Backend

- Todas las peticiones usan **HTTPS** en producción
- Los tokens se envían en headers de autorización
- Validación de certificados SSL/TLS

### Mejores Prácticas Implementadas

- ✅ No se guardan contraseñas en texto plano
- ✅ Tokens con expiración automática
- ✅ Validación de entrada del usuario
- ✅ Cierre de sesión automático al expirar token
- ✅ Sanitización de datos antes de enviar al servidor

---

## 🐛 Resolución de Problemas

### Error: "Could not connect to the server"

**Causa**: El backend no está corriendo o la URL es incorrecta.

**Solución**:
1. Verifica que el backend esté ejecutándose
2. Confirma la URL en `URLSettings.swift`
3. Si usas simulador con servidor local, usa `localhost`
4. Si usas dispositivo físico, usa la IP de tu computadora

### Error: "Build Failed" al compilar

**Causa**: Problemas de configuración o código incompatible.

**Solución**:
1. Limpia el proyecto: `Cmd + Shift + K`
2. Elimina la carpeta `DerivedData`:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. Reinicia Xcode
4. Vuelve a compilar

### Error: "Signing for RegistroUsuarioSUI requires a development team"

**Causa**: No hay un equipo de desarrollo seleccionado.

**Solución**:
1. Ve a **Signing & Capabilities**
2. Marca **Automatically manage signing**
3. Selecciona tu cuenta de Apple en **Team**
4. O usa "Personal Team" si no tienes cuenta de desarrollador

### La app se cierra inmediatamente al abrirse

**Causa**: Error fatal en tiempo de ejecución, usualmente por falta de configuración.

**Solución**:
1. Revisa la **consola de Xcode** para ver el error específico
2. Verifica que la URL del backend esté configurada
3. Comprueba que todos los archivos estén incluidos en el target

### Error de red: "The resource could not be loaded"

**Causa**: Configuración de App Transport Security (ATS).

**Solución** (solo para desarrollo con HTTP):
1. Abre `Info.plist`
2. Agrega la siguiente configuración:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

**⚠️ Advertencia**: Solo usar en desarrollo, nunca en producción.

---

## 📦 Compilación para Distribución

### Crear Build de Producción

1. **Cambiar a configuración de Release**:
   - Product → Scheme → Edit Scheme
   - En "Run", cambia Build Configuration a **Release**

2. **Actualizar la URL del backend** a producción en `URLSettings.swift`

3. **Archivar la app**:
   ```
   Product → Archive
   ```

4. **Distribuir**:
   - Espera a que termine el proceso de archivado
   - Se abrirá el **Organizer**
   - Selecciona el archivo creado
   - Click en **Distribute App**
   - Elige el método de distribución:
     - **App Store Connect** (para publicar en la App Store)
     - **Ad Hoc** (para distribuir a testers específicos)
     - **Enterprise** (si tienes cuenta Enterprise)

### Preparar para App Store

1. **Crear el app en App Store Connect**
2. **Configurar metadata**: descripción, capturas, íconos
3. **Subir el build** desde Xcode Organizer
4. **Enviar para revisión** de Apple

---

## 🔄 Actualización y Mantenimiento

### Actualizar Dependencias

Este proyecto no tiene dependencias externas, por lo que no requiere actualización de paquetes.

### Actualizar Versión de la App

1. Selecciona el proyecto en el navegador de Xcode
2. En **General**, actualiza:
   - **Version**: Número de versión (ej: 1.0.0 → 1.1.0)
   - **Build**: Número de compilación (ej: 1 → 2)

### Compatibilidad con Nuevas Versiones de iOS

Cuando salga una nueva versión de iOS:

1. Actualiza Xcode a la última versión
2. Prueba la app en el simulador de la nueva versión
3. Revisa warnings de deprecación
4. Actualiza código deprecated si es necesario

---

## 📚 Recursos Adicionales

### Documentación Oficial

- [Swift Documentation](https://swift.org/documentation/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Xcode Documentation](https://developer.apple.com/documentation/xcode)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios)

### Tutoriales Recomendados

- [Hacking with Swift](https://www.hackingwithswift.com/)
- [Swift by Sundell](https://www.swiftbysundell.com/)
- [Ray Wenderlich](https://www.raywenderlich.com/ios)

---

## 📞 Soporte

Para reportar problemas o solicitar ayuda:

- **Issues**: [URL del repositorio de issues]
- **Email**: [email de soporte]
- **Documentación**: [URL de documentación adicional]

---

## ✨ Agradecimientos

Gracias a todos los que contribuyeron al desarrollo de esta aplicación.

---

**Versión del README**: 1.0  
**Última actualización**: Octubre 2025  
**Autores**: Santiago Niño, Gabriel Gutiérrez, Omar Llano, Alejandro Vargas

**Versión de la App**: 1.0.0
