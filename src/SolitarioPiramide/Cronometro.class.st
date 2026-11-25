"
Cronometro que al terminar se pierde, se puede pausar y reanudar y modificar con el uso de las K
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

{ #category : 'accessing' }
Cronometro >> activarRalentizacion: duracionRealSeconds factor: unFactor [
	"Ejemplo: 6 segundos reales a factor 0.5 hacen que pasen solo 3 segundos de juego"
	duracionRealSeconds <= 0 ifTrue: [
		segundosRalentizados := 0.
		factorVelocidad := 1.0.
		^ self ].
	unFactor <= 0 ifTrue: [ self error: 'El factor de velocidad debe ser mayor que cero.' ].
	segundosRalentizados := duracionRealSeconds.
	factorVelocidad := unFactor.
]

{ #category : 'initialization' }
Cronometro >> agregarTiempo: unosSegundos [
	"Soporta valores positivos (bonus de K) y negativos (penalización de K).
	Reduce o aumenta el tiempo transcurrido manteniendo los límites válidos."
	tiempoTranscurrido := tiempoTranscurrido - unosSegundos.
]

{ #category : 'initialization' }
Cronometro >> avanzar: unosSegundos [
	| delta segundosEfectivos segundosConEfecto |
	(corriendo and: [ self seAgoto not ]) ifFalse: [ ^ self ].

	delta := unosSegundos max: 0.
	delta = 0 ifTrue: [ ^ self ].
	segundosEfectivos := delta.

	self estaRalentizado ifTrue: [
		"Solo se ralentiza la parte del intervalo que todavía está dentro del efecto."
		segundosConEfecto := segundosRalentizados min: delta.
		segundosEfectivos :=
			(segundosConEfecto * factorVelocidad)
				+ (delta - segundosConEfecto).
		segundosRalentizados := (segundosRalentizados - delta) max: 0.
		segundosRalentizados = 0 ifTrue: [ factorVelocidad := 1.0 ] ].

	tiempoTranscurrido := tiempoTranscurrido + segundosEfectivos.
	^ self
]

{ #category : 'accessing' }
Cronometro >> corriendo [
	^ corriendo.
]

{ #category : 'accessing' }
Cronometro >> estaRalentizado [
	^ segundosRalentizados > 0.
]

{ #category : 'initialization' }
Cronometro >> iniciar [
	tiempoTranscurrido := 0.
	corriendo := true.
	factorVelocidad := 1.0.
	segundosRalentizados := 0.
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
	tiempoLimite := unosSegundos max: 0.
]

{ #category : 'initialization' }
Cronometro >> tiempoRestante [
	"Devuelve entero redondeado para mostrar limpio en pantalla"
	^ (tiempoLimite - tiempoTranscurrido) ceiling max: 0.
]

{ #category : 'accessing' }
Cronometro >> tiempoTranscurrido [
	^ tiempoTranscurrido.
]
