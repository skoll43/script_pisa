# 🌐 Portal PISA - Lanzador de Red Local

Una solución simple y portable para hacer tu portal HTML accesible a través de toda tu red local mediante mDNS.

## ✨ Características

- **🔧 Configuración Cero**: Solo ejecuta y funciona - no necesita configuración del router
- **📡 Transmisión mDNS**: Accede vía `http://pisa.local` desde cualquier dispositivo
- **🎯 Selector de Archivos**: Diálogo visual para seleccionar cualquier archivo HTML
- **🌍 Universal**: Funciona en cualquier PC Windows, cualquier red
- **🔄 Portable**: Solución de un solo archivo - no requiere instalación

## 🚀 Inicio Rápido

1. **Descarga** uno de los scripts:
   - `Script_PISA.bat` 

2. **Ejecuta como Administrador** (para acceso al puerto 80)

3. **Selecciona tu IP** de las interfaces de red mostradas

4. **Elige tu archivo HTML** mediante el diálogo selector de archivos

5. **Accede desde cualquier dispositivo** en tu red:
   - `http://pisa.local` (mDNS - funciona en teléfonos, tablets, computadoras)
   - `http://tu.direccion.ip` (Acceso directo por IP)

## 🎯 Perfecto Para

- **Portales de Pruebas PISA** - Acceso fácil para evaluaciones educativas


## 🔧 Cómo Funciona

1. **Auto-instala** la librería Python `zeroconf` para mDNS apropiado
2. **Registra** el servicio `pisa.local` a través de tu LAN
3. **Sirve** tu archivo HTML seleccionado como página predeterminada
4. **Transmite** disponibilidad a todos los dispositivos de la red

## 📋 Requisitos

- PC Windows con Python instalado
- Conexión de red (WiFi o Ethernet)
- Privilegios de administrador (para puerto 80)

## 🌟 ¿Por qué mDNS?

Las soluciones tradicionales requieren:
- ❌ Configuración DNS del router
- ❌ Editar archivo hosts en cada dispositivo
- ❌ Compartir direcciones IP manualmente

Nuestra solución proporciona:
- ✅ **Configuración cero** - funciona inmediatamente
- ✅ **Acceso universal** - cualquier dispositivo, cualquier plataforma
- ✅ **Fácil de recordar** - solo escribe `pisa.local`
- ✅ **Auto-descubrimiento** - los dispositivos lo encuentran automáticamente

## 🔒 Nota de Seguridad

Esta herramienta está diseñada para **uso en red local únicamente**. El servidor se vincula a todas las interfaces (`0.0.0.0`) para accesibilidad LAN pero no debe exponerse a internet.

## 📝 Ejemplo de Caso de Uso

```
Asistente con su notebook: Ejecuta script
Sin tipear las URL: Simplemente escriben http://pisa.local en los PC de estudiantes
Resultado: Acceso instantáneo al launcher
```

## 🛠️ Detalles Técnicos

- **Servidor HTTP Python** con `SimpleHTTPRequestHandler`
- **Zeroconf mDNS** para descubrimiento de servicios
- **GUI Tkinter** para selección de archivos
- **Rutas multiplataforma** usando `os.path.expanduser()`
- **Respaldos robustos** para directorios faltantes

---

*Hecho con ❤️*
