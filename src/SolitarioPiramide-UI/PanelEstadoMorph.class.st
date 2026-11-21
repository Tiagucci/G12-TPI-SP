Class {
	#name : 'PanelEstadoMorph',
	#superclass : 'Morph',
	#instVars : [
		'labelPuntaje',
		'labelRacha',
		'labelRecord',
		'labelTiempo',
		'botonReiniciar'
	],
	#category : 'SolitarioPiramide-UI',
	#package : 'SolitarioPiramide-UI'
}

{ #category : 'updating' }
PanelEstadoMorph >> actualizarCon: unaPartida [
	| restantes |
	unaPartida ifNil: [ ^ self ].

	labelPuntaje contents: 'Puntaje: ' , unaPartida puntaje total asString.
	labelRacha contents: 'Racha: x' , unaPartida puntaje rachaActual asString.
	labelRecord contents: 'Récord: ' , unaPartida registro mejorPuntaje asString.

	restantes := unaPartida cronometro tiempoRestante.
	unaPartida estaEnCamaraLenta
		ifTrue: [
			labelTiempo contents: 'SLOW-MO 0.5x | ' , restantes asString , 's'.
			labelTiempo color: Color cyan ]
		ifFalse: [
			labelTiempo contents: 'Tiempo: ' , restantes asString , 's'.
			labelTiempo color: (restantes <= 30
				ifTrue: [ Color r: 0.95 g: 0.30 b: 0.30 ]
				ifFalse: [ Color white ]) ].
]

{ #category : 'accessing' }
PanelEstadoMorph >> alReiniciar: unBloque [
	botonReiniciar
		target: unBloque;
		actionSelector: #value.
]

{ #category : 'initialization' }
PanelEstadoMorph >> construirComponentes [
	| fuente |
	fuente := LogicalFont familyName: 'Source Sans Pro' pointSize: 13.

	labelPuntaje := StringMorph contents: 'Puntaje: 0' font: fuente emphasis: 1.
	labelPuntaje color: Color white.
	labelPuntaje position: self position + (24 @ 18).

	labelRacha := StringMorph contents: 'Racha: x0' font: fuente emphasis: 1.
	labelRacha color: (Color r: 1.0 g: 0.84 b: 0.25).
	labelRacha position: self position + (185 @ 18).

	labelRecord := StringMorph contents: 'Récord: 0' font: fuente emphasis: 1.
	labelRecord color: (Color r: 0.45 g: 0.90 b: 0.60).
	labelRecord position: self position + (330 @ 18).

	labelTiempo := StringMorph contents: 'Tiempo: 300s' font: fuente emphasis: 1.
	labelTiempo color: Color white.
	labelTiempo position: self position + (495 @ 18).

	botonReiniciar := SimpleButtonMorph new.
	botonReiniciar label: 'Nueva Partida'.
	botonReiniciar color: (Color r: 0.16 g: 0.48 b: 0.34).
	botonReiniciar borderWidth: 0.
	botonReiniciar extent: 125 @ 32.
	botonReiniciar position: self position + (750 @ 12).

	self
		addMorph: labelPuntaje;
		addMorph: labelRacha;
		addMorph: labelRecord;
		addMorph: labelTiempo;
		addMorph: botonReiniciar.
]

{ #category : 'initialization' }
PanelEstadoMorph >> dibujarFondo [
	| surface fondoForm |
	surface := AthensCairoSurface extent: self extent.
	surface drawDuring: [ :canvas |
		| w h r m path |
		w := self width asFloat.
		h := self height asFloat.
		r := 12.0.
		m := 1.5.
		path := canvas createPath: [ :builder |
			builder
				absolute;
				moveTo: (m + r) @ m;
				lineTo: (w - m - r) @ m;
				curveVia: (w - m) @ m to: (w - m) @ (m + r);
				lineTo: (w - m) @ (h - m - r);
				curveVia: (w - m) @ (h - m) to: (w - m - r) @ (h - m);
				lineTo: (m + r) @ (h - m);
				curveVia: m @ (h - m) to: m @ (h - m - r);
				lineTo: m @ (m + r);
				curveVia: m @ m to: (m + r) @ m;
				close ].
		canvas setPaint: (Color r: 0.07 g: 0.10 b: 0.15 alpha: 0.92).
		canvas drawShape: path.
		(canvas setStrokePaint: (Color white alpha: 0.18)) width: 1.5.
		canvas drawShape: path ].
	fondoForm := surface asForm.
	self addMorph: (fondoForm asMorph position: self position).
]

{ #category : 'initialization' }
PanelEstadoMorph >> initialize [
	super initialize.
	self extent: 900 @ 56.
	self color: Color transparent.
	self borderWidth: 0.
	self dibujarFondo.
	self construirComponentes.
]
