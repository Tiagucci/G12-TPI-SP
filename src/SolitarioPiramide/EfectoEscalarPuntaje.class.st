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

{ #category : 'accessing' }
EfectoEscalarPuntaje class >> factor: unNumero [
	^ self new factor: unNumero; yourself.
]

{ #category : 'accessing' }
EfectoEscalarPuntaje >> aplicarEn: unaPartida [
	| actual nuevo |
	actual := unaPartida puntaje total.
	nuevo := (actual * factor) rounded.
	unaPartida puntaje sumarBonificacion: (nuevo - actual).
]

{ #category : 'accessing' }
EfectoEscalarPuntaje >> factor: unNumero [
	factor := unNumero.
	esPositivo := unNumero >= 1.
	nombre := esPositivo
		ifTrue: [ 'Fortuna Real: ¡Puntaje x2!' ]
		ifFalse: [ 'Impuesto Real: Puntaje dividido a la mitad' ].
]
