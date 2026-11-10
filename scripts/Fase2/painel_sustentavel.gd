extends PainelDesafio

func _ready() -> void:
	_preparar_tela(self)

func executar(d: Dictionary, chances: int) -> bool:
	# quadro da pergunta (imagem pronta)
	$Imagem.texture = load(d["imagem_pergunta"])

	# cartas (nome + imagem, vindas do banco)
	var botoes = $Opcoes.get_children()
	for i in botoes.size():
		botoes[i].text = d["opcoes"][i]["nome"]
		var caminho: String = d["opcoes"][i].get("imagem", "")
		if caminho != "":
			botoes[i].icon = load(caminho)

	var acertou: bool = await _perguntar(self, botoes, d["certa"], chances,
			"Temos uma opção melhor!\n\nTente novamente")
	if acertou:
		await _mensagem(self, "Parabéns, você acertou!", COR_CERTA, true)
		if d.has("final"):
			await _mensagem(self, d["final"], COR_CERTA, true)
	else:
		await _mensagem(self, "Suas chances acabaram! Tente de novo depois.", COR_ERRADA, true)
	return acertou
