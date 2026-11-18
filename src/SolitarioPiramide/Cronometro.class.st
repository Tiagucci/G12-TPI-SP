"
Cronometro que al terminar se pierde, se puede pausar y reanudar y modificar con el uso de las K
-TERMINAR-LC
18/11 agregado las cosas para el 67
"
Class {
	#name : 'Cronometro',
	#superclass : 'Object',
	#instVars : [
		'tiempoLimite',
		'tiempoTranscurrido',
		'corriendo',
		'factorVelocidad',
		'segundosRalentizados'
	],
	#category : 'SolitarioPiramide',
	#package : 'SolitarioPiramide'
}

{ #category : 'as yet unclassified' }
Cronometro >> activarRalentizacion: duracionRealSeconds factor: unFactor [
	"Ejemplo: 6 segundos reales a factor 0.5 hacen que pasen solo 3 segundos de juego"
	segundosRalentizados := duracionRealSeconds.
	factorVelocidad := unFactor.
]

{ #category : 'initialization' }
Cronometro >> agregarTiempo: unosSegundos [
	"Soporta valores positivos (bonus de K) y negativos (penalización de K).
	Reduce o aumenta el tiempo transcurrido manteniendo los límites válidos."
	tiempoTranscurrido := ((tiempoTranscurrido - unosSegundos) max: 0) min: tiempoLimite.
]

{ #category : 'initialization' }
Cronometro >> avanzar: unosSegundos [
	(corriendo and: [ self seAgoto not ]) ifFalse: [ ^ self ].
	
	tiempoTranscurrido := (tiempoTranscurrido + (unosSegundos * factorVelocidad)) min: tiempoLimite.
	
	self estaRalentizado ifTrue: [
		segundosRalentizados := (segundosRalentizados - unosSegundos) max: 0.
		segundosRalentizados = 0 ifTrue: [ factorVelocidad := 1.0 ].
	].
]

{ #category : 'accessing' }
Cronometro >> corriendo [
	^ corriendo.
]

{ #category : 'as yet unclassified' }
Cronometro >> estaRalentizado [
	^ segundosRalentizados > 0.
]

{ #category : 'initialization' }
Cronometro >> iniciar [
	tiempoTranscurrido := 0.
	corriendo := true.
]

{ #category : 'initialization' }
Cronometro >> initialize [
	super initialize.
	tiempoLimite := 300.
	tiempoTranscurrido := 0.
	corriendo := false.
	factorVelocidad := 1.0.
	segundosRalentizados := 0.
]

{ #category : 'initialization' }
Cronometro >> pausar [
	corriendo := false.
]

{ #category : 'initialization' }
Cronometro >> reanudar [
	corriendo := true.
]

{ #category : 'initialization' }
Cronometro >> seAgoto [
	^ self tiempoRestante <= 0.
]

{ #category : 'accessing' }
Cronometro >> tiempoLimite [
	^ tiempoLimite.
]

{ #category : 'accessing' }
Cronometro >> tiempoLimite: unosSegundos [
	tiempoLimite := unosSegundos.
]

{ #category : 'initialization' }
Cronometro >> tiempoRestante [
	"Devuelve entero redondeado para mostrar limpio en pantalla"
	^ ((tiempoLimite - tiempoTranscurrido) max: 0) ceiling.
]

{ #category : 'accessing' }
Cronometro >> tiempoTranscurrido [
	^ tiempoTranscurrido.
]
