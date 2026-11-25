#  Solitario de Pirámide — Trabajo Práctico Integrador

Implementación orientada a objetos del clásico juego de cartas **Solitario de Pirámide** desarrollada íntegramente en **Smalltalk (Pharo 13.0)** para la cátedra **Paradigmas de Programación** (Curso 2.2) de la **Universidad Tecnológica Nacional — Facultad Regional Resistencia (UTN FRRe)**.

El proyecto separa estrictamente la lógica de negocio (paquete `SolitarioPiramide`) de la interfaz gráfica vectorial (paquete `SolitarioPiramide-UI`) mediante el patrón observador (`changed` / `update:`), incorporando jerarquías polimórficas para las reglas de eliminación y un sistema original de **Power-Ups** (*Decretos Reales* y *Combo 6-7*).

---

##  Integrantes — Grupo 12

* **Cabral, Lautaro** — `lautimix@hotmail.com`
* **Carballo Ucero, Bautista** — `bautistacarballoucero@gmail.com`
* **De Bortoli, Lautaro Agustín** — `lauti.debor@gmail.com`
* **Gonzales, Luis** — `luissantaana10@gmail.com`
* **Pedrozo Rios, Tiago Federico** — `tiago.federico.p.r@gmail.com`

---

##  Características Principales

* **Tablero Piramidal de 7 Niveles:** Disposición de 28 cartas superpuestas (`Piramide` y `Casilla`), donde cada casilla determina dinámicamente si está libre verificando que las dos cartas inferiores que la cubren hayan sido eliminadas.
* **Reglas Clásicas de Eliminación:** Retiro de parejas libres cuya suma sea **13** (`As = 1`, `2..10`, `J = 11`, `Q = 12`) y eliminación individual de **Reyes (`K = 13`)**.
* **Baraja Extendida y Mazo Auxiliar:** Mazo inicial de **56 cartas** (baraja inglesa estándar de 52 cartas + 4 Reyes adicionales) con pila de descarte visible y hasta **2 reciclajes** completos (`Mazo` y `MazoAuxiliar`).
* **Sistema de Puntaje, Rachas y Récords:** Acumulación de puntos base por carta eliminada, multiplicador por rachas consecutivas, bonificación por tiempo restante y persistencia automática de la mejor puntuación histórica en disco (`RegistroRecords`).
* **Cronómetro Regresivo con Control de Velocidad:** Cuenta regresiva inicial de 300 segundos (`Cronometro`) con soporte para modificación dinámica de tiempo y factor de ralentización temporal.
* **Interfaz Gráfica en Morphic:** Vista desacoplada (`PartidaMorph`, `PiramideMorph`, `CartaMorph`, `MazoMorph`, `PanelEstadoMorph`) que reacciona en tiempo real ante cada cambio de estado del dominio.

---

##  Implementación de los Power-Ups

Para enriquecer la mecánica tradicional con decisiones de riesgo-recompensa bajo presión de tiempo, se diseñaron dos sistemas especiales implementados mediante **herencia y polimorfismo** (evitando estructuras condicionales en `Partida`):

### 1. Decretos Reales (`EfectoRey`)
Al hacer **clic derecho** sobre una carta **Rey (`K`) libre**, además de retirarla del tablero, se invoca `EfectoRey class >> aleatorio` y se ejecuta polimórficamente `aplicarEn: unaPartida` a través de cuatro subclases concretas que materializan seis efectos equilibrados (3 beneficiosos y 3 perjudiciales):

| Subclase | Efecto / Modificador | Impacto en la Partida |
| :--- | :--- | :--- |
| **`EfectoModificarTiempo`** | Bonificación / Penalización temporal | Suma segundos extra al reloj o descuenta 20 segundos del tiempo restante. |
| **`EfectoEscalarPuntaje`** | Multiplicador / Divisor de puntaje | Duplica (`factor: 2.0`) o reduce a la mitad (`factor: 0.5`) el puntaje acumulado. |
| **`EfectoEliminarCartaLibre`** | Despeje táctico | Elimina automáticamente una casilla libre al azar de la pirámide y suma sus puntos. |
| **`EfectoQuitarReciclaje`** | Restricción de mazo | Consume una vuelta de reciclaje disponible en el `MazoAuxiliar`. |

### 2. Combo 6-7 (`Eliminacion67`)
Especialización de `EliminacionPareja` que se instancia automáticamente cuando el jugador empareja una carta **6** con una carta **7** (`6 + 7 = 13`):
* Otorga una bonificación inmediata de **+67 puntos** (`sumarBonificacion:`).
* Activa el modo **Cámara Lenta (`SLOW-MO 0.5x`)** en `Cronometro` durante **6 segundos reales**, reduciendo a la mitad la velocidad de descuento del reloj.

