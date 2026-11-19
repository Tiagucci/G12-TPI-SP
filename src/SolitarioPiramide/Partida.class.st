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
	puntaje reiniciarRacha.
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
