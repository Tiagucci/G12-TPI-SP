Class {
	#name : 'Eliminacion67',
	#superclass : 'Eliminacion',
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'as yet unclassified' }
Eliminacion67 >> aplicarEfectoExtraEn: unaPartida [
	unaPartida activarComboSeisSiete.
]

{ #category : 'operation' }
Eliminacion67 >> esValidaPara: unasCartas [
	| valores |
	(super esValidaPara: unasCartas) ifFalse: [ ^ false ].
	valores := unasCartas collect: [ :c | c valor ].
	^ (valores includes: 6) and: [ valores includes: 7 ].
]
