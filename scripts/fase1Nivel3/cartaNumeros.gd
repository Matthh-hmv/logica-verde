extends CartaSelecionavel
class_name CartaNumero

const TEXTURAS: Dictionary = {
	0: "res://assets/cartasFase1Nivel3/numero1.png",
	1: "res://assets/cartasFase1Nivel3/numero2.png",
	2: "res://assets/cartasFase1Nivel3/numero3.png",
	3: "res://assets/cartasFase1Nivel3/numero4.png",
	4: "res://assets/cartasFase1Nivel3/numero5.png"
}

const AUDIOS: Dictionary = {
	0: "umaUnidade.wav",
	1: "duasUnidades.wav",
	2: "tresUnidades.wav",
	3: "quatroUnidades.wav",
	4: "cincoUnidades.wav"
}

func setTextura(newId: int) -> void:
	id = newId
	if not TEXTURAS.has(id):
		push_error("CartaNumero: id %d não existe no dicionário" % id)
		return
	_aplicarTextura(TEXTURAS[id])
	audioFala = PASTA_AUDIO + AUDIOS[id]
