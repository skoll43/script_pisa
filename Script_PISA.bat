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
REM        SECCION: INICIO DEL SERVIDOR
REM        Ejecuta el servidor Python generado y
REM        muestra información de acceso al usuario
REM ================================================
echo.
echo Iniciando servidor con mDNS:
echo ✓ mDNS transmitiendo pisa.local a la LAN
echo ✓ Acceso IP directo: http://%ip%
echo ✓ Acceso por dominio: http://pisa.local (desde cualquier dispositivo LAN)
echo.
echo Presiona Ctrl+C para detener el servidor
echo.

REM --- Ejecutar servidor existente (si existe) ---
if exist servidor_temp.py (
    echo Usando servidor existente...
    python servidor_temp.py %ip%
    call :cleanup
    goto :eof
) else (
    echo Generando nuevo servidor...
)

REM ================================================
REM        GENERACION DEL SERVIDOR PYTHON
REM        Crea dinámicamente el archivo servidor_temp.py
REM ================================================

REM --- ENCABEZADOS E IMPORTS ---
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
echo def configurar_mdns(ip): >> servidor_temp.py
echo     """Configurar mDNS apropiado usando libreria zeroconf""" >> servidor_temp.py
echo     try: >> servidor_temp.py
echo         zeroconf = Zeroconf() >> servidor_temp.py
echo         direccion_ip = socket.inet_aton(ip) >> servidor_temp.py
echo         info_servicio = ServiceInfo( >> servidor_temp.py
echo             "_http._tcp.local.", >> servidor_temp.py
echo             "pisa._http._tcp.local.", >> servidor_temp.py
echo             addresses=[direccion_ip], >> servidor_temp.py
echo             port=80, >> servidor_temp.py
echo             properties={'path': '/', 'version': '1.0'}, >> servidor_temp.py
echo             server="pisa.local." >> servidor_temp.py
echo         ) >> servidor_temp.py
echo         zeroconf.register_service(info_servicio) >> servidor_temp.py
echo         print(f"✓ Servicio mDNS registrado: pisa.local -> {ip}") >> servidor_temp.py
echo         return zeroconf, info_servicio >> servidor_temp.py
echo     except Exception as e: >> servidor_temp.py
echo         print(f"✗ Error configurando mDNS: {e}") >> servidor_temp.py
echo         return None, None >> servidor_temp.py
echo. >> servidor_temp.py

REM --- FUNCION: Seleccion de archivo HTML ---
echo def seleccionar_archivo_html(): >> servidor_temp.py
echo     """Abrir diálogo para seleccionar archivo HTML""" >> servidor_temp.py
echo     root = tk.Tk() >> servidor_temp.py
echo     root.withdraw() >> servidor_temp.py
echo     root.attributes('-topmost', True) >> servidor_temp.py
echo     directorios_posibles = [os.path.expanduser("~/Downloads"), os.path.expanduser("~/Desktop"), os.getcwd()] >> servidor_temp.py
echo     directorio_inicial = next((d for d in directorios_posibles if os.path.exists(d)), os.getcwd()) >> servidor_temp.py
echo     ruta_archivo = filedialog.askopenfilename( >> servidor_temp.py
echo         title="Seleccionar archivo HTML para servir", >> servidor_temp.py
echo         filetypes=[("Archivos HTML", "*.html"), ("Todos los archivos", "*.*")], >> servidor_temp.py
echo         initialdir=directorio_inicial >> servidor_temp.py
echo     ) >> servidor_temp.py
echo     root.destroy() >> servidor_temp.py
echo     if not ruta_archivo: >> servidor_temp.py
echo         print("Error: No se selecciono archivo. Saliendo.") >> servidor_temp.py
echo         return None, None >> servidor_temp.py
echo     return os.path.dirname(ruta_archivo), os.path.basename(ruta_archivo) >> servidor_temp.py
echo. >> servidor_temp.py

