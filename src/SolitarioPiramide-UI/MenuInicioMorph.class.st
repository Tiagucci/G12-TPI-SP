Class {
	#name : 'MenuInicioMorph',
	#superclass : 'Morph',
	#instVars : [
		'labelRecord',
		'accionIniciar',
		'accionAyuda',
		'accionSalir'
	],
	#category : 'SolitarioPiramide-UI',
	#package : 'SolitarioPiramide-UI'
}

{ #category : 'examples' }
MenuInicioMorph class >> ejemploMenuAislado [
	"Abre solo el menú de inicio con un récord de muestra."
	<example>
	| menu |
	menu := self new.
	menu record: 1250.
	menu alIniciar: [ Transcript show: 'Click en Iniciar Partida'; cr ].
	menu alPedirAyuda: [ Transcript show: 'Click en Cómo Jugar'; cr ].
	menu alSalir: [ menu delete ].
	menu position: 80 @ 40.
	menu openInWorld.
	^ menu
]

{ #category : 'accessing' }
MenuInicioMorph >> alIniciar: unBloque [
	accionIniciar := unBloque.
]

{ #category : 'accessing' }
MenuInicioMorph >> alPedirAyuda: unBloque [
	accionAyuda := unBloque.
]

{ #category : 'accessing' }
MenuInicioMorph >> alSalir: unBloque [
	accionSalir := unBloque.
]

{ #category : 'initialize' }
MenuInicioMorph >> construirContenido [
	| fuenteTitulo fuenteRecord titulo adorno btnJugar btnAyuda btnSalir |
	fuenteTitulo := LogicalFont familyName: 'Source Sans Pro' pointSize: 48.
	fuenteRecord := LogicalFont familyName: 'Source Sans Pro' pointSize: 16.

	titulo := StringMorph contents: 'SOLITARIO PIRÁMIDE' font: fuenteTitulo emphasis: 1.
	titulo color: Color white.
	titulo center: self center - (0 @ 135).

	adorno := self crearAdornoTitulo.
	adorno center: self center - (0 @ 82).

	labelRecord := StringMorph contents: 'Récord histórico: 0' font: fuenteRecord emphasis: 1.
	labelRecord color: (Color r: 1.0 g: 0.84 b: 0.25).
	labelRecord center: self center - (0 @ 42).

	btnJugar := self crearBoton: 'Iniciar Partida' extent: 230 @ 46 color: (Color r: 0.16 g: 0.56 b: 0.38).
	btnJugar center: self center + (0 @ 22).
	btnJugar on: #mouseDown send: #value to: [ accionIniciar ifNotNil: [ accionIniciar value ] ].

	btnAyuda := self crearBoton: 'Cómo Jugar y Reglas' extent: 230 @ 46 color: (Color r: 0.20 g: 0.32 b: 0.48).
	btnAyuda center: self center + (0 @ 84).
	btnAyuda on: #mouseDown send: #value to: [ accionAyuda ifNotNil: [ accionAyuda value ] ].

	btnSalir := self crearBotonSalir.
	btnSalir position: self position + (888 @ 16).
	btnSalir on: #mouseDown send: #value to: [ accionSalir ifNotNil: [ accionSalir value ] ].

	self
		addMorph: titulo;
		addMorph: adorno;
		addMorph: labelRecord;
		addMorph: btnJugar;
		addMorph: btnAyuda;
		addMorph: btnSalir.
]

{ #category : 'initialize' }
MenuInicioMorph >> crearAdornoTitulo [
	| surface form |
	surface := AthensCairoSurface extent: 340 @ 16.
	surface drawDuring: [ :canvas |
		| linea rombo |
		linea := canvas createPath: [ :builder |
			builder
				absolute;
				moveTo: 10.0 @ 8.0;
				lineTo: 148.0 @ 8.0;
				moveTo: 192.0 @ 8.0;
				lineTo: 330.0 @ 8.0 ].
		(canvas setStrokePaint: (Color r: 0.92 g: 0.72 b: 0.15 alpha: 0.75)) width: 1.8.
		canvas drawShape: linea.

		rombo := canvas createPath: [ :builder |
			builder
				absolute;
				moveTo: 170.0 @ 2.0;
				lineTo: 177.0 @ 8.0;
				lineTo: 170.0 @ 14.0;
				lineTo: 163.0 @ 8.0;
				close ].
		canvas setPaint: (Color r: 0.92 g: 0.72 b: 0.15).
		canvas drawShape: rombo ].
	form := surface asForm asFormOfDepth: 32.
	^ form asMorph.
]

{ #category : 'initialize' }
MenuInicioMorph >> crearBoton: unTexto extent: unTamano color: unColor [
	| surface form boton fuente label |
	surface := AthensCairoSurface extent: unTamano.
	surface drawDuring: [ :canvas |
		| w h r path |
		w := unTamano x asFloat.
		h := unTamano y asFloat.
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
	fuente := LogicalFont familyName: 'Source Sans Pro' pointSize: 14.
	label := StringMorph contents: unTexto font: fuente emphasis: 1.
	label color: Color white.
	label center: boton center.
	boton addMorph: label.
	^ boton.
]

{ #category : 'initialize' }
MenuInicioMorph >> crearBotonSalir [
	| surface form boton |
	surface := AthensCairoSurface extent: 32 @ 32.
	surface drawDuring: [ :canvas |
		| w h r m path cruz |
		w := 32.0.
		h := 32.0.
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
		canvas setPaint: (Color r: 0.72 g: 0.20 b: 0.22).
		canvas drawShape: path.

		m := 10.0.
		cruz := canvas createPath: [ :builder |
			builder
				absolute;
				moveTo: m @ m;
				lineTo: (w - m) @ (h - m);
				moveTo: (w - m) @ m;
				lineTo: m @ (h - m) ].
		(canvas setStrokePaint: Color white) width: 2.5.
		canvas drawShape: cruz ].
	form := surface asForm asFormOfDepth: 32.
	boton := form asMorph.
	^ boton.
]

{ #category : 'initialize' }
MenuInicioMorph >> initialize [
	super initialize.
	self extent: 936 @ 646.
	self color: (Color r: 0.08 g: 0.12 b: 0.18).
	self construirContenido.
]

{ #category : 'accessing' }
MenuInicioMorph >> record: unNumero [
	labelRecord contents: 'Récord histórico: ' , unNumero asString.
	labelRecord center: self center - (0 @ 42).
]
