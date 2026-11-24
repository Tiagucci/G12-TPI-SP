"
""Representa una carta del juego con su rango, palo y si está descubierta"".
-TERMINADO-LC
"
Class {
	#name : 'Carta',
	#superclass : 'Object',
	#instVars : [
		'rango',
		'palo',
		'bocaArriba'
	],
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'initialize' }
Carta class >> rango: unRango palo: unPalo [
	^ self new
		rango: unRango palo: unPalo;
		yourself.
]

{ #category : 'accessing' }
Carta >> esPaloRojo [
	^ #( #corazones #diamantes ) includes: palo
]

{ #category : 'accessing' }
Carta >> esRey [
	^ self valor = 13.
]

{ #category : 'initialize' }
Carta >> initialize [
	super initialize.
	bocaArriba := true.
]

{ #category : 'accessing' }
Carta >> palo [
	^ palo.
]

{ #category : 'initialize' }
Carta >> printOn: aStream [
	aStream
		nextPutAll: rango asString;
		nextPutAll: ' de ';
		nextPutAll: palo asString.
]

{ #category : 'accessing' }
Carta >> rango [
	^ rango.
]

{ #category : 'initialize' }
Carta >> rango: unRango palo: unPalo [
	rango := unRango.
	palo := unPalo.
]

{ #category : 'initialize' }
Carta >> suma13Con: otraCarta [
	otraCarta ifNil: [ ^ false ].
	^ (self valor + otraCarta valor) = 13.
]

{ #category : 'initialize' }
Carta >> valor [
	rango = 'A' ifTrue: [ ^ 1 ].
	rango = 'J' ifTrue: [ ^ 11 ].
	rango = 'Q' ifTrue: [ ^ 12 ].
	rango = 'K' ifTrue: [ ^ 13 ].
	rango isNumber ifTrue: [ ^ rango ].
	^ rango asInteger.
]
