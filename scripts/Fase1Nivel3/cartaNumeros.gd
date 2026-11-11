extends CartaSelecionavel
class_name CartaNumero

const TEXTURAS: Dictionary = {
	0: "res://Assets/cartas fase 3/numero_1.png",
	1: "res://Assets/cartas fase 3/numero_2.png",
	2: "res://Assets/cartas fase 3/numero_3.png",
	3: "res://Assets/cartas fase 3/numero_4.png",
	4: "res://Assets/cartas fase 3/numero_5.png"
}

const AUDIOS: Dictionary = {
	0: "Uma unidade.wav",
	1: "Duas unidades.wav",
	2: "Três unidades.wav",
	3: "Quatro unidades.wav",
	4: "Cinco unidades.wav"
}

func setTextura(newId: int) -> void:
	id = newId
	if not TEXTURAS.has(id):
		push_error("CartaNumero: id %d não existe no dicionário" % id)
		return
	_aplicarTextura(TEXTURAS[id])
	audioFala = PASTA_AUDIO + AUDIOS[id]
