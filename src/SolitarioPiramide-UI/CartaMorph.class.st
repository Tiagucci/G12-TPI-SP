Class {
	#name : 'CartaMorph',
	#superclass : 'Morph',
	#instVars : [
		'carta',
		'bocaArriba',
		'seleccionada',
		'bloqueada',
		'accionClic',
		'accionClicDerecho'
	],
	#category : 'SolitarioPiramide-UI',
	#package : 'SolitarioPiramide-UI'
}

{ #category : 'drawing' }
CartaMorph >> actualizarApariencia [
	| fondoForm colorFondo colorBorde grosor etiquetaSup paloChico paloCentro fuenteRango |
	self removeAllMorphs.
	self borderWidth: 0.

	bocaArriba ifFalse: [
		fondoForm := self
			formFondoColor: (Color r: 0.11 g: 0.22 b: 0.48)
			borde: (Color r: 0.85 g: 0.90 b: 1.0)
			grosor: 2.
		self addMorph: (fondoForm asMorph position: self position).
		^ self ].

	carta ifNil: [
		fondoForm := self
			formFondoColor: (Color white alpha: 0.08)
			borde: (Color white alpha: 0.25)
			grosor: 1.5.
		self addMorph: (fondoForm asMorph position: self position).
		^ self ].

	colorFondo := bloqueada
		ifTrue: [ Color r: 0.86 g: 0.88 b: 0.91 ]
		ifFalse: [ Color r: 0.98 g: 0.98 b: 0.99 ].
	colorBorde := seleccionada
		ifTrue: [ Color r: 0.95 g: 0.72 b: 0.10 ]
		ifFalse: [ Color r: 0.72 g: 0.75 b: 0.80 ].
	grosor := seleccionada ifTrue: [ 3 ] ifFalse: [ 1.5 ].

	fondoForm := self formFondoColor: colorFondo borde: colorBorde grosor: grosor.
	self addMorph: (fondoForm asMorph position: self position).

	fuenteRango := LogicalFont familyName: 'Source Sans Pro' pointSize: 14.
etiquetaSup := StringMorph contents: carta rango asString font: fuenteRango emphasis: 1.
	etiquetaSup color: self colorTexto.
	etiquetaSup position: self position + (8 @ 6).

	paloChico := (self formPaloTamano: 13) asMorph.
	paloChico position: self position + (8 @ 24).

	paloCentro := (self formPaloTamano: 32) asMorph.
	paloCentro center: self center + (2 @ 8).

	self
		addMorph: etiquetaSup;
		addMorph: paloChico;
		addMorph: paloCentro.
]

{ #category : 'accessing' }
CartaMorph >> alHacerClic: unBloque [
	accionClic := unBloque.
]

{ #category : 'accessing' }
CartaMorph >> alHacerClicDerecho: unBloque [
	accionClicDerecho := unBloque.
]

{ #category : 'accessing' }
CartaMorph >> bloqueada: unBooleano [
	bloqueada := unBooleano.
	self actualizarApariencia.
]

{ #category : 'accessing' }
CartaMorph >> bocaArriba: unBooleano [
	bocaArriba := unBooleano.
	self actualizarApariencia.
]

{ #category : 'accessing' }
CartaMorph >> carta [
	^ carta.
]

{ #category : 'accessing' }
CartaMorph >> carta: unaCarta [
	carta := unaCarta.
	self actualizarApariencia.
]

{ #category : 'drawing' }
CartaMorph >> colorTexto [
	(carta notNil and: [ carta esPaloRojo ])
		ifTrue: [ ^ Color red darker ].
	^ Color black.
]

{ #category : 'drawing' }
CartaMorph >> crearFiguraPaloTamano: tamano [
	| colorPalo mitad cuarto |
	colorPalo := self colorTexto.
	mitad := tamano // 2.
	cuarto := tamano // 4.

	carta palo = #diamantes ifTrue: [
		^ (PolygonMorph
			vertices: { mitad @ 0. tamano @ mitad. mitad @ tamano. 0 @ mitad }
			color: colorPalo
			borderWidth: 0
			borderColor: colorPalo) ].

	carta palo = #corazones ifTrue: [
		^ (PolygonMorph
			vertices: {
				mitad @ cuarto.
				(tamano - cuarto) @ 0.
				tamano @ cuarto.
				mitad @ tamano.
				0 @ cuarto.
				cuarto @ 0 }
			color: colorPalo
			borderWidth: 0
			borderColor: colorPalo) ].

	carta palo = #picas ifTrue: [
		^ (PolygonMorph
			vertices: {
				mitad @ 0.
				tamano @ (tamano - cuarto).
				(mitad + (cuarto // 2)) @ (tamano - cuarto).
				(mitad + cuarto) @ tamano.
				(mitad - cuarto) @ tamano.
				(mitad - (cuarto // 2)) @ (tamano - cuarto).
				0 @ (tamano - cuarto) }
			color: colorPalo
			borderWidth: 0
			borderColor: colorPalo) ].

	"Por defecto: #treboles"
	^ (PolygonMorph
		vertices: {
			mitad @ 0.
			(tamano - cuarto) @ cuarto.
			(mitad + (cuarto // 2)) @ mitad.
			tamano @ mitad.
			tamano @ (tamano - cuarto).
			(mitad + (cuarto // 2)) @ (tamano - cuarto).
			(mitad + cuarto) @ tamano.
			(mitad - cuarto) @ tamano.
			(mitad - (cuarto // 2)) @ (tamano - cuarto).
			0 @ (tamano - cuarto).
			0 @ mitad.
			(mitad - (cuarto // 2)) @ mitad.
			cuarto @ cuarto }
		color: colorPalo
		borderWidth: 0
		borderColor: colorPalo).
]

{ #category : 'drawing' }
CartaMorph >> formFondoColor: colorFondo borde: colorBorde grosor: unGrosor [
	| surface |
	surface := AthensCairoSurface extent: self extent.
	surface drawDuring: [ :canvas |
		| w h r m path |
		w := self width asFloat.
		h := self height asFloat.
		r := 9.0.
		m := unGrosor asFloat.
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
		canvas setPaint: colorFondo.
		canvas drawShape: path.
		(canvas setStrokePaint: colorBorde) width: unGrosor asFloat.
		canvas drawShape: path ].
	^ surface asForm.
]

{ #category : 'drawing' }
CartaMorph >> formPaloTamano: tamano [
	| surface |
	surface := AthensCairoSurface extent: tamano @ tamano.
	surface drawDuring: [ :canvas |
		| path w h |
		w := tamano asFloat.
		h := tamano asFloat.
		path := canvas createPath: [ :builder |
			builder absolute.
			carta palo = #diamantes ifTrue: [
				builder
					moveTo: (w * 0.5) @ (h * 0.05);
					lineTo: (w * 0.90) @ (h * 0.5);
					lineTo: (w * 0.5) @ (h * 0.95);
					lineTo: (w * 0.10) @ (h * 0.5);
					close ].

			carta palo = #corazones ifTrue: [
				builder
					moveTo: (w * 0.5) @ (h * 0.92);
					curveVia: (w * 0.02) @ (h * 0.58) and: (w * 0.02) @ (h * 0.12) to: (w * 0.30) @ (h * 0.12);
					curveVia: (w * 0.44) @ (h * 0.12) and: (w * 0.50) @ (h * 0.25) to: (w * 0.50) @ (h * 0.30);
					curveVia: (w * 0.50) @ (h * 0.25) and: (w * 0.56) @ (h * 0.12) to: (w * 0.70) @ (h * 0.12);
					curveVia: (w * 0.98) @ (h * 0.12) and: (w * 0.98) @ (h * 0.58) to: (w * 0.50) @ (h * 0.92);
					close ].

			carta palo = #picas ifTrue: [
				builder
					moveTo: (w * 0.50) @ (h * 0.06);
					curveVia: (w * 0.98) @ (h * 0.42) and: (w * 0.96) @ (h * 0.78) to: (w * 0.66) @ (h * 0.76);
					curveVia: (w * 0.56) @ (h * 0.75) and: (w * 0.53) @ (h * 0.68) to: (w * 0.53) @ (h * 0.68);
					lineTo: (w * 0.64) @ (h * 0.94);
					lineTo: (w * 0.36) @ (h * 0.94);
					lineTo: (w * 0.47) @ (h * 0.68);
					curveVia: (w * 0.47) @ (h * 0.68) and: (w * 0.44) @ (h * 0.75) to: (w * 0.34) @ (h * 0.76);
					curveVia: (w * 0.04) @ (h * 0.78) and: (w * 0.02) @ (h * 0.42) to: (w * 0.50) @ (h * 0.06);
					close ].

			carta palo = #treboles ifTrue: [
				builder
					moveTo: (w * 0.44) @ (h * 0.94);
					lineTo: (w * 0.56) @ (h * 0.94);
					lineTo: (w * 0.53) @ (h * 0.64);
					curveVia: (w * 0.72) @ (h * 0.82) and: (w * 0.96) @ (h * 0.68) to: (w * 0.92) @ (h * 0.50);
					curveVia: (w * 0.88) @ (h * 0.36) and: (w * 0.70) @ (h * 0.36) to: (w * 0.62) @ (h * 0.44);
					curveVia: (w * 0.76) @ (h * 0.28) and: (w * 0.68) @ (h * 0.06) to: (w * 0.50) @ (h * 0.06);
					curveVia: (w * 0.32) @ (h * 0.06) and: (w * 0.24) @ (h * 0.28) to: (w * 0.38) @ (h * 0.44);
					curveVia: (w * 0.30) @ (h * 0.36) and: (w * 0.12) @ (h * 0.36) to: (w * 0.08) @ (h * 0.50);
					curveVia: (w * 0.04) @ (h * 0.68) and: (w * 0.28) @ (h * 0.82) to: (w * 0.47) @ (h * 0.64);
					close ] ].
		canvas setPaint: self colorTexto.
		canvas drawShape: path ].
	^ surface asForm.
]

{ #category : 'event handling' }
CartaMorph >> handlesMouseDown: anEvent [
	^ true.
]

{ #category : 'initialization' }
CartaMorph >> initialize [
	super initialize.
	self extent: 80 @ 114.
	self color: Color transparent.
	bocaArriba := true.
	seleccionada := false.
	bloqueada := false.
	self actualizarApariencia.
]

{ #category : 'event handling' }
CartaMorph >> mouseDown: anEvent [
	anEvent redButtonPressed ifTrue: [
		accionClic ifNotNil: [ accionClic value ] ].
	anEvent yellowButtonPressed ifTrue: [
		accionClicDerecho ifNotNil: [ accionClicDerecho value ] ].
]

{ #category : 'accessing' }
CartaMorph >> seleccionada: unBooleano [
	seleccionada := unBooleano.
	self actualizarApariencia.
]

{ #category : 'drawing' }
CartaMorph >> simboloPalo [
	carta ifNil: [ ^ '' ].
	carta palo = #corazones ifTrue: [ ^ '♥' ].
	carta palo = #diamantes ifTrue: [ ^ '♦' ].
	carta palo = #picas ifTrue: [ ^ '♠' ].
	carta palo = #treboles ifTrue: [ ^ '♣' ].
	^ ''.
]
