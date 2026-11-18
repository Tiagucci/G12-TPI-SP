Class {
	#name : 'EfectoModificarTiempo',
	#superclass : 'EfectoRey',
	#instVars : [
		'segundos'
	],
	#classInstVars : [
		'segundos'
	],
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'as yet unclassified' }
EfectoModificarTiempo >> aplicarEn: unaPartida [
	unaPartida cronometro agregarTiempo: segundos.
]
