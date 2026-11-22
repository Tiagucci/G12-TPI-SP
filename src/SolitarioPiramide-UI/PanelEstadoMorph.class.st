Class {
	#name : 'PanelEstadoMorph',
	#superclass : 'Morph',
	#instVars : [
		'labelPuntaje',
		'labelRacha',
		'labelRecord',
		'labelTiempo',
		'botonReiniciar',
		'botonSalir'
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
	botonReiniciar on: #mouseDown send: #value to: unBloque.
]

{ #category : 'accessing' }
PanelEstadoMorph >> alSalir: unBloque [
	botonSalir on: #mouseDown send: #value to: unBloque.
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

	botonReiniciar := self
		crearBotonTexto: 'Nueva Partida'
		extent: 124 @ 32
		color: (Color r: 0.16 g: 0.52 b: 0.36).
	botonReiniciar position: self position + (712 @ 12).

	botonSalir := self
		crearBotonTexto: 'X'
		extent: 32 @ 32
		color: (Color r: 0.72 g: 0.20 b: 0.22).
	botonSalir position: self position + (848 @ 12).

	self
		addMorph: labelPuntaje;
		addMorph: labelRacha;
		addMorph: labelRecord;
		addMorph: labelTiempo;
		addMorph: botonReiniciar;
		addMorph: botonSalir.
]

{ #category : 'initialization' }
PanelEstadoMorph >> crearBotonTexto: unTexto extent: unTamano color: unColor [
	| surface form boton fuente label |
	surface := AthensCairoSurface extent: unTamano.
	surface drawDuring: [ :canvas |
		| w h r path |
		w := unTamano x asFloat.
		h := unTamano y asFloat.
		r := 8.0.
		path := canvas createPath: [ :builder |
			builder
				absolute;
				moveTo: r @ 0.0;
				lineTo: (w - r) @ 0.0;
				curveVia: w @ 0.0 to: w @ r;
				lineTo: w @ (h - r);
				curveVia: w @ h to: (w - r) @ h;
				lineTo: r @ h;
				curveVia: 0.0 @ h to: 0.0 @ (h - r);
				lineTo: 0.0 @ r;
				curveVia: 0.0 @ 0.0 to: r @ 0.0;
				close ].
		canvas setPaint: unColor.
		canvas drawShape: path.

		unTexto = 'X' ifTrue: [
			| cruz m |
			m := 10.0.
			cruz := canvas createPath: [ :builder |
				builder
					absolute;
					moveTo: m @ m;
					lineTo: (w - m) @ (h - m);
					moveTo: (w - m) @ m;
					lineTo: m @ (h - m) ].
			(canvas setStrokePaint: Color white) width: 2.5.
			canvas drawShape: cruz ] ].

	form := surface asForm asFormOfDepth: 32.
	boton := form asMorph.

	unTexto = 'X' ifFalse: [
		fuente := LogicalFont familyName: 'Source Sans Pro' pointSize: 12.
		label := StringMorph contents: unTexto font: fuente emphasis: 1.
		label color: Color white.
		label center: boton center.
		boton addMorph: label ].

	^ boton.
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
	fondoForm := surface asForm asFormOfDepth: 32.
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
