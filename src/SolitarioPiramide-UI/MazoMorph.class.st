Class {
	#name : 'MazoMorph',
	#superclass : 'Morph',
	#instVars : [
		'mazoAuxiliar',
		'cartaRoboMorph',
		'cartaDescarteMorph',
		'labelInfo',
		'accionRobar',
		'accionSeleccionarDescarte'
	],
	#category : 'SolitarioPiramide-UI',
	#package : 'SolitarioPiramide-UI'
}

{ #category : 'updating' }
MazoMorph >> actualizar [
	| etiquetaReciclar fuenteReciclar |
	mazoAuxiliar ifNil: [ ^ self ].

	"1. Actualizar pila de robo (izquierda)"
	mazoAuxiliar estaVacio
		ifTrue: [
			cartaRoboMorph bocaArriba: true.
			cartaRoboMorph carta: nil.
			mazoAuxiliar puedeReciclar ifTrue: [
				fuenteReciclar := LogicalFont familyName: 'Source Sans Pro' pointSize: 12.
				etiquetaReciclar := StringMorph contents: 'Reciclar' font: fuenteReciclar emphasis: 1.
				etiquetaReciclar color: Color yellow.
				etiquetaReciclar center: cartaRoboMorph center.
				cartaRoboMorph addMorph: etiquetaReciclar ] ]
		ifFalse: [
			cartaRoboMorph bocaArriba: false ].

	"2. Actualizar carta visible del descarte (derecha)"
	cartaDescarteMorph carta: mazoAuxiliar cartaVisible.

	"3. Actualizar contador inferior"
	labelInfo contents:
		'Cartas: ' , mazoAuxiliar cantidadCartas asString ,
		'  |  Vueltas: ' , mazoAuxiliar reciclajesRestantes asString.
]

{ #category : 'accessing' }
MazoMorph >> alRobar: unBloque [
	accionRobar := unBloque.
]

{ #category : 'accessing' }
MazoMorph >> alSeleccionarDescarte: unBloque [
	accionSeleccionarDescarte := unBloque.
]

{ #category : 'initialization' }
MazoMorph >> initialize [
	| fuenteInfo |
	super initialize.
	self extent: 185 @ 142.
	self color: Color transparent.

	cartaRoboMorph := CartaMorph new.
	cartaRoboMorph bocaArriba: false.
	cartaRoboMorph position: self position.
	cartaRoboMorph alHacerClic: [
		accionRobar ifNotNil: [ accionRobar value ] ].

	cartaDescarteMorph := CartaMorph new.
	cartaDescarteMorph carta: nil.
	cartaDescarteMorph position: self position + (100 @ 0).
	cartaDescarteMorph alHacerClic: [
		accionSeleccionarDescarte ifNotNil: [ accionSeleccionarDescarte value ] ].

	fuenteInfo := LogicalFont familyName: 'Source Sans Pro' pointSize: 11.
	labelInfo := StringMorph contents: 'Mazo: 0 | Vueltas: 0' font: fuenteInfo.
	labelInfo color: Color white.
	labelInfo position: self position + (4 @ 120).

	self
		addMorph: cartaRoboMorph;
		addMorph: cartaDescarteMorph;
		addMorph: labelInfo.
]

{ #category : 'accessing' }
MazoMorph >> mazoAuxiliar: unMazoAuxiliar [
	mazoAuxiliar := unMazoAuxiliar.
	self actualizar.

]
