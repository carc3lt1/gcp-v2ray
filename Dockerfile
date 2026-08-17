FROM alpine:latest

# Instalar Caddy, wget y unzip desde los repositorios oficiales
RUN apk update && \
    apk add --no-cache caddy wget unzip

# Descargar e instalar la última versión oficial de Xray-core
RUN wget -O xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip xray.zip -d /tmp/xray && \
    mv /tmp/xray/xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm -rf xray.zip /tmp/xray

# Crear directorios de configuración
RUN mkdir -p /etc/xray /etc/caddy

# Copiar los archivos de configuración del repositorio
COPY config.json /etc/xray/config.json
COPY Caddyfile /etc/caddy/Caddyfile

# Cloud Run exige la escucha en el puerto 8080
EXPOSE 8080

# Comando de ejecución dual para Caddy y Xray
CMD caddy start --config /etc/caddy/Caddyfile && xray run -c /etc/xray/config.json
