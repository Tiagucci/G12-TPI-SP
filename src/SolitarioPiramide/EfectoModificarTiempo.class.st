"
Clase utilizada para modificar en n segundos al tiempo de la Partida
"
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

{ #category : 'accessing' }
EfectoModificarTiempo >> aplicarEn: unaPartida [
	unaPartida cronometro agregarTiempo: segundos.
]
