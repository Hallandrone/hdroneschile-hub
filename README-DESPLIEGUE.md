# hdroneschile.cl — hub de nuestras webs

Página estática: un solo `index.html`, la carpeta `media/` y las reglas de redirección.
No necesita base de datos ni PHP. Se sube tal cual a cualquier hosting estático.

## Qué hay en la carpeta

| Archivo | Para qué |
| --- | --- |
| `index.html` | La página. Los destinos son los bloques `<a class="dest">` dentro de `<nav class="dests">`. |
| `media/poster.jpg` | Fotograma 1 del dron (fondo mientras carga el video). |
| `media/dron-*.mp4/.webm` | Clip base (el dron abre los ojos y mira hacia los botones). Lo usan los destinos que aún no tienen clip propio. |
| `media/<destino>-1080.mp4`, `-720.mp4`, `-720.webm` | **Clips de transición de uniforme, uno por destino** (`academia`, `asesorias`, `tienda`, `agro`, `servicios`, `pilotos`, `antidrones`). Al existir, la página los detecta sola. |
| `_redirects` | Atajos `/academia`, `/asesorias`, `/tienda`, `/agro`, `/servicios`, `/pilotos`, `/antidrones` para Cloudflare Pages o Netlify. |
| `.htaccess` | Lo mismo, más subdominios y canónico, para Apache/cPanel. |

## Opción A · Cloudflare Pages (recomendada: gratis, rápida, HTTPS automático)

1. Crea una cuenta en Cloudflare y agrega el sitio `hdroneschile.cl`. Cloudflare te dará dos **nameservers** (por ejemplo `ada.ns.cloudflare.com` y `bob.ns.cloudflare.com`).
2. En **NIC Chile** → Mis dominios → `hdroneschile.cl` → *Modificar DNS / servidores de nombre*: reemplaza los servidores actuales por los dos de Cloudflare. Propaga en minutos (máximo algunas horas).
3. En Cloudflare → **Workers & Pages → Create → Pages → Upload assets**: sube el contenido de esta carpeta (`index.html`, `media/`, `_redirects`). Nombre del proyecto: `hdroneschile`.
4. En el proyecto → **Custom domains** → agrega `hdroneschile.cl` y `www.hdroneschile.cl`. Cloudflare crea los registros DNS solo.
5. Subdominios (opcional): **Rules → Redirect Rules**, uno por destino, por ejemplo:
   - `academia.hdroneschile.cl` → `https://www.academiadronchile.cl/` (301)
   - `asesorias.hdroneschile.cl` → `https://asesoriasdedrones.cl/` (301)
   - `tienda.hdroneschile.cl` → `https://ventadronchile.cl/` (301)
   Cada subdominio necesita además un registro DNS (CNAME `academia` → `hdroneschile.cl`, proxied/naranja) para que la regla se evalúe.

## Opción B · Un hosting cPanel/Apache que ya tengan

