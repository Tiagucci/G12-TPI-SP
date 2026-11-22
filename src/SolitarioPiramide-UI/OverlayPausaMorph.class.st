Class {
	#name : 'OverlayPausaMorph',
	#superclass : 'Morph',
	#instVars : [
		'accionReanudar',
		'accionAyuda',
		'accionMenu'
	],
	#category : 'SolitarioPiramide-UI',
	#package : 'SolitarioPiramide-UI'
}

{ #category : 'accessing' }
OverlayPausaMorph >> alPedirAyuda: unBloque [
	accionAyuda := unBloque.
]

{ #category : 'accessing' }
OverlayPausaMorph >> alReanudar: unBloque [
	accionReanudar := unBloque.
]

{ #category : 'accessing' }
OverlayPausaMorph >> alVolverMenu: unBloque [
	accionMenu := unBloque.
]

{ #category : 'initialization' }
OverlayPausaMorph >> construirContenido [
	| fuente titulo btnReanudar btnAyuda btnMenu |
	fuente := LogicalFont familyName: 'Source Sans Pro' pointSize: 24.
	titulo := StringMorph contents: 'JUEGO EN PAUSA' font: fuente emphasis: 1.
	titulo color: Color white.
	titulo center: self center - (0 @ 110).

	btnReanudar := self crearBoton: 'Reanudar Partida' color: (Color r: 0.16 g: 0.56 b: 0.38).
	btnReanudar center: self center - (0 @ 35).
	btnReanudar on: #mouseDown send: #value to: [ accionReanudar ifNotNil: [ accionReanudar value ] ].

	btnAyuda := self crearBoton: 'Reglas y Poderes' color: (Color r: 0.20 g: 0.32 b: 0.48).
	btnAyuda center: self center + (0 @ 25).
	btnAyuda on: #mouseDown send: #value to: [ accionAyuda ifNotNil: [ accionAyuda value ] ].

	btnMenu := self crearBoton: 'Menú Principal' color: (Color r: 0.58 g: 0.20 b: 0.22).
	btnMenu center: self center + (0 @ 85).
	btnMenu on: #mouseDown send: #value to: [ accionMenu ifNotNil: [ accionMenu value ] ].

	self
		addMorph: titulo;
		addMorph: btnReanudar;
		addMorph: btnAyuda;
		addMorph: btnMenu.
]

{ #category : 'initialization' }
OverlayPausaMorph >> crearBoton: unTexto color: unColor [
	| surface form boton fuente label tamano |
	tamano := 220 @ 42.
	surface := AthensCairoSurface extent: tamano.
	surface drawDuring: [ :canvas |
		| w h r path |
		w := tamano x asFloat.
		h := tamano y asFloat.
		r := 10.0.
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
		canvas drawShape: path ].
	form := surface asForm asFormOfDepth: 32.
	boton := form asMorph.
	fuente := LogicalFont familyName: 'Source Sans Pro' pointSize: 13.
	label := StringMorph contents: unTexto font: fuente emphasis: 1.
	label color: Color white.
	label center: boton center.
	boton addMorph: label.
	^ boton.
]

{ #category : 'initialization' }
OverlayPausaMorph >> initialize [
	super initialize.
	self extent: 936 @ 570.
	self color: (Color r: 0.06 g: 0.09 b: 0.14 alpha: 0.96).
	self construirContenido.
]
