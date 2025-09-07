import socket 
from zeroconf import ServiceInfo, Zeroconf 
import threading 
from http.server import HTTPServer, SimpleHTTPRequestHandler 
import os 
import time 
import tkinter as tk 
from tkinter import filedialog, messagebox 
 
def configurar_mdns(ip): 
    """Configurar mDNS apropiado usando libreria zeroconf""" 
    zeroconf = Zeroconf() 
    direccion_ip = socket.inet_aton(ip) 
     
    # Registrar servicio HTTP 
    info_servicio = ServiceInfo( 
        "_http._tcp.local.", 
        "Portal PISA._http._tcp.local.", 
        addresses=[direccion_ip], 
        port=80, 
        properties={}, 
        server="pisa.local." 
    ) 
     
    zeroconf.register_service(info_servicio) 
    print(f"✓ Servicio mDNS registrado: pisa.local -> {ip}") 
    return zeroconf, info_servicio 
 
def seleccionar_archivo_html(): 
    """Abrir diálogo para seleccionar archivo HTML""" 
    root = tk.Tk() 
    root.withdraw()  # Ocultar ventana principal 
    root.attributes('-topmost', True)  # Traer al frente 
     
    # Buscar directorio inicial apropiado 
    directorio_inicial = None 
    directorios_posibles = [ 
        os.path.expanduser("~/Downloads"), 
        os.path.expanduser("~/Desktop"), 
        os.path.expanduser("~/Documents"), 
        os.path.expanduser("~"), 
        os.getcwd() 
    ] 
     
    for directorio in directorios_posibles: 
        if os.path.exists(directorio): 
            directorio_inicial = directorio 
            break 
     
    ruta_archivo = filedialog.askopenfilename( 
        title="Seleccionar archivo HTML para servir", 
        filetypes=[("Archivos HTML", "*.html"), ("Todos los archivos", "*.*")], 
        initialdir=directorio_inicial 
    ) 
     
    if not ruta_archivo: 
        messagebox.showerror("Error", "No se selecciono archivo. Saliendo.") 
        root.destroy() 
        return None, None 
     
    directorio_html = os.path.dirname(ruta_archivo) 
    archivo_html = os.path.basename(ruta_archivo) 
    root.destroy() 
    return directorio_html, archivo_html 
 
if __name__ == "__main__": 
    import sys 
    ip = sys.argv[1] if len(sys.argv) > 1 else "127.0.0.1" 
     
    print("Seleccionar archivo HTML para servir...") 
    directorio_html, archivo_html = seleccionar_archivo_html() 
    if not directorio_html: 
        sys.exit(1) 
     
    print("================================================") 
    print("Iniciando Servidor Portal PISA...") 
    print("================================================") 
    print(f"Sirviendo archivo: {archivo_html}") 
    print(f"Desde directorio: {directorio_html}") 
    print(f"Acceso IP directo: http://{ip}") 
    print("Acceso mDNS: http://pisa.local") 
    print("================================================") 
     
    # Copiar archivo seleccionado como index.html 
    import shutil 
    archivo_origen = os.path.join(directorio_html, archivo_html) 
    archivo_index = os.path.join(directorio_html, "index.html") 
    if archivo_html != "index.html": 
        shutil.copy2(archivo_origen, archivo_index) 
        print(f"✓ Creado index.html desde {archivo_html}") 
     
    # Configurar servicio mDNS 
    try: 
        zeroconf, info_servicio = configurar_mdns(ip) 
    except Exception as e: 
        print(f"Fallo configuracion mDNS: {e}") 
        print("Continuando sin mDNS...") 
        zeroconf = None 
     
    # Iniciar servidor HTTP 
    os.chdir(directorio_html) 
    servidor = HTTPServer(("0.0.0.0", 80), SimpleHTTPRequestHandler) 
     
    try: 
        servidor.serve_forever() 
    except KeyboardInterrupt: 
        print("\\nCerrando servidor...") 
        if zeroconf: 
            zeroconf.unregister_service(info_servicio) 
            zeroconf.close() 
        servidor.shutdown() 
