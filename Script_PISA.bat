@echo off
REM ================================================
REM              SCRIPT PISA PORTAL
REM ================================================
echo ================================================
echo       Configuracion Portal PISA con mDNS
echo ================================================
echo.

REM ================================================
REM        SECCION: DETECCION DE INTERFACES
REM        Muestra las interfaces de red disponibles
REM        y solicita al usuario la IP a utilizar
REM ================================================
echo Detectando interfaces de red...
echo.
echo Direcciones IPv4 Disponibles:
echo ----------------------------------------
ipconfig | findstr /C:"Ethernet" /C:"Wi-Fi" /C:"Wireless" /C:"IPv4"
echo ----------------------------------------
echo.
echo Selecciona la direccion IP de tu red principal:
echo - Para WiFi: Normalmente 192.168.x.x o 10.x.x.x
echo - Para Ethernet: Normalmente 192.168.x.x o 192.168.1.x
echo - Evitar: 169.254.x.x (auto-config) o 127.x.x.x (loopback)
echo.
set /p ip="Ingresa tu direccion IP: "
echo.

REM ================================================
REM        SECCION: INSTALACION DEPENDENCIAS
REM        Instala las librerías Python necesarias
REM        para el funcionamiento del servidor mDNS
REM ================================================
echo ================================================
echo Creando servidor Python con soporte mDNS...
echo ================================================
echo Instalando libreria zeroconf para mDNS apropiado...
pip install zeroconf --quiet
echo.

REM ================================================
REM        SECCION: GENERACION SERVIDOR PYTHON
REM        Crea dinámicamente un archivo Python que
REM        actúa como servidor HTTP con soporte mDNS
REM ================================================
REM --- Creando archivo temporal del servidor ---
echo import socket > servidor_temp.py
echo from zeroconf import ServiceInfo, Zeroconf >> servidor_temp.py
echo import threading >> servidor_temp.py
echo from http.server import HTTPServer, SimpleHTTPRequestHandler >> servidor_temp.py
echo import os >> servidor_temp.py
echo import time >> servidor_temp.py
echo import tkinter as tk >> servidor_temp.py
echo from tkinter import filedialog, messagebox >> servidor_temp.py
echo. >> servidor_temp.py

REM --- FUNCION: Configuracion mDNS ---
REM     Registra el servicio en la red local como 'pisa.local'
REM     Permite acceso por nombre en lugar de IP
echo def configurar_mdns(ip): >> servidor_temp.py
echo     """Configurar mDNS apropiado usando libreria zeroconf""" >> servidor_temp.py
echo     zeroconf = Zeroconf() >> servidor_temp.py
echo     direccion_ip = socket.inet_aton(ip) >> servidor_temp.py
echo.     >> servidor_temp.py
echo     # Registrar servicio HTTP >> servidor_temp.py
echo     info_servicio = ServiceInfo( >> servidor_temp.py
echo         "_http._tcp.local.", >> servidor_temp.py
echo         "Portal PISA._http._tcp.local.", >> servidor_temp.py
echo         addresses=[direccion_ip], >> servidor_temp.py
echo         port=80, >> servidor_temp.py
echo         properties={}, >> servidor_temp.py
echo         server="pisa.local." >> servidor_temp.py
echo     ) >> servidor_temp.py
echo.     >> servidor_temp.py
echo     zeroconf.register_service(info_servicio) >> servidor_temp.py
echo     print(f"✓ Servicio mDNS registrado: pisa.local -> {ip}") >> servidor_temp.py
echo     return zeroconf, info_servicio >> servidor_temp.py
echo. >> servidor_temp.py

REM --- FUNCION: Seleccion de archivo HTML ---
REM     Abre un diálogo para que el usuario seleccione
REM     el archivo HTML a servir en el portal
echo def seleccionar_archivo_html(): >> servidor_temp.py
echo     """Abrir diálogo para seleccionar archivo HTML""" >> servidor_temp.py
echo     root = tk.Tk() >> servidor_temp.py
echo     root.withdraw()  # Ocultar ventana principal >> servidor_temp.py
echo     root.attributes('-topmost', True)  # Traer al frente >> servidor_temp.py
echo.     >> servidor_temp.py
echo     # Buscar directorio inicial apropiado >> servidor_temp.py
echo     directorio_inicial = None >> servidor_temp.py
echo     directorios_posibles = [ >> servidor_temp.py
echo         os.path.expanduser("~/Downloads"), >> servidor_temp.py
echo         os.path.expanduser("~/Desktop"), >> servidor_temp.py
echo         os.path.expanduser("~/Documents"), >> servidor_temp.py
echo         os.path.expanduser("~"), >> servidor_temp.py
echo         os.getcwd() >> servidor_temp.py
echo     ] >> servidor_temp.py
echo.     >> servidor_temp.py
echo     for directorio in directorios_posibles: >> servidor_temp.py
echo         if os.path.exists(directorio): >> servidor_temp.py
echo             directorio_inicial = directorio >> servidor_temp.py
echo             break >> servidor_temp.py
echo.     >> servidor_temp.py
echo     ruta_archivo = filedialog.askopenfilename( >> servidor_temp.py
echo         title="Seleccionar archivo HTML para servir", >> servidor_temp.py
echo         filetypes=[("Archivos HTML", "*.html"), ("Todos los archivos", "*.*")], >> servidor_temp.py
echo         initialdir=directorio_inicial >> servidor_temp.py
echo     ) >> servidor_temp.py
echo.     >> servidor_temp.py
echo     if not ruta_archivo: >> servidor_temp.py
echo         messagebox.showerror("Error", "No se selecciono archivo. Saliendo.") >> servidor_temp.py
echo         root.destroy() >> servidor_temp.py
echo         return None, None >> servidor_temp.py
echo.     >> servidor_temp.py
echo     directorio_html = os.path.dirname(ruta_archivo) >> servidor_temp.py
echo     archivo_html = os.path.basename(ruta_archivo) >> servidor_temp.py
echo     root.destroy() >> servidor_temp.py
echo     return directorio_html, archivo_html >> servidor_temp.py
echo. >> servidor_temp.py