---

##  Arquitectura del Repositorio

```text
src/
├── SolitarioPiramide/               # Modelo de Dominio (18 clases)
│   ├── Partida.class.st             # Coordinador central y ciclo de vida (#creada, #jugando, #ganada, #perdida)
│   ├── Piramide.class.st            # Estructura piramidal de 7 filas y 28 casillas
│   ├── Casilla.class.st             # Posición (fila, columna) y lógica de bloqueo/liberación
│   ├── Carta.class.st               # Valor numérico, palo y validación de suma 13
│   ├── Mazo.class.st                # Baraja extendida de 56 cartas
│   ├── MazoAuxiliar.class.st        # Subclase de Mazo con descarte y límite de reciclajes
│   ├── Puntaje.class.st             # Cálculo de puntos base, rachas y bonificaciones
│   ├── Cronometro.class.st          # Cuenta regresiva y factor de ralentización
│   ├── RegistroRecords.class.st     # Persistencia del récord máximo en archivo local
│   ├── Eliminacion.class.st         # Superclase abstracta de reglas de jugada
│   ├── EliminacionRey.class.st      # Regla de eliminación individual de K
│   ├── EliminacionPareja.class.st   # Regla de eliminación de parejas que suman 13
│   ├── Eliminacion67.class.st       # Regla especializada para el Combo 6-7
│   ├── EfectoRey.class.st           # Superclase abstracta de Decretos Reales
│   ├── EfectoModificarTiempo.class.st
│   ├── EfectoEscalarPuntaje.class.st
│   ├── EfectoEliminarCartaLibre.class.st
│   └── EfectoQuitarReciclaje.class.st
└── SolitarioPiramide-UI/            # Interfaz Gráfica Morphic (5 clases)
    ├── PartidaMorph.class.st        # Contenedor principal y observador de Partida
    ├── PiramideMorph.class.st       # Renderizado de las filas de la pirámide
    ├── CartaMorph.class.st          # Representación visual e interacción de clics
    ├── MazoMorph.class.st           # Vista del mazo auxiliar y descarte visible
    └── PanelEstadoMorph.class.st    # Barra superior de puntaje, racha, récord y reloj
```

---

##  Guía de Instalación y Ejecución

### Requisitos
* **Pharo 13.0** (64 bits). No requiere paquetes externos ni conexión a internet una vez clonado.

### 1. Carga del proyecto mediante Iceberg
1. Abrir **Pharo 13.0** e ir al menú superior **Browse → Iceberg**.
2. Hacer clic en **Add** (ícono `+`) → **Clone from github.com**.
3. Ingresar propietario `Tiagucci` y proyecto `G12-TPI-SP` (URL: `[https://github.com/Tiagucci/G12-TPI-SP.git](https://github.com/Tiagucci/G12-TPI-SP.git)`).
4. Una vez clonado, hacer doble clic sobre el repositorio, seleccionar ambos paquetes (**`SolitarioPiramide`** y **`SolitarioPiramide-UI`**) y elegir **Load**.

### 2. Ejecución del juego
Se puede iniciar de cualquiera de las siguientes formas:

* **Desde el Playground (`Ctrl + D`):**
  ```smalltalk
  PartidaMorph ejemploJuegoCompleto.
  ```
  *(O instanciando directamente: `PartidaMorph new position: 80 @ 40; openInWorld.`)*

* **Desde el System Browser (con un clic):**
  1. Abrir el **System Browser** y navegar a `SolitarioPiramide-UI` → `PartidaMorph`.
  2. Cambiar a la vista **Class side** y seleccionar el protocolo **`examples`**.
  3. Hacer clic en el ícono verde de ejecución (`<script>`) junto al método **`ejemploJuegoCompleto`**.

* **Pruebas del modelo de dominio sin interfaz:**
  En el **Class side** (protocolo **`examples`**) de `Partida` y `EfectoRey` se incluyen ejemplos ejecutables con `<script>` (`ejemploPartidaIniciada`, `ejemploRoboYReciclaje` y `ejemploAplicarDecretoAleatorio`) que abren un **Inspector** sobre el estado interno del modelo.

---

## Controles de Juego

* **Clic izquierdo** sobre una carta libre de la pirámide o del descarte: selecciona la carta (o la elimina directamente si es un **Rey `K`**).
* **Clic derecho** sobre un **Rey (`K`) libre**: activa un **Decreto Real** aleatorio.
* **Clic izquierdo** sobre el **Mazo Auxiliar**: roba una carta hacia el descarte visible (o recicla el descarte cuando el mazo se vacía, hasta 2 vueltas).
