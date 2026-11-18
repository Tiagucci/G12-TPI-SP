Class {
	#name : 'EfectoRey',
	#superclass : 'Object',
	#instVars : [
		'nombre',
		'esPositivo'
	],
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'as yet unclassified' }
EfectoRey class >> aleatorio [
	| opciones |
	opciones := {
		EfectoModificarTiempo segundos: 25.      "Bueno 1: +25s"
		EfectoModificarTiempo segundos: -20.     "Malo 1: -20s"
		EfectoEscalarPuntaje factor: 2.          "Bueno 2: Puntaje x2"
		EfectoEscalarPuntaje factor: 0.5.        "Malo 2: Puntaje /2"
		EfectoEliminarCartaLibre new.            "Bueno 3: Elimina 1 carta libre"
		EfectoQuitarReciclaje new.               "Malo 3: Pierde 1 vuelta al mazo"
	}.
	^ opciones atRandom.
]

{ #category : 'as yet unclassified' }
EfectoRey >> aplicarEn: unaPartida [
	self subclassResponsibility.
]

{ #category : 'accessing' }
EfectoRey >> esPositivo [
	^ esPositivo.
]

{ #category : 'accessing' }
EfectoRey >> nombre [
	^ nombre.
]
