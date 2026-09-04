# MyMusic — Maqueta de la pantalla de inicio de una app de música

MyMusic es una maqueta en SwiftUI de la pantalla principal de una app de música:
cabecera con avatar y saludo, chips de categoría, un carrusel de tarjetas destacadas,
una lista de playlists y una barra de pestañas flotante propia. De fondo, en la
esquina superior izquierda, un fragment shader de Metal dibuja un "rayo" iridiscente
animado. Existe como proyecto de portafolio para mostrar composición de interfaz en
SwiftUI, un componente de tab bar a medida, filtrado de contenido con `@Observable`, y
la integración de un shader de Metal como fondo decorativo.

> **Es una maqueta de interfaz: no reproduce audio.** Los botones de "play" solo
> cambian el icono a pausa. Los datos de las playlists están escritos en código y las
> ilustraciones son placeholders generados; ver
> [Cosas pendientes o limitadas](#cosas-pendientes-o-limitadas-a-propósito).

<img width="1311" height="677" alt="MyMusic" src="https://github.com/user-attachments/assets/6bdc5994-1201-4827-bb7b-38f37559ab68" />

---

## Tecnologías usadas

- Swift 6 (con verificación estricta de concurrencia activada)
- SwiftUI + `@Observable` para el estado
- Metal / MetalKit para el fondo animado (`MTKView` vía `UIViewRepresentable`)
- `async/await` para las animaciones temporizadas (sin `DispatchQueue`)
- Swift Testing para las pruebas
- Integración continua con GitHub Actions (compila y corre los tests en cada push/PR)
- Cero dependencias externas

---

## Cómo está organizado el proyecto

```
MyMusic/
├── MyMusicApp.swift              # @main; inyecta el PlaybackManager
├── Models/
│   └── Playlist.swift
├── ViewModels/
│   ├── HomeViewModel.swift       # Categorías, tabs, playlists y su filtrado
│   └── PlaybackManager.swift     # Qué elemento está "sonando" (sin audio real)
├── Views/
│   ├── HomeView.swift            # Compone todo
│   ├── HeaderView.swift          # Avatar, buscador, saludo
│   ├── CategorySelectorView.swift
│   ├── FeaturedCardView.swift    # Tarjeta destacada + like/descarga
│   ├── PlaylistListView.swift / PlaylistRowView.swift
│   ├── CustomTabBarView.swift    # Barra de pestañas a medida
│   └── TornasolBackgroundView.swift
└── Metal/
    ├── TornasolRenderer.swift    # Pipeline y bucle de dibujo del shader
    └── TornasolShader.metal      # vertex + fragment (rayo iridiscente)
```

`HomeViewModel` y `PlaybackManager` no dependen de SwiftUI ni de Metal, y son lo que
cubren las pruebas.

---

## Cómo funciona / flujo principal

1. `MyMusicApp` crea un `PlaybackManager` y lo pasa por el entorno.
2. `HomeView` construye un `HomeViewModel` con las playlists y tarjetas (datos fijos
   en código) y las dispone en un `ScrollView` sobre el fondo Metal.
3. `TornasolBackgroundView` monta un `MTKView`; `TornasolRenderer` compila el pipeline
   del shader y, si lo consigue, dibuja a 60 fps pasándole el tiempo transcurrido. Si
   el pipeline falla, la vista queda transparente y no ocurre nada más.
4. Los chips de categoría cambian `viewModel.selectedCategory`; `filteredPlaylists`
   recalcula la lista de forma determinista (todas / invertidas / por número de
   canciones / top 3).
5. Los botones de "play" llaman a `PlaybackManager.toggle(_:)`, que marca ese id como
   el que suena (y solo uno a la vez). La UI cambia el icono a pausa.

---

## Funcionalidades / qué demuestra

- Composición de una pantalla de inicio densa en SwiftUI: cabecera, carrusel, lista y
  barra de pestañas propia con material translúcido.
- Estado con `@Observable` inyectado por `@Environment`, sin `ObservableObject`.
- Filtrado de contenido determinista por categoría (la versión anterior barajaba en
  cada redibujo y la lista parpadeaba).
- Un fragment shader de Metal como fondo decorativo, con blending para transparencia y
  con creación de pipeline que degrada con elegancia si falla.
- Animaciones temporizadas con `Task`/`Task.sleep` en vez de `DispatchQueue.asyncAfter`.

---

## Pruebas

`MyMusicTests` (Swift Testing):

- **`HomeViewModel.filteredPlaylists`**: la categoría por defecto muestra todas en
  orden; "Novedades" invierte; "Tendencias" ordena por número de canciones; "Top" se
  queda con tres como mucho; el filtrado es **determinista** (dos lecturas seguidas
  dan el mismo orden); toda categoría devuelve un subconjunto de las playlists reales.
- **`PlaybackManager`**: arranca sin nada sonando; alternar un id lo inicia y volver a
  alternarlo lo detiene; solo un id suena a la vez.

Correr los tests:

```bash
xcodebuild test \
  -project MyMusic.xcodeproj \
  -scheme MyMusic \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## Cómo correr el proyecto

1. Clona el repo:
   ```bash
   git clone https://github.com/iostephano/MyMusic.git
   ```
2. Abre `MyMusic.xcodeproj` con **Xcode 26** (ver `.xcode-version`).
3. El objetivo mínimo es **iOS 26**. Elige un simulador de iPhone o un dispositivo con
   Metal y ejecuta (Cmd-R).

---

## Cosas pendientes o limitadas (a propósito)

- **No hay reproducción de audio.** `PlaybackManager` solo lleva qué elemento está
  "seleccionado" para que la UI muestre el icono de pausa; no hay `AVAudioPlayer` ni
  archivos de sonido.
- **Los datos están en código** (`HomeViewModel`): playlists, autores y descripciones
  son ficticios; no se cargan de red ni de disco.
- **Las ilustraciones son placeholders** generados, no obra de artistas reales ni
  portadas de discos.
- **La navegación es de maqueta**: la barra de pestañas cambia el icono activo pero
  solo existe la pantalla de inicio; "Ver todo" y el buscador no llevan a ningún sitio.
- **El fondo Metal se ancla con medidas fijas** a la esquina superior izquierda; no se
  adapta al tamaño de pantalla más allá de eso.

---

## Autor

Stephano Portella
