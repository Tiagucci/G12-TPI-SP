"
Clase utilizada para eliminar una carta libre, al azar, en la Partida
"
Class {
	#name : 'EfectoEliminarCartaLibre',
	#superclass : 'EfectoRey',
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'accessing' }
EfectoEliminarCartaLibre >> aplicarEn: unaPartida [
	| libres |
	libres := unaPartida piramide casillasLibres.
	libres ifNotEmpty: [
		libres atRandom eliminar.
		unaPartida puntaje sumarPorEliminacion: 1 ].
]

{ #category : 'initialization' }
EfectoEliminarCartaLibre >> initialize [
	super initialize.
	esPositivo := true.
	nombre := 'Golpe Real: ¡Carta libre eliminada al azar!'.
]
