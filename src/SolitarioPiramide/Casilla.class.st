"
Representa el espacio donde estan las cartas
-TERMINADO-LC
"
Class {
	#name : 'Casilla',
	#superclass : 'Object',
	#instVars : [
		'carta',
		'fila',
		'columna',
		'eliminada',
		'piramide'
	],
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'accessing' }
Casilla >> carta [
	^ carta.
]

{ #category : 'initialization' }
Casilla >> carta: unaCarta fila: unaFila columna: unaColumna piramide: unaPiramide [
	carta := unaCarta.
	fila := unaFila.
	columna := unaColumna.
	piramide := unaPiramide.
	^ self
]

{ #category : 'initialization' }
Casilla >> casillasQueLaCubren [
	"Devuelve las dos casillas hijas de la fila inferior inmediata"
	| hijas |
	hijas := OrderedCollection new.
	fila < piramide cantidadFilas ifTrue: [
		(piramide casillaEn: fila + 1 columna: columna)
			ifNotNil: [ :casillaHija | hijas add: casillaHija ].
		(piramide casillaEn: fila + 1 columna: columna + 1)
			ifNotNil: [ :casillaHija | hijas add: casillaHija ] ].
	^ hijas.
]

{ #category : 'accessing' }
Casilla >> columna [
	^ columna.
]

{ #category : 'initialization' }
Casilla >> eliminar [
	eliminada := true.
]

{ #category : 'initialization' }
Casilla >> esLibre [
	"Una casilla puede ser seleccionada si tiene carta, no fue eliminada y no está cubierta"
	^ self estaEliminada not and: [ self estaCubierta not ].
]

{ #category : 'initialization' }
Casilla >> estaCubierta [
	"Está cubierta si alguna de sus dos casillas hijas sigue activa en el juego"
	^ self casillasQueLaCubren
		anySatisfy: [ :cadaHija | cadaHija estaVacia not ].
]

{ #category : 'initialization' }
Casilla >> estaEliminada [
	^ eliminada.
]

{ #category : 'initialization' }
Casilla >> estaVacia [
	^ carta isNil or: [ eliminada ].
]

{ #category : 'accessing' }
Casilla >> fila [
	^ fila.
]

{ #category : 'initialization' }
Casilla >> initialize [
	super initialize.
	eliminada := false.
]

{ #category : 'accessing' }
Casilla >> piramide [
	^ piramide.
]
