extends CartaSelecionavel
class_name CartaObjeto

const TEXTURAS: Dictionary = {
	1: {
		0: "res://Assets/cartas fase 3/carta_bicicleta_1.png",
		1: "res://Assets/cartas fase 3/carta_garrafa_2.png",
		2: "res://Assets/cartas fase 3/carta_caneca_3.png",
		3: "res://Assets/cartas fase 3/carta_onibus_4.png",
		4: "res://Assets/cartas fase 3/carta_ecobag_5.png"
	},
	2: {
		0: "res://Assets/cartas fase 3/carta_ecobag_1.png",
		1: "res://Assets/cartas fase 3/carta_bicicleta_2.png",
		2: "res://Assets/cartas fase 3/carta_garrafa_3.png",
		3: "res://Assets/cartas fase 3/carta_caneca_4.png",
		4: "res://Assets/cartas fase 3/carta_onibus_5.png"
	}
}

func setTextura(newId: int, esc: int) -> void:
	id = newId
	if not TEXTURAS.has(esc) or not TEXTURAS[esc].has(id):
		return
	_aplicarTextura(TEXTURAS[esc][id])
