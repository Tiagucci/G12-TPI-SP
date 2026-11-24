"
Es la piramide de arriba
-TERMINADO-LC
"
Class {
	#name : 'Piramide',
	#superclass : 'Object',
	#instVars : [
		'casillas',
		'cantidadFilas'
	],
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'initialization' }
Piramide >> armarCon: unMazo [
	"Distribuye 28 cartas en 7 filas superpuestas (fila 1 tiene 1 carta, fila 7 tiene 7)"
	| cartasNecesarias |
	unMazo ifNil: [ self error: 'No se puede armar la pirámide sin un mazo.' ].
	cartasNecesarias := (cantidadFilas * (cantidadFilas + 1)) // 2.
	unMazo cantidadCartas < cartasNecesarias
		ifTrue: [ self error: 'El mazo no contiene suficientes cartas para armar la pirámide.' ].

	casillas removeAll.
	1 to: cantidadFilas do: [ :fila |
		1 to: fila do: [ :columna |
			| carta nuevaCasilla |
			carta := unMazo sacarCarta.
			nuevaCasilla := Casilla new
				carta: carta
				fila: fila
				columna: columna
				piramide: self.
			casillas add: nuevaCasilla ] ].
	^ self
]

{ #category : 'accessing' }
Piramide >> cantidadFilas [
	^ cantidadFilas.
]

{ #category : 'initialization' }
Piramide >> casillaEn: unaFila columna: unaColumna [
	"Busca y devuelve la casilla en esa posición, o nil si no existe"
	^ casillas 
		detect: [ :c | c fila = unaFila and: [ c columna = unaColumna ] ] 
		ifNone: [ nil ].
]

{ #category : 'accessing' }
Piramide >> casillas [
	^ casillas.
]

{ #category : 'initialization' }
Piramide >> casillasLibres [
	^ casillas select: [ :c | c esLibre ].
]

{ #category : 'initialization' }
Piramide >> estaVacia [
	^ casillas allSatisfy: [ :c | c estaEliminada ].
]

{ #category : 'accessing' }
Piramide >> filas [
	^ (1 to: 7) collect: [ :f |
		casillas select: [ :c | c fila = f ] ].
]

{ #category : 'initialization' }
Piramide >> hayCombinacionPosible [
	"Verifica si entre las casillas libres hay algún Rey o alguna pareja que sume 13"
	| libres |
	libres := self casillasLibres.
	(libres anySatisfy: [ :casilla | casilla carta esRey ]) ifTrue: [ ^ true ].

	1 to: libres size do: [ :indice |
		indice + 1 to: libres size do: [ :otroIndice |
			((libres at: indice) carta suma13Con: (libres at: otroIndice) carta)
				ifTrue: [ ^ true ] ] ].
	^ false.
]

{ #category : 'initialization' }
Piramide >> initialize [
	super initialize.
	cantidadFilas := 7.
	casillas := OrderedCollection new.
]