REM --- PROGRAMA PRINCIPAL ---
echo if __name__ == "__main__": >> servidor_temp.py
echo     import sys, shutil >> servidor_temp.py
echo     ip = sys.argv[1] if len(sys.argv) ^> 1 else "127.0.0.1" >> servidor_temp.py
echo     print("Seleccionar archivo HTML para servir...") >> servidor_temp.py
echo     directorio_html, archivo_html = seleccionar_archivo_html() >> servidor_temp.py
echo     if not directorio_html: >> servidor_temp.py
echo         sys.exit(1) >> servidor_temp.py
echo     print("================================================") >> servidor_temp.py
echo     print("Iniciando Servidor Portal PISA...") >> servidor_temp.py
echo     print(f"Sirviendo archivo: {archivo_html}") >> servidor_temp.py
echo     print(f"Desde directorio: {directorio_html}") >> servidor_temp.py
echo     print(f"Acceso IP directo: http://{ip}") >> servidor_temp.py
echo     print("Acceso mDNS: http://pisa.local") >> servidor_temp.py
echo     print("================================================") >> servidor_temp.py
echo     if archivo_html != "index.html": >> servidor_temp.py
echo         shutil.copy2(os.path.join(directorio_html, archivo_html), os.path.join(directorio_html, "index.html")) >> servidor_temp.py
echo         print(f"✓ Creado index.html desde {archivo_html}") >> servidor_temp.py
echo     zeroconf, info_servicio = configurar_mdns(ip) >> servidor_temp.py
echo     os.chdir(directorio_html) >> servidor_temp.py
echo     servidor = HTTPServer(("0.0.0.0", 80), SimpleHTTPRequestHandler) >> servidor_temp.py
echo     def ejecutar_servidor(): >> servidor_temp.py
echo         servidor.serve_forever() >> servidor_temp.py
echo     servidor_thread = threading.Thread(target=ejecutar_servidor, daemon=True) >> servidor_temp.py
echo     servidor_thread.start() >> servidor_temp.py
echo     print("✓ Servidor iniciado. Presiona Ctrl+C o escribe 'cerrar' para detener...") >> servidor_temp.py
echo     cerrar_servidor = False >> servidor_temp.py
echo     def monitor_entrada(): >> servidor_temp.py
echo         global cerrar_servidor >> servidor_temp.py
echo         try: >> servidor_temp.py
echo             while not cerrar_servidor: >> servidor_temp.py
echo                 comando = input().strip().lower() >> servidor_temp.py
echo                 if comando == "cerrar": >> servidor_temp.py
echo                     print("🛑 Comando 'cerrar' recibido - cerrando servidor...") >> servidor_temp.py
echo                     cerrar_servidor = True >> servidor_temp.py
echo                     break >> servidor_temp.py
echo         except EOFError: >> servidor_temp.py
echo             pass >> servidor_temp.py
echo     input_thread = threading.Thread(target=monitor_entrada, daemon=True) >> servidor_temp.py
echo     input_thread.start() >> servidor_temp.py
echo     try: >> servidor_temp.py
echo         while servidor_thread.is_alive() and not cerrar_servidor: >> servidor_temp.py
echo             time.sleep(0.1) >> servidor_temp.py
echo     except KeyboardInterrupt: >> servidor_temp.py
echo         print("\n🛑 Interrupción detectada - cerrando servidor...") >> servidor_temp.py
echo     try: >> servidor_temp.py
echo         servidor.socket.close() >> servidor_temp.py
echo     except: >> servidor_temp.py
echo         pass >> servidor_temp.py
echo     servidor.server_close() >> servidor_temp.py
echo     servidor_thread.join(timeout=0.5) >> servidor_temp.py
echo     if zeroconf and info_servicio: >> servidor_temp.py
echo         try: >> servidor_temp.py
echo             zeroconf.unregister_service(info_servicio) >> servidor_temp.py
echo             zeroconf.close() >> servidor_temp.py
echo         except: >> servidor_temp.py
echo             pass >> servidor_temp.py
echo     print("✓ Servidor cerrado completamente") >> servidor_temp.py

REM ================================================
REM        SECCION: EJECUCION FINAL
REM        Ejecuta el servidor Python y limpia archivos
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
python servidor_temp.py %ip%
call :cleanup

REM ================================================
REM                 FIN DEL SCRIPT
REM ================================================
goto :eof

REM ================================================
REM                 FUNCION LIMPIEZA
REM ================================================
:cleanup
if exist servidor_temp.py (
    del servidor_temp.py >nul 2>&1
    echo Archivo temporal eliminado.
)
exit /b
