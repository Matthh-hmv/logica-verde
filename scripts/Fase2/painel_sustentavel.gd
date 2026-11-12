extends PainelDesafio

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Fundo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	move_child($Fundo, 0)   # a imagem fica sempre por baixo de tudo	$Opcoes.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for b in $Opcoes.get_children():
		b.mouse_filter = Control.MOUSE_FILTER_STOP
		b.disabled = false
		b.get_node("Conteudo").mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.get_node("Conteudo/Imagem").mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.get_node("Conteudo/Nome").mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.get_node("Conteudo/Nome").add_theme_color_override("font_color", Color.BLACK)
	$Mensagem.mouse_filter = Control.MOUSE_FILTER_STOP
	_preparar_tela(self)

func executar(d: Dictionary, chances: int) -> bool:
	# só as 2 cartas mudam (nome + imagem)
	var botoes = $Opcoes.get_children()
	for i in botoes.size():
		var carta = d["opcoes"][i]
		botoes[i].text = ""
		botoes[i].get_node("Conteudo/Nome").text = carta["nome"].to_upper()
		var caminho: String = carta.get("imagem", "")
		botoes[i].get_node("Conteudo/Imagem").texture = load(caminho) if caminho != "" else null

	var acertou: bool = await _perguntar(self, botoes, d["certa"], chances,
			"Temos uma opção melhor!\n\nTente novamente")
	if acertou:
		await _mensagem(self, "Parabéns, você acertou!", COR_CERTA, true)
		if d.has("final"):
			await _mensagem(self, d["final"], COR_CERTA, true)
	else:
		await _mensagem(self, "Suas chances acabaram! Tente de novo depois.", COR_ERRADA, true)
	return acertou
