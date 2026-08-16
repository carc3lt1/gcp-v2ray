# 1. Usar Alpine Linux estable como base
# Alpine es ultraligero y nos permite instalar múltiples paquetes a medida.
FROM alpine:latest

# 2. Instalar el Proxy Inverso (Caddy) y el Motor VLESS (Xray)
# Xray es un fork optimizado de V2Ray, 100% compatible con tu config.json actual.
RUN apk update && \
    apk add --no-cache xray caddy

# 3. Crear directorios para las configuraciones
RUN mkdir -p /etc/xray /etc/caddy

# 4. Copiar los archivos de configuración desde tu repositorio
# Cloud Run gestiona su propio aislamiento de seguridad (gVisor sandbox), 
# por lo que podemos usar el usuario por defecto del contenedor de forma segura.
COPY config.json /etc/xray/config.json
COPY Caddyfile /etc/caddy/Caddyfile

# 5. Exponer el puerto 8080 (Requisito estricto de Google Cloud Run)
EXPOSE 8080

# 6. Definir el comando para ejecutar ambos servicios
# Inicia Caddy en segundo plano como escudo frontal y Xray en primer plano.
# Si el DPI de Claro escanea el puerto 8080, Caddy responderá con el HTTP 302.
CMD caddy start --config /etc/caddy/Caddyfile && xray -c /etc/xray/config.json
