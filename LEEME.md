# NodeBridge – Gestor S.I.G.S.M. y Portal informativo (Hospital de Clínicas)

Este repositorio contiene el sistema completo, listo para probar en una computadora con XAMPP:

- `nodebridge-gestor/` → gestor interno (intranet) S.I.G.S.M., hecho en PHP.
- `portal-informativo/` → portal público para pacientes (HTML, CSS y JS).
- `portal-backend/` → backend PHP del portal.
- `respaldo.sql` → base de datos completa (crea `sigsm` y `portal_informativo`).

Las tres carpetas vienen comprimidas en un archivo `.zip` dentro del repositorio.

## Qué necesitás antes de empezar

- [XAMPP](https://www.apachefriends.org/) instalado (Apache, MySQL y phpMyAdmin). Con PHP 8 o superior.
- [Git](https://git-scm.com/downloads) instalado, o bien descargar el repositorio como ZIP desde GitHub.
- Un programa para descomprimir `.zip` (el propio Windows alcanza).

## Instalación paso a paso

### 1. Iniciar XAMPP

1. Abrir el **Panel de control de XAMPP**.
2. Presionar **Start** en **Apache** y en **MySQL**. Los dos deben quedar en verde.

### 2. Descargar el repositorio

1. Entrar al repositorio en GitHub.
2. Presionar el botón verde **Code** y copiar el enlace HTTPS (termina en `.git`).
3. Abrir una terminal (PowerShell o CMD) y ejecutar:

```
cd C:\xampp\htdocs
git clone ENLACE_QUE_COPIASTE
```

Se crea una carpeta con el nombre del repositorio dentro de `C:\xampp\htdocs\`.

> Si no usás Git: en GitHub, **Code → Download ZIP**, y descomprimir el resultado dentro de `C:\xampp\htdocs\`.

### 3. Descomprimir y mover las carpetas

1. Entrar a la carpeta del repositorio que se acaba de crear.
2. Descomprimir el archivo `.zip` que contiene las tres carpetas.
3. **Mover** las carpetas `nodebridge-gestor`, `portal-informativo` y `portal-backend` directamente a `C:\xampp\htdocs\`.

Al terminar, `C:\xampp\htdocs\` tiene que verse así:

```
C:\xampp\htdocs\
├── nodebridge-gestor\
├── portal-informativo\
└── portal-backend\
```

Importante: las tres tienen que estar **sueltas** en `htdocs`, no dentro de otra carpeta. Si quedan adentro de otra, las direcciones del paso 6 no van a funcionar.

### 4. Importar la base de datos

1. Abrir **http://localhost/phpmyadmin**.
2. No hace falta crear nada antes: el archivo crea las bases solo. Entrar a la pestaña **Importar** (en la pantalla principal, sin elegir ninguna base).
3. Presionar **Seleccionar archivo** y elegir `respaldo.sql` (está en la carpeta del repositorio).
4. Dejar las opciones como vienen y presionar **Importar** al final de la página.
5. Cuando termine, en la columna izquierda tienen que aparecer dos bases nuevas: `sigsm` y `portal_informativo`.

Se puede volver a importar `respaldo.sql` las veces que haga falta. Eso deja la base como estaba al inicio.

### 5. Conexión entre el gestor y el portal (ya configurada)

El gestor publica encuestas y guías en el portal y trae las respuestas de los pacientes. Para eso los dos comparten una clave secreta, y **ya viene configurada**, así que no hay que hacer nada para probar el sistema.

- En `portal-backend` hay un archivo `.env` con `API_KEY=1`.
- En `nodebridge-gestor` hay un archivo `.env` con `PORTAL_API_KEY=1`.

La clave es `1` solo para facilitar la prueba. Eso **no es seguro**: cualquiera que conozca la clave puede usar la conexión. Para usar el sistema de verdad, cambiá la clave por una larga y secreta, siguiendo estos pasos:

1. Abrir con el Bloc de notas el `.env` de `portal-backend` y cambiar el valor de `API_KEY`.
2. Abrir el `.env` de `nodebridge-gestor` y poner **el mismo valor** en `PORTAL_API_KEY`.
3. Guardar los dos archivos. Los dos valores tienen que ser idénticos.

Si no se encuentran los archivos `.env`, es porque el Explorador de Windows puede ocultar los archivos que empiezan con punto. Se pueden abrir igual desde el Bloc de notas (**Archivo → Abrir**, con "Todos los archivos" elegido) o desde un editor como VS Code.

### 6. Abrir el sistema

| Qué | Dirección |
|---|---|
| Portal informativo (pacientes) | http://localhost/portal-informativo/ |
| Gestor interno (funcionarios) | http://localhost/nodebridge-gestor/ |

## Ingresar al gestor

Usuario administrador:

- **Usuario:** `admin`
- **Contraseña:** `Admin2026!`

En el login hay que resolver también un captcha: escribir el código que aparece en la imagen. Si falla cinco veces seguidas se bloquea el acceso durante diez minutos.

El administrador puede hacer todo: documentos, encuestas, respuestas, funcionarios, traslados y ambulancias. Después de entrar, se recomienda cambiar la contraseña desde **Cambiar mi contraseña**, en el menú.

Los funcionarios se crean desde la sección **Funcionarios** del gestor, con cédula obligatoria. Si alguno olvida su contraseña, usa **¿Olvidaste tu contraseña?** en el login: la solicitud le llega al administrador, que la restablece desde **Funcionarios**.

## Cómo comprobar que todo funciona

1. Entrar al gestor como `admin`.
2. En **Encuestas**, crear o activar una encuesta y publicarla.
3. Abrir http://localhost/portal-informativo/ y entrar a la sección de encuestas: la encuesta tiene que aparecer.
4. Responderla como paciente.
5. Volver al gestor y entrar a **Respuestas**: la respuesta tiene que aparecer.

Para probar la conexión sola, abrir en el navegador `http://localhost/portal-backend/api/ping.php`. Debería responder que la clave falta (es normal, el navegador no envía la clave) y no un error de conexión a la base.

## Qué hace cada parte

**Gestor (intranet)**

- Documentos y guías: los funcionarios pueden subirlos; solo el administrador los edita, los borra y publica las guías generales en el portal.
- Encuestas y respuestas: solo el administrador. Las encuestas se arman por sector y se publican en el portal.
- Funcionarios: alta con cédula, restablecimiento de contraseñas y solicitudes de recuperación.
- Traslados: los funcionarios solicitan una ambulancia; el administrador asigna ambulancia y conductor; el estado del traslado (asignado, en camino, llegó al destino, volviendo, finalizado) se puede cambiar desde el menú del estado y es reversible.
- Ambulancias y conductores: matrícula, conductor con cédula y nombre, y estado.

**Portal (público)**

- Listado, búsqueda y descarga de guías y documentos.
- Encuestas anónimas por sector, con escala de 1 a 5, opción única o texto libre.
- Límite de 5 envíos cada 10 minutos por conexión y campo anti-spam.

El gestor siempre llama al portal; el portal nunca llama a la intranet.

## Problemas frecuentes

| Problema | Qué revisar |
|---|---|
| `localhost` no abre nada | Que **Apache** esté en verde en el panel de XAMPP. |
| El gestor dice que no puede conectar con la base | Que **MySQL** esté en verde y que `respaldo.sql` se haya importado (deben existir `sigsm` y `portal_informativo`). |
| Error 404 al abrir el gestor o el portal | Que las carpetas estén sueltas en `C:\xampp\htdocs\` y no dentro de otra carpeta. |
| El portal no muestra encuestas | Que la encuesta esté publicada desde el gestor y que la clave sea la misma en los dos `.env` (por defecto, `1`). |
| El gestor no logra publicar en el portal | Que `PORTAL_URL` en el `.env` del gestor sea `http://localhost/portal-backend` y que el archivo se llame `.env` y no `.env.txt`. |
| La importación de `respaldo.sql` falla por tamaño | En phpMyAdmin, el límite lo define `upload_max_filesize` en `C:\xampp\php\php.ini`. Subirlo y reiniciar Apache. |
| No se ve el captcha | Recargar la página: el código se genera de nuevo en cada carga. |

## Cuando se publique en internet

- **Frontend:** solo cambia `portal-informativo/js/config.js` (`BACKEND_URL`).
- **Backend:** las claves de `portal-backend/.env.example` se cargan como variables de entorno en el servicio de alojamiento (el `.env` no se sube). Con una base en la nube suele hacer falta `DB_SSL=1`, y `TRUST_PROXY=1` si está detrás de un proxy.
- **Archivos subidos:** `UPLOADS_DIR` debe apuntar a un disco persistente.
- **Gestor:** al ser una intranet, solo se accede desde la red del hospital.

## Créditos

Desarrollado por NodeBridge, para el proyecto de egreso del Polo Educativo Tecnológico Montevideo - Vista Linda.
