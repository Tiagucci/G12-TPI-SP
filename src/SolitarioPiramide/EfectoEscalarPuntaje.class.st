"
Clase utilizada para aplicar bonificación x2 de Puntaje en la Partida
"
Class {
	#name : 'EfectoEscalarPuntaje',
	#superclass : 'EfectoRey',
	#instVars : [
		'factor'
	],
	#classInstVars : [
		'factor'
	],
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'instance creation' }
EfectoEscalarPuntaje class >> factor: unFactor [
	^ self new
		factor: unFactor;
		yourself.
]

{ #category : 'accessing' }
EfectoEscalarPuntaje >> aplicarEn: unaPartida [
	| actual nuevo |
	actual := unaPartida puntaje total.
	nuevo := (actual * factor) rounded.
	unaPartida puntaje sumarBonificacion: (nuevo - actual).
]

{ #category : 'accessing' }
EfectoEscalarPuntaje >> esPositivo [
	^ factor > 1.
]

{ #category : 'accessing' }
EfectoEscalarPuntaje >> factor: unFactor [
	factor := unFactor.
]

{ #category : 'accessing' }
EfectoEscalarPuntaje >> nombre [
	^ factor > 1
		ifTrue: [ 'Tesoro Real: ¡Puntaje multiplicado x' , factor asString , '!' ]
		ifFalse: [ 'Impuesto Real: ¡Puntaje reducido a la mitad!' ].
]
