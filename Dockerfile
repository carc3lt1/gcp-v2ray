# --- ETAPA 1: Compilador (Builder) ---
# Usamos la imagen oficial de V2Fly para obtener los binarios
FROM v2fly/v2fly-core:v5.1.0 AS builder


# --- ETAPA 2: Final ---
# Usamos una de las imágenes base más pequeñas que existen: Alpine
FROM alpine:3.19

# Instalar certificados raíz, necesarios para conexiones seguras (buena práctica)
RUN apk add --no-cache ca-certificates

# Crear el directorio para la configuración y un usuario sin privilegios
RUN mkdir -p /etc/v2ray && \
    adduser -D -h /home/v2rayuser v2rayuser

# Copiar SOLO los binarios necesarios desde la etapa del 'builder'
COPY --from=builder /usr/bin/v2ray/v2ray /usr/bin/v2ray
COPY --from=builder /usr/bin/v2ray/v2ctl /usr/bin/v2ctl

# Copiar el archivo de configuración y asignar permisos
COPY --chown=v2rayuser:v2rayuser config.json /etc/v2ray/config.json

# Cambiar al usuario sin privilegios
USER v2rayuser

# Exponer el puerto
EXPOSE 8080

# Comando de ejecución
CMD ["/usr/bin/v2ray", "run", "-config", "/etc/v2ray/config.json"]
