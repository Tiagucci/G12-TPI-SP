"
Clase utilizada para verificar y efectivizar el efecto Rey (eliminar sola)
"
Class {
	#name : 'Eliminacion67',
	#superclass : 'EliminacionPareja',
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'accessing' }
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
