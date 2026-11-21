"
Clase utilizada para efectivizar el Reciclaje de la Partida
"
Class {
	#name : 'EfectoQuitarReciclaje',
	#superclass : 'EfectoRey',
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'accessing' }
EfectoQuitarReciclaje >> aplicarEn: unaPartida [
	unaPartida mazoAuxiliar consumirReciclaje.
]

{ #category : 'initialization' }
EfectoQuitarReciclaje >> initialize [
	super initialize.
	esPositivo := false.
	nombre := 'Decreto Real: ¡Pierdes 1 reciclaje del mazo!'.
]
