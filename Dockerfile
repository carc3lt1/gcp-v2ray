# 1. Usar una versión específica en lugar de 'latest'
# Esto asegura que tus compilaciones sean predecibles y no se rompan con actualizaciones inesperadas.
# Revisa en Docker Hub cuál es la última versión estable de teddysun/v2ray.
FROM teddysun/v2ray:5.15.1

# 2. Crear un usuario sin privilegios para ejecutar la aplicación
# Ejecutar como 'root' en un contenedor es un riesgo de seguridad.
RUN adduser -D -h /home/v2rayuser v2rayuser

# 3. Copiar la configuración y establecer el propietario correcto
# La bandera --chown establece directamente el usuario y grupo del archivo.
COPY --chown=v2rayuser:v2rayuser config.json /etc/v2ray/config.json

# 4. Cambiar al usuario sin privilegios
# A partir de este punto, todos los comandos se ejecutan como 'v2rayuser'.
USER v2rayuser

# 5. Exponer el puerto (es una buena práctica de documentación)
EXPOSE 8080

# 6. Definir el comando para ejecutar el servidor
CMD ["v2ray", "run", "-config", "/etc/v2ray/config.json"]

# join telegram https://t.me/ragnarservers  for new updates 
# my telegram username is @Not_Ragnar
