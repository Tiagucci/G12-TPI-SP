Class {
	#name : 'PiramideMorph',
	#superclass : 'Morph',
	#instVars : [
		'piramide',
		'accionSeleccionar',
		'accionClicDerecho'
	],
	#category : 'SolitarioPiramide-UI',
	#package : 'SolitarioPiramide-UI'
}

{ #category : 'updating' }
PiramideMorph >> actualizarConSeleccion: casillasSeleccionadas [
	| anchoCarta pasoX pasoY |
	self removeAllMorphs.
	piramide ifNil: [ ^ self ].

	anchoCarta := 80.
	pasoX := 92.  "80px de carta + 12px de espacio horizontal"
	pasoY := 50.  "Solapamiento vertical entre filas"

	piramide filas withIndexDo: [ :fila :numFila |
		| anchoFila inicioX posY |
		anchoFila := (numFila * anchoCarta) + ((numFila - 1) * 12).
		inicioX := (self width - anchoFila) // 2.
		posY := self top + ((numFila - 1) * pasoY).

		fila withIndexDo: [ :casilla :numCol |
			casilla estaEliminada ifFalse: [
				| cartaMorph posX |
				posX := self left + inicioX + ((numCol - 1) * pasoX).

				cartaMorph := CartaMorph new.
				cartaMorph position: posX @ posY.
				cartaMorph bloqueada: casilla esLibre not.
				cartaMorph seleccionada: (casillasSeleccionadas includes: casilla).
				cartaMorph carta: casilla carta.

				cartaMorph alHacerClic: [
					accionSeleccionar ifNotNil: [ accionSeleccionar value: casilla ] ].
				cartaMorph alHacerClicDerecho: [
					accionClicDerecho ifNotNil: [ accionClicDerecho value: casilla ] ].

				self addMorph: cartaMorph ] ] ].
]

{ #category : 'accessing' }
PiramideMorph >> alHacerClicDerechoEnCasilla: unBloque [
	accionClicDerecho := unBloque.
]

{ #category : 'accessing' }
PiramideMorph >> alSeleccionarCasilla: unBloque [
	accionSeleccionar := unBloque.
]

{ #category : 'initialization' }
PiramideMorph >> initialize [
	super initialize.
	self extent: 660 @ 420.
	self color: Color transparent.
]

{ #category : 'accessing' }
PiramideMorph >> piramide: unaPiramide [
	piramide := unaPiramide.
	self actualizarConSeleccion: #().
]