1. En cPanel → **Dominios** → agrega `hdroneschile.cl` como dominio adicional (addon). Apunta su raíz a una carpeta nueva, por ejemplo `public_html/hdroneschile`.
2. En NIC Chile deja los nameservers del hosting (o crea el registro **A** de `hdroneschile.cl` y `www` hacia la IP del servidor, que aparece en cPanel).
3. Sube esta carpeta completa (incluido `.htaccess`, que es un archivo oculto) a esa raíz.
4. Activa el certificado SSL (AutoSSL / Let's Encrypt) para el dominio y `www`.
5. Para los subdominios (`academia.`, `asesorias.`, `tienda.`, `agro.`, `servicios.`, `pilotos.`, `antidrones.`): créalos en cPanel apuntando a **la misma carpeta**; el `.htaccess` ya redirige según el host.

## Agregar o cambiar un destino

1. En `index.html`, duplica un bloque `<a class="dest">` y cambia:
   `href` (web final), `data-clip` (nombre corto, también nombre del clip), `data-short`, `data-uniform`,
   `data-color` y `style="--c:…"` (color del destino), `data-path`, `data-angle` y los textos.
   `data-angle` es la posición del destino alrededor del dron en pantallas anchas (0 = derecha, 90 = arriba,
   180 = izquierda, 270 = abajo). Deja al menos 35° entre destinos vecinos para que cada uno tenga su espacio.
2. Agrega su atajo en `_redirects` y/o `.htaccess`.
3. Cuando tengas su clip, guárdalo como `media/<data-clip>-720.mp4` (y, si puedes, `-1080.mp4` y `-720.webm`).
   Sin clip, el destino usa el clip base hasta la pose «mira hacia los botones».

## Los 7 clips de uniforme (generados el 2/10/2026 en Higgsfield)

Ya están recodificados y empaquetados en `hdroneschile-clips.zip` (≈20 MB; 21 archivos: `<destino>-1080.mp4`, `-720.mp4` y `-720.webm`
para academia, asesorias, tienda, agro, servicios, pilotos y antidrones). Descomprime ese zip **dentro de `media/`** antes de subir la
carpeta al hosting; la página los detecta sola y el indicador CLIP de la telemetría pasa de «base» al nombre del destino.
Mientras no estén, cada destino usa el clip base.

## Clips: cómo prepararlos para que el scrub sea suave (si regeneras alguno)

Un MP4 normal trae un keyframe cada varios segundos y al retroceder salta. Antes de subir, recodifica sin audio y con un keyframe cada 6 fotogramas:

```bash
# 1080p
ffmpeg -i academia.mp4 -an -vf "scale=1920:-2" -c:v libx264 -preset slow -crf 22 -g 6 -keyint_min 6 -sc_threshold 0 -pix_fmt yuv420p -movflags +faststart media/academia-1080.mp4
# 720p
ffmpeg -i academia.mp4 -an -vf "scale=1280:-2" -c:v libx264 -preset slow -crf 23 -g 6 -keyint_min 6 -sc_threshold 0 -pix_fmt yuv420p -movflags +faststart media/academia-720.mp4
# WebM (Safari viejo/Firefox sin H.264)
ffmpeg -i academia.mp4 -an -vf "scale=1280:-2" -c:v libvpx-vp9 -b:v 0 -crf 34 -g 6 -keyint_min 6 -pix_fmt yuv420p media/academia-720.webm
```

Reglas de cada clip (igual que en el prompt maestro): un solo plano fijo, 4–5 s, 24 fps, sin cortes ni loops;
**el fotograma 1 debe ser idéntico al del clip base** (así el cambio entre destinos no se nota) y la acción va en una
sola dirección: tranquilo → nota al visitante → se cambia de uniforme → pose final mirando hacia los botones (lado izquierdo).

## Prueba antes de publicar

- Pantalla ancha (computador): los 7 destinos rodean al dron sobre una órbita punteada, separados entre sí.
- Cursor sobre el dron o a medio camino entre dos destinos: dron neutro, con sus audífonos.
- Acercándote a un destino: el dron se va vistiendo poco a poco (anillo de progreso en el destino, ruta punteada
  desde el dron y etiqueta del uniforme). Sobre el destino: uniforme completo (instructor, asesor, vendedor,
  agricultor, operador, piloto o guardia). Los demás destinos se atenúan.
- Pasa de un destino a otro: el dron se quita el uniforme anterior y luego se pone el nuevo.
- Teléfono o panel vertical: el dron queda arriba, entero y centrado, y los destinos van en un panel de dos columnas
  abajo. Al tocar un destino el dron se viste durante el despegue (si su clip aún carga, lo espera).
- Ventana horizontal angosta: los destinos se muestran como lista abajo a la izquierda.
- Clic: secuencia de 9 s: el dron termina de vestirse mientras la escena se acerca (≈4,4 s), primer plano del dron con el nombre del destino (3 s), despegue con destello (1,6 s) y navega a la web en la misma pestaña.
- Botón «Quiénes somos»: abre el panel del ecosistema HDRONES; al hacer clic en un área, el dron despega hacia esa web.
- `hdroneschile.cl/academia`, `/asesorias`, `/tienda`, `/agro`, `/servicios`, `/pilotos` y `/antidrones` deben responder 301 a la web correspondiente.
- En el teléfono: arrastra el dedo hacia un botón para ver la transición; tocar navega.
