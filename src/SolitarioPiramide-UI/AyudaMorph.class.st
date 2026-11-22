Class {
	#name : 'AyudaMorph',
	#superclass : 'Morph',
	#instVars : [
		'botonVolver',
		'accionVolver'
	],
	#category : 'SolitarioPiramide-UI',
	#package : 'SolitarioPiramide-UI'
}

{ #category : 'initialization' }
AyudaMorph >> agregarLinea: unTexto fuente: unaFuente emphasis: unEnfasis color: unColor pos: unPunto [
	| label |
	label := StringMorph contents: unTexto font: unaFuente emphasis: unEnfasis.
	label color: unColor.
	label position: self position + unPunto.
	self addMorph: label.
]

{ #category : 'accessing' }
AyudaMorph >> alVolver: unBloque [
	accionVolver := unBloque.
]

{ #category : 'initialization' }
AyudaMorph >> construirContenido [
	| fuenteTitulo fuenteSeccion fuenteTexto y |
	fuenteTitulo := LogicalFont familyName: 'Source Sans Pro' pointSize: 18.
	fuenteSeccion := LogicalFont familyName: 'Source Sans Pro' pointSize: 13.
	fuenteTexto := LogicalFont familyName: 'Source Sans Pro' pointSize: 11.

	self agregarLinea: 'CÓMO JUGAR — SOLITARIO PIRÁMIDE' fuente: fuenteTitulo emphasis: 1 color: Color white pos: 32 @ 24.

	y := 70.
	self agregarLinea: '1. Objetivo y Reglas Básicas' fuente: fuenteSeccion emphasis: 1 color: (Color r: 0.45 g: 0.90 b: 0.60) pos: 32 @ y.
	self agregarLinea: '• Despejá todas las cartas de la pirámide formando parejas que sumen 13.' fuente: fuenteTexto emphasis: 0 color: Color white pos: 44 @ (y + 24).
	self agregarLinea: '• Valores: As = 1, números 2 al 10 valen su número, J = 11, Q = 12, K = 13 (se va sola).' fuente: fuenteTexto emphasis: 0 color: Color white pos: 44 @ (y + 44).
	self agregarLinea: '• Solo podés seleccionar cartas libres (sin cartas tapándola abajo) o el descarte del mazo.' fuente: fuenteTexto emphasis: 0 color: Color white pos: 44 @ (y + 64).

	y := 168.
	self agregarLinea: '2. Controles' fuente: fuenteSeccion emphasis: 1 color: (Color r: 1.0 g: 0.84 b: 0.25) pos: 32 @ y.
	self agregarLinea: '• Clic izquierdo: Seleccionar carta, formar pareja con el descarte o robar del mazo.' fuente: fuenteTexto emphasis: 0 color: Color white pos: 44 @ (y + 24).
	self agregarLinea: '• Clic derecho sobre una K libre: Invocar un Decreto Real aleatorio.' fuente: fuenteTexto emphasis: 0 color: Color white pos: 44 @ (y + 44).

	y := 248.
	self agregarLinea: '3. Mecánicas Especiales' fuente: fuenteSeccion emphasis: 1 color: Color cyan pos: 32 @ y.
	self agregarLinea: '• Combo 6-7 (Bullet-Time): Al emparejar un 6 y un 7 ganás +67 pts extra y el reloj' fuente: fuenteTexto emphasis: 0 color: Color white pos: 44 @ (y + 24).
	self agregarLinea: '  se ralentiza a velocidad 0.5x durante unos segundos.' fuente: fuenteTexto emphasis: 0 color: Color white pos: 44 @ (y + 42).
	self agregarLinea: '• Decretos Reales de la K (50% positivos / 50% negativos):' fuente: fuenteTexto emphasis: 0 color: Color white pos: 44 @ (y + 66).
	self agregarLinea: '  + Bendición (+25s), Tesoro Real (Puntaje x2) o Golpe Real (elimina 1 carta libre).' fuente: fuenteTexto emphasis: 0 color: (Color r: 0.65 g: 0.95 b: 0.75) pos: 52 @ (y + 86).
	self agregarLinea: '  - Maldición (-20s), Impuesto Real (Puntaje /2) o Decreto Real (-1 vuelta al mazo).' fuente: fuenteTexto emphasis: 0 color: (Color r: 0.98 g: 0.55 b: 0.55) pos: 52 @ (y + 106).

	botonVolver := self crearBotonVolver.
	botonVolver position: self position + (260 @ 428).
	botonVolver on: #mouseDown send: #value to: [ accionVolver ifNotNil: [ accionVolver value ] ].
	self addMorph: botonVolver.
]

{ #category : 'initialization' }
AyudaMorph >> crearBotonVolver [
	| surface form boton fuente label tamano |
	tamano := 160 @ 38.
	surface := AthensCairoSurface extent: tamano.
	surface drawDuring: [ :canvas |
		| w h r path |
		w := tamano x asFloat.
		h := tamano y asFloat.
		r := 9.0.
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
		canvas setPaint: (Color r: 0.16 g: 0.52 b: 0.36).
		canvas drawShape: path ].
	form := surface asForm asFormOfDepth: 32.
	boton := form asMorph.

	fuente := LogicalFont familyName: 'Source Sans Pro' pointSize: 13.
	label := StringMorph contents: 'Entendido' font: fuente emphasis: 1.
	label color: Color white.
	label center: boton center.
	boton addMorph: label.
	^ boton.
]

{ #category : 'initialization' }
AyudaMorph >> dibujarFondo [
	| surface form |
	surface := AthensCairoSurface extent: self extent.
	surface drawDuring: [ :canvas |
		| w h r m path |
		w := self width asFloat.
		h := self height asFloat.
		r := 14.0.
		m := 2.0.
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
		canvas setPaint: (Color r: 0.08 g: 0.11 b: 0.17 alpha: 0.97).
		canvas drawShape: path.
		(canvas setStrokePaint: (Color r: 0.30 g: 0.45 b: 0.62)) width: 2.0.
		canvas drawShape: path ].
	form := surface asForm asFormOfDepth: 32.
	self addMorph: (form asMorph position: self position).
]

{ #category : 'initialization' }
AyudaMorph >> initialize [
	super initialize.
	self extent: 680 @ 490.
	self color: Color transparent.
	self borderWidth: 0.
	self dibujarFondo.
	self construirContenido.
]
