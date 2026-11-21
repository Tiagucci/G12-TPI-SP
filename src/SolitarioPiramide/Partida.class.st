"
Representa una partida del juego y gestiona su estado y reglas.
"
Class {
	#name : 'Partida',
	#superclass : 'Object',
	#instVars : [
		'piramide',
		'mazoAuxiliar',
		'puntaje',
		'cronometro',
		'registro',
		'seleccion',
		'estado',
		'ultimoEfectoRey'
	],
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'actions' }
Partida >> activarComboSeisSiete [
	"Ralentiza el reloj a 0.5x durante 6 segundos reales (en el cronómetro avanzan 3s)"
	cronometro activarRalentizacion: 6 factor: 0.5.
	puntaje sumarBonificacion: 67.
]

{ #category : 'actions' }
Partida >> activarPoderReyEn: unaCasilla [
	"Dispara el comodín K: elimina la carta y aplica uno de los 6 efectos al azar"
	estado = #jugando ifFalse: [ ^ nil ].
	(unaCasilla esLibre and: [ unaCasilla carta esRey ]) ifFalse: [ ^ nil ].

	unaCasilla eliminar.
	seleccion removeAll.

	ultimoEfectoRey := EfectoRey aleatorio.
	ultimoEfectoRey aplicarEn: self.

	self verificarEstadoPartida.
	self changed.
	^ ultimoEfectoRey.
]

{ #category : 'actions' }
Partida >> avanzarTiempo: unosSegundos [
	estado = #jugando ifFalse: [ ^ self ].
	cronometro avanzar: unosSegundos.
	self verificarEstadoPartida.
	self changed.
]

{ #category : 'private' }
Partida >> confirmarEliminacion [
	| cartasSeleccionadas regla |
	cartasSeleccionadas := seleccion collect: [ :casilla | casilla carta ].
	regla := self reglaPara: cartasSeleccionadas.

	(regla esValidaPara: cartasSeleccionadas)
		ifTrue: [
			seleccion do: [ :casilla | casilla eliminar ].
			puntaje sumarPorEliminacion: seleccion size.
			regla aplicarEfectoExtraEn: self.
			seleccion removeAll.
			self verificarEstadoPartida ]
		ifFalse: [
			puntaje reiniciarRacha.
			seleccion removeAll ].
]

{ #category : 'accessing' }
Partida >> cronometro [
	^ cronometro.
]

{ #category : 'examples' }
Partida >> ejemplo1 [
| partida ventana tablero lblInfo lblMensaje proceso tiempoAnterior
  refrescar actualizarInfo nuevaPartida cartaMorph crearBoton textoCarta |

textoCarta := [ :carta |
	carta rango asString, ' ', carta palo asString first asString ].

crearBoton := [ :x :y :w :h :texto :accion |
	| m etiqueta |
	m := Morph new.
	m color: (Color r: 0.85 g: 0.85 b: 0.6).
	m extent: w @ h.
	m position: tablero position + (x @ y).
	etiqueta := StringMorph contents: texto.
	etiqueta position: m position + (8 @ 8).
	m addMorph: etiqueta.
	m on: #mouseDown send: #value to: accion.
	m ].

cartaMorph := [ :casilla |
	| m carta colorFondo colorTexto etiqueta x y |
	carta := casilla carta.
	colorFondo := (partida seleccion includes: casilla)
		ifTrue: [ Color yellow ]
		ifFalse: [ casilla esLibre ifTrue: [ Color white ] ifFalse: [ Color gray ] ].
	colorTexto := (#(corazones diamantes) includes: carta palo)
		ifTrue: [ Color red ] ifFalse: [ Color black ].
	x := (7 - casilla fila) * 30 + ((casilla columna - 1) * 60).
	y := (casilla fila - 1) * 30.
	m := Morph new.
	m color: colorFondo.
	m extent: 60 @ 84.
	m position: tablero position + (250 @ 100) + (x @ y).
	etiqueta := StringMorph contents: (textoCarta value: carta).
	etiqueta color: colorTexto.
	etiqueta position: m position + (4 @ 4).
	m addMorph: etiqueta.
	casilla esLibre ifTrue: [
		m on: #mouseDown send: #value to: [ partida seleccionar: casilla. refrescar value ] ].
	m ].

refrescar := [
	tablero removeAllMorphs.
	partida piramide casillas do: [ :c |
		c estaEliminada ifFalse: [ tablero addMorph: (cartaMorph value: c) ] ].
	tablero addMorph: (crearBoton valueWithArguments: {
		250. 420. 120. 84.
		'Mazo: ', partida mazoAuxiliar cantidadCartas printString.
		[ partida robarDelMazo. refrescar value ] }).
	tablero addMorph: (crearBoton valueWithArguments: {
		400. 420. 120. 84.
		partida mazoAuxiliar cartaVisible
			ifNil: [ 'Descarte vacio' ]
			ifNotNil: [ :c | textoCarta value: c ].
		[ partida seleccionarCartaDelMazo. refrescar value ] }).
	tablero addMorph: (crearBoton valueWithArguments: {
		250. 560. 150. 40. 'Nueva partida'. nuevaPartida }).
	tablero addMorph: (crearBoton valueWithArguments: {
		420. 560. 120. 40. 'Salir'. [ proceso terminate. ventana delete ] }).
	actualizarInfo value ].

actualizarInfo := [
	lblInfo contents: 'Tiempo: ', partida cronometro tiempoRestante printString,
		's   Puntaje: ', partida puntaje total printString,
		'   Racha: ', partida puntaje rachaActual printString,
		'   Record: ', partida registro mejorPuntaje printString,
		(partida estaEnCamaraLenta ifTrue: [ '   [CAMARA LENTA]' ] ifFalse: [ '' ]).
	lblMensaje contents: (partida estado = #ganada
		ifTrue: [ 'GANASTE! Puntaje final: ', partida puntaje total printString ]
		ifFalse: [
			partida estado = #perdida
				ifTrue: [ 'PERDISTE. Usa Nueva partida para volver a intentar.' ]
				ifFalse: [ '' ] ]) ].

nuevaPartida := [
	partida := Partida new.
	partida iniciar.
	tiempoAnterior := Time millisecondClockValue.
	refrescar value ].

ventana := Morph new.
ventana color: (Color r: 0.07 g: 0.35 b: 0.2).
ventana extent: 900 @ 640.
ventana openInWorld.

tablero := Morph new.
tablero color: Color transparent.
tablero extent: 900 @ 640.
tablero position: ventana position.
ventana addMorph: tablero.

lblInfo := StringMorph contents: ''.
lblInfo color: Color white.
lblInfo position: ventana position + (20 @ 15).
ventana addMorph: lblInfo.

lblMensaje := StringMorph contents: ''.
lblMensaje color: Color yellow.
lblMensaje position: ventana position + (20 @ 40).
ventana addMorph: lblMensaje.

nuevaPartida value.

proceso := [
	[ true ] whileTrue: [
		(Delay forMilliseconds: 200) wait.
		UIManager default defer: [
			| ahora |
			ahora := Time millisecondClockValue.
			partida avanzarTiempo: (ahora - tiempoAnterior) / 1000.0.
			tiempoAnterior := ahora.
			actualizarInfo value ] ] ] fork.
]

{ #category : 'testing' }
Partida >> estaEnCamaraLenta [
	^ cronometro estaRalentizado.
]

{ #category : 'testing' }
Partida >> estaGanada [
	^ piramide estaVacia.
]

{ #category : 'testing' }
Partida >> estaPerdida [
	^ self estaGanada not and: [
		cronometro seAgoto or: [ self hayMovimientosPosibles not ] ].
]

{ #category : 'accessing' }
Partida >> estado [
	^ estado.
]

{ #category : 'testing' }
Partida >> hayMovimientosPosibles [
	| cartaVisible |
	piramide hayCombinacionPosible ifTrue: [ ^ true ].
	(mazoAuxiliar estaVacio not or: [ mazoAuxiliar puedeReciclar ]) ifTrue: [ ^ true ].

	cartaVisible := mazoAuxiliar cartaVisible.
	cartaVisible ifNil: [ ^ false ].
	cartaVisible esRey ifTrue: [ ^ true ].

	^ piramide casillasLibres anySatisfy: [ :c | c carta suma13Con: cartaVisible ].
]

{ #category : 'initialization' }
Partida >> iniciar [
puntaje := Puntaje new.
	cronometro := Cronometro new.
	seleccion removeAll.
	ultimoEfectoRey := nil.
	estado := #jugando.
	mazoAuxiliar := MazoAuxiliar crearCompleto.
	mazoAuxiliar barajar.
	piramide := Piramide new.
	piramide armarCon: mazoAuxiliar.
	cronometro iniciar.
	self changed.

]

{ #category : 'initialization' }
Partida >> initialize [
	super initialize.
	puntaje := Puntaje new.
	cronometro := Cronometro new.
	registro := RegistroRecords new.
	registro cargar.
	seleccion := OrderedCollection new.
	estado := #creada.
	ultimoEfectoRey := nil.
]

{ #category : 'accessing' }
Partida >> mazoAuxiliar [
	^ mazoAuxiliar.
]

{ #category : 'accessing' }
Partida >> piramide [
	^ piramide.
]

{ #category : 'accessing' }
Partida >> puntaje [
	^ puntaje.
]

{ #category : 'accessing' }
Partida >> registro [
	^ registro.
]

{ #category : 'private' }
Partida >> reglaPara: unasCartas [
	unasCartas size = 1 ifTrue: [ ^ EliminacionRey new ].
	(Eliminacion67 new esValidaPara: unasCartas) ifTrue: [ ^ Eliminacion67 new ].
	^ EliminacionPareja new.
]

{ #category : 'actions' }
Partida >> robarDelMazo [
	estado = #jugando ifFalse: [ ^ self ].
	mazoAuxiliar robarCarta.
	seleccion removeAll.
	self verificarEstadoPartida.
	self changed.
]

{ #category : 'accessing' }
Partida >> seleccion [
	^ seleccion.
]

{ #category : 'actions' }
Partida >> seleccionar: unaCasilla [
	estado = #jugando ifFalse: [ ^ self ].
	unaCasilla esLibre ifFalse: [ ^ self ].

	(seleccion includes: unaCasilla)
		ifTrue: [ seleccion remove: unaCasilla ]
		ifFalse: [ seleccion add: unaCasilla ].

	(seleccion size = 1 and: [ seleccion first carta esRey ])
		ifTrue: [ self confirmarEliminacion ].

	seleccion size = 2
		ifTrue: [ self confirmarEliminacion ].

	self changed.
]

{ #category : 'actions' }
Partida >> seleccionarCartaDelMazo [
	| cartaVisible cartas regla |
	estado = #jugando ifFalse: [ ^ self ].
	cartaVisible := mazoAuxiliar cartaVisible.
	cartaVisible ifNil: [ ^ self ].

	cartaVisible esRey ifTrue: [
		mazoAuxiliar sacarCartaVisible.
		puntaje sumarPorEliminacion: 1.
		seleccion removeAll.
		self verificarEstadoPartida.
		self changed.
		^ self ].

	seleccion size = 1 ifTrue: [
		cartas := { seleccion first carta. cartaVisible }.
		regla := self reglaPara: cartas.
		(regla esValidaPara: cartas)
			ifTrue: [
				seleccion first eliminar.
				mazoAuxiliar sacarCartaVisible.
				puntaje sumarPorEliminacion: 2.
				regla aplicarEfectoExtraEn: self.
				seleccion removeAll.
				self verificarEstadoPartida ]
			ifFalse: [
				puntaje reiniciarRacha.
				seleccion removeAll ].
		self changed ].
]

{ #category : 'accessing' }
Partida >> ultimoEfectoRey [
	^ ultimoEfectoRey.
]

{ #category : 'private' }
Partida >> verificarEstadoPartida [
	self estaGanada ifTrue: [
		estado := #ganada.
		cronometro pausar.
		puntaje sumarBonificacion: cronometro tiempoRestante * 5.
		registro registrar: puntaje total.
		^ self ].

	self estaPerdida ifTrue: [
		estado := #perdida.
		cronometro pausar.
		registro registrar: puntaje total ].
]
