Class {
	#name : 'PartidaMorph',
	#superclass : 'Morph',
	#instVars : [
		'partida',
		'panelEstado',
		'piramideMorph',
		'mazoMorph',
		'overlayCian',
		'cartelNotificacion',
		'menuInicio',
		'overlayPausa',
		'ayudaMorph'
	],
	#category : 'SolitarioPiramide-UI',
	#package : 'SolitarioPiramide-UI'
}

{ #category : 'examples' }
PartidaMorph class >> ejemploComboSeisSiete [
	"Abre una partida y dispara el Combo 6-7 (Bullet-Time 0.5x + 67 puntos)."
	<example>
	| ventana |
	ventana := self new.
	ventana position: 80 @ 40.
	ventana openInWorld.
	ventana partida
		iniciar;
		activarComboSeisSiete.
	^ ventana
]

{ #category : 'examples' }
PartidaMorph class >> ejemploJuegoCompleto [
	"Ejecutable principal: abre el juego completo arrancando desde el Menú de Inicio."
	<example>
	| ventana |
	ventana := self new.
	ventana position: 80 @ 40.
	ventana openInWorld.
	^ ventana
]

{ #category : 'examples' }
PartidaMorph class >> ejemploPartidaEnCurso [
	"Abre el tablero directamente en estado #jugando (saltea el menú de inicio)."
	<example>
	| ventana |
	ventana := self new.
	ventana position: 80 @ 40.
	ventana openInWorld.
	ventana partida iniciar.
	^ ventana
]

{ #category : 'examples' }
PartidaMorph class >> ejemploVictoria [
	"Despeja toda la pirámide para mostrar el cartel de victoria, bonus por tiempo y récord."
	<example>
	| ventana |
	ventana := self new.
	ventana position: 80 @ 40.
	ventana openInWorld.
	ventana partida iniciar.
	ventana partida piramide casillas do: [ :casilla | casilla eliminar ].
	ventana partida avanzarTiempo: 0.
	^ ventana
]

{ #category : 'notifications' }
PartidaMorph >> abrirAyuda [
	ayudaMorph ifNotNil: [ ^ self ].
	ayudaMorph := AyudaMorph new.
	ayudaMorph center: self center.
	ayudaMorph alVolver: [
		ayudaMorph delete.
		ayudaMorph := nil ].
	self addMorph: ayudaMorph.
]

{ #category : 'initialization' }
PartidaMorph >> construirInterfaz [
	"1. Barra superior"
	panelEstado := PanelEstadoMorph new.
	panelEstado position: self position + (20 @ 12).
	panelEstado alPausar: [
		partida estado = #jugando
			ifTrue: [ partida pausar ]
			ifFalse: [ partida estado = #pausada ifTrue: [ partida reanudar ] ] ].
	panelEstado alReiniciar: [
		self limpiarNotificacion.
		partida iniciar ].
	panelEstado alSalir: [ self delete ].
	self addMorph: panelEstado.

	"2. Pirámide central"
	piramideMorph := PiramideMorph new.
	piramideMorph position: self position + (20 @ 95).
	piramideMorph alSeleccionarCasilla: [ :casilla |
		self limpiarNotificacion.
		partida seleccionar: casilla ].
	piramideMorph alHacerClicDerechoEnCasilla: [ :casilla |
		| efecto |
		efecto := partida activarPoderReyEn: casilla.
		efecto ifNotNil: [
			self mostrarNotificacion: efecto nombre esPositivo: efecto esPositivo ] ].
	self addMorph: piramideMorph.

	"3. Mazo auxiliar a la derecha"
	mazoMorph := MazoMorph new.
	mazoMorph position: self position + (720 @ 120).
	mazoMorph alRobar: [
		self limpiarNotificacion.
		partida robarDelMazo ].
	mazoMorph alSeleccionarDescarte: [
		self limpiarNotificacion.
		partida seleccionarCartaDelMazo ].
	self addMorph: mazoMorph.

	"4. Filtro azul translúcido para Bullet-Time (inicialmente oculto)"
	overlayCian := Morph new.
	overlayCian extent: self extent.
	overlayCian position: self position.
	overlayCian color: (Color r: 0.0 g: 0.75 b: 1.0 alpha: 0.14).
	overlayCian lock.
	overlayCian visible: false.
	self addMorph: overlayCian.

	"5. Cortina de Pausa (tapa el tablero debajo de la barra superior)"
	overlayPausa := OverlayPausaMorph new.
	overlayPausa position: self position + (2 @ 78).
	overlayPausa alReanudar: [ partida reanudar ].
	overlayPausa alPedirAyuda: [ self abrirAyuda ].
	overlayPausa alVolverMenu: [
		self limpiarNotificacion.
		partida := Partida new.
		partida addDependent: self.
		self update: nil ].
	overlayPausa visible: false.
	self addMorph: overlayPausa.

	"6. Pantalla de Inicio"
	menuInicio := MenuInicioMorph new.
	menuInicio position: self position + (2 @ 2).
	menuInicio alIniciar: [
		self limpiarNotificacion.
		partida iniciar ].
	menuInicio alPedirAyuda: [ self abrirAyuda ].
	menuInicio alSalir: [ self delete ].
	self addMorph: menuInicio.
]

{ #category : 'initialization' }
PartidaMorph >> delete [
	self stopStepping.
	super delete.
]

{ #category : 'initialization' }
PartidaMorph >> initialize [
	super initialize.
	self extent: 940 @ 650.
	self color: (Color r: 0.09 g: 0.14 b: 0.20).
	self borderWidth: 2.
	self borderColor: (Color r: 0.22 g: 0.30 b: 0.40).

	partida := Partida new.
	partida addDependent: self.

	self construirInterfaz.
	self update: nil.
	self startStepping.
]

{ #category : 'notifications' }
PartidaMorph >> limpiarNotificacion [
	cartelNotificacion ifNotNil: [
		cartelNotificacion delete.
		cartelNotificacion := nil ].
]

{ #category : 'notifications' }
PartidaMorph >> mostrarFinDePartida: unTitulo color: unColor [
	| fuente titulo detalle ayuda |
	self limpiarNotificacion.

	cartelNotificacion := Morph new.
	cartelNotificacion extent: 540 @ 130.
	cartelNotificacion center: self center.
	cartelNotificacion color: unColor.
	cartelNotificacion borderWidth: 3.
	cartelNotificacion borderColor: Color white.

	fuente := LogicalFont familyName: 'Source Sans Pro' pointSize: 16.
	titulo := StringMorph contents: unTitulo font: fuente emphasis: 1.
	titulo color: Color white.
	titulo center: cartelNotificacion center - (0 @ 30).

	detalle := StringMorph
		contents: 'Puntaje final: ' , partida puntaje total asString
			, '   |   Récord: ' , partida registro record asString
		font: (LogicalFont familyName: 'Source Sans Pro' pointSize: 13)
		emphasis: 1.
	detalle color: (Color r: 1.0 g: 0.92 b: 0.55).
	detalle center: cartelNotificacion center + (0 @ 4).

	ayuda := StringMorph
		contents: 'Tocá "Nueva Partida" o presioná R para volver a jugar'
		font: (LogicalFont familyName: 'Source Sans Pro' pointSize: 11).
	ayuda color: Color white.
	ayuda center: cartelNotificacion center + (0 @ 34).

	cartelNotificacion
		addMorph: titulo;
		addMorph: detalle;
		addMorph: ayuda.
	self addMorph: cartelNotificacion.
]

{ #category : 'notifications' }
PartidaMorph >> mostrarNotificacion: unTexto esPositivo: unBooleano [
	| fuente label |
	self limpiarNotificacion.

	cartelNotificacion := Morph new.
	cartelNotificacion extent: 560 @ 42.
	cartelNotificacion position: self position + (190 @ 585).
	cartelNotificacion color: (unBooleano = true
		ifTrue: [ Color r: 0.12 g: 0.42 b: 0.55 alpha: 0.95 ]
		ifFalse: [ Color r: 0.58 g: 0.16 b: 0.20 alpha: 0.95 ]).
	cartelNotificacion borderWidth: 2.
	cartelNotificacion borderColor: Color white.

	fuente := LogicalFont familyName: 'Source Sans Pro' pointSize: 13.
	label := StringMorph contents: unTexto font: fuente emphasis: 1.
	label color: Color white.
	label center: cartelNotificacion center.

	cartelNotificacion addMorph: label.
	self addMorph: cartelNotificacion.
]

{ #category : 'accessing' }
PartidaMorph >> partida [
	^ partida
]

{ #category : 'stepping' }
PartidaMorph >> step [
	partida ifNotNil: [
		partida avanzarTiempo: 1 ].
]

{ #category : 'stepping' }
PartidaMorph >> stepTime [
	^ 1000.
]

{ #category : 'updating' }
PartidaMorph >> update: unAspecto [
	| enSlowMo |
	partida ifNil: [ ^ self ].

	panelEstado actualizarCon: partida.
	piramideMorph piramide: partida piramide.
	piramideMorph actualizarConSeleccion: partida seleccion.
	mazoMorph mazoAuxiliar: partida mazoAuxiliar.

	"Activar o desactivar estética Bullet-Time (6-7)"
	enSlowMo := partida estaEnCamaraLenta.
	overlayCian visible: enSlowMo.
	self borderColor: (enSlowMo
		ifTrue: [ Color cyan ]
		ifFalse: [ Color r: 0.22 g: 0.30 b: 0.40 ]).

	(enSlowMo and: [ cartelNotificacion isNil ]) ifTrue: [
		self mostrarNotificacion: 'COMBO 6-7! TIEMPO RALENTIZADO 0.5x (+67 pts)' esPositivo: true ].

	"Pantalla de fin de partida"
	partida estado = #ganada ifTrue: [
		self mostrarFinDePartida: '¡VICTORIA! PIRÁMIDE DESPEJADA' color: (Color r: 0.15 g: 0.65 b: 0.35) ].
	partida estado = #perdida ifTrue: [
		self mostrarFinDePartida: 'FIN DEL JUEGO — SIN MOVIMIENTOS O TIEMPO' color: (Color r: 0.75 g: 0.20 b: 0.22) ].
	
menuInicio visible: (partida estado = #creada).
	partida estado = #creada ifTrue: [
		menuInicio record: partida registro record ].

	overlayPausa visible: (partida estado = #pausada).
]
