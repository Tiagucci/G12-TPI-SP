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

{ #category : 'instance creation' }
EfectoModificarTiempo class >> segundos: unosSegundos [
	^ self new
		segundos: unosSegundos;
		yourself.
]

{ #category : 'accessing' }
EfectoModificarTiempo >> aplicarEn: unaPartida [
	unaPartida cronometro agregarTiempo: segundos.
]

{ #category : 'accessing' }
EfectoModificarTiempo >> esPositivo [
	^ segundos > 0.
]

{ #category : 'accessing' }
EfectoModificarTiempo >> nombre [
	^ segundos > 0
		ifTrue: [ 'Bendición del Tiempo: +' , segundos asString , ' segundos' ]
		ifFalse: [ 'Maldición del Reloj: ' , segundos asString , ' segundos' ].
]

{ #category : 'accessing' }
EfectoModificarTiempo >> segundos: unosSegundos [
	segundos := unosSegundos.
]