REM --- PROGRAMA PRINCIPAL ---
REM     Coordina la selección de archivo, configuración mDNS
REM     e inicio del servidor HTTP en el puerto 80
echo if __name__ == "__main__": >> servidor_temp.py
echo     import sys >> servidor_temp.py
echo     ip = sys.argv[1] if len(sys.argv) ^> 1 else "127.0.0.1" >> servidor_temp.py
echo.     >> servidor_temp.py
echo     print("Seleccionar archivo HTML para servir...") >> servidor_temp.py
echo     directorio_html, archivo_html = seleccionar_archivo_html() >> servidor_temp.py
echo     if not directorio_html: >> servidor_temp.py
echo         sys.exit(1) >> servidor_temp.py
echo.     >> servidor_temp.py
echo     print("================================================") >> servidor_temp.py
echo     print("Iniciando Servidor Portal PISA...") >> servidor_temp.py
echo     print("================================================") >> servidor_temp.py
echo     print(f"Sirviendo archivo: {archivo_html}") >> servidor_temp.py
echo     print(f"Desde directorio: {directorio_html}") >> servidor_temp.py
echo     print(f"Acceso IP directo: http://{ip}") >> servidor_temp.py
echo     print("Acceso mDNS: http://pisa.local") >> servidor_temp.py
echo     print("================================================") >> servidor_temp.py
echo.     >> servidor_temp.py
echo     # Copiar archivo seleccionado como index.html >> servidor_temp.py
echo     import shutil >> servidor_temp.py
echo     archivo_origen = os.path.join(directorio_html, archivo_html) >> servidor_temp.py
echo     archivo_index = os.path.join(directorio_html, "index.html") >> servidor_temp.py
echo     if archivo_html != "index.html": >> servidor_temp.py
echo         shutil.copy2(archivo_origen, archivo_index) >> servidor_temp.py
echo         print(f"✓ Creado index.html desde {archivo_html}") >> servidor_temp.py
echo.     >> servidor_temp.py
echo     # Configurar servicio mDNS >> servidor_temp.py
echo     try: >> servidor_temp.py
echo         zeroconf, info_servicio = configurar_mdns(ip) >> servidor_temp.py
echo     except Exception as e: >> servidor_temp.py
echo         print(f"Fallo configuracion mDNS: {e}") >> servidor_temp.py
echo         print("Continuando sin mDNS...") >> servidor_temp.py
echo         zeroconf = None >> servidor_temp.py
echo.     >> servidor_temp.py
echo     # Iniciar servidor HTTP >> servidor_temp.py
echo     os.chdir(directorio_html) >> servidor_temp.py
echo     servidor = HTTPServer(("0.0.0.0", 80), SimpleHTTPRequestHandler) >> servidor_temp.py
echo.     >> servidor_temp.py
echo     try: >> servidor_temp.py
echo         servidor.serve_forever() >> servidor_temp.py
echo     except KeyboardInterrupt: >> servidor_temp.py
echo         print("\\nCerrando servidor...") >> servidor_temp.py
echo         if zeroconf: >> servidor_temp.py
echo             zeroconf.unregister_service(info_servicio) >> servidor_temp.py
echo             zeroconf.close() >> servidor_temp.py
echo         servidor.shutdown() >> servidor_temp.py

REM ================================================
REM        SECCION: INICIO DEL SERVIDOR
REM        Ejecuta el servidor Python generado y
REM        muestra información de acceso al usuario
REM ================================================
echo.
echo Iniciando servidor con mDNS:
echo ✓ mDNS transmitiendo pisa.local a la LAN
echo ✓ Acceso IP directo: http://%ip%
echo ✓ Acceso por dominio: http://pisa.local (desde cualquier dispositivo)
echo.
echo Presiona Ctrl+C para detener el servidor
echo.

REM --- Ejecutar servidor y limpiar archivo temporal ---
REM     Inicia el servidor Python y limpia archivos temporales al finalizar
python servidor_temp.py %ip%
del servidor_temp.py

REM ================================================
REM                 FIN DEL SCRIPT
REM ================================================
