extends CartaSelecionavel
class_name CartaObjeto

const TEXTURAS: Dictionary = {
	1: {
		0: "res://assets/cartasFase1Nivel3/cartaBicicleta1.png",
		1: "res://assets/cartasFase1Nivel3/cartaGarrafa2.png",
		2: "res://assets/cartasFase1Nivel3/cartaCaneca3.png",
		3: "res://assets/cartasFase1Nivel3/cartaOnibus4.png",
		4: "res://assets/cartasFase1Nivel3/cartaEcobag5.png"
	},
	2: {
		0: "res://assets/cartasFase1Nivel3/cartaEcobag1.png",
		1: "res://assets/cartasFase1Nivel3/cartaBicicleta2.png",
		2: "res://assets/cartasFase1Nivel3/cartaGarrafa3.png",
		3: "res://assets/cartasFase1Nivel3/cartaCaneca4.png",
		4: "res://assets/cartasFase1Nivel3/cartaOnibus5.png"
	}
}

const AUDIOS: Dictionary = {
	1: {
		0: "umaBicicleta.wav",
		1: "duasGarrafas.wav",
		2: "tresCanecas.wav",
		3: "quatroOnibus.wav",
		4: "cincoEcobags.wav"
	},
	2: {
		0: "umaEcobag.wav",
		1: "duasBicicletas.wav",
		2: "tresGarrafas.wav",
		3: "quatroCanecas.wav",
		4: "cincoOnibus.wav"
	}
}

func setTextura(newId: int, esc: int) -> void:
	id = newId
	if not TEXTURAS.has(esc) or not TEXTURAS[esc].has(id):
		return
	_aplicarTextura(TEXTURAS[esc][id])
	audioFala = PASTA_AUDIO + AUDIOS[esc][id]
