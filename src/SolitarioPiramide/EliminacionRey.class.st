"
Subclase de Eliminacion, usada para eliminar una carta Rey (K), que vale 13
"
Class {
	#name : 'EliminacionRey',
	#superclass : 'Eliminacion',
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'operation' }
EliminacionRey >> cantidadRequerida [
	^1.
]

{ #category : 'operation' }
EliminacionRey >> esValidaPara: unasCartas [
	^ unasCartas size = 1 and: [ unasCartas first esRey ].
]
