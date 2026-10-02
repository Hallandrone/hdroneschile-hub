# hdroneschile.cl — hub de las webs de HDRONES

Portada estática: un dron reactivo al cursor que se viste con el uniforme de la web a la que te lleva
(academia, asesorías, tienda, agro, servicios, pilotos, antidrones) y redirige al hacer clic.

- `index.html` — la página (los destinos son los bloques `<a class="dest">`).
- `media/` — póster y clip base. Los clips de uniforme **no** están en git: `build.sh` los descarga en el build de Vercel
  (`CLIPS_URL`, por defecto el zip generado el 2/10/2026) y los deja en `public/media/`.
- `vercel.json` — redirecciones 301 (`/academia`, `/asesorias`, `/tienda`, `/agro`, `/servicios`, `/pilotos`, `/antidrones`,
  subdominios y variantes), cabeceras de caché y el build.
- `README-DESPLIEGUE.md` — guía completa (también cPanel) y cómo regenerar un clip.

Despliegue: importar este repo en Vercel (framework: Other). El build corre `bash build.sh` y publica `public/`.
Dominio: en Vercel → Settings → Domains → `hdroneschile.cl` y `www.hdroneschile.cl`; en NIC Chile, servidores DNS
`ns1.vercel-dns.com` y `ns2.vercel-dns.com` (o el registro A/CNAME que indique Vercel).
