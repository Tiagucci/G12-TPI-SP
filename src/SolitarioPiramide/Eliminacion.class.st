"
Eliminacion es una clase abstracta, diseñada para contener subclases, así hacer uso del Polimorfismo
"
Class {
	#name : 'Eliminacion',
	#superclass : 'Object',
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'as yet unclassified' }
Eliminacion >> aplicarEfectoExtraEn: unaPartida [
	"Por defecto las eliminaciones normales no disparan efectos especiales"
	^ self.
]

{ #category : 'operation' }
Eliminacion >> esValidaPara: unasCartas [
	self subclassResponsibility.
]
