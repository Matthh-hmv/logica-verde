extends PainelDesafio

func _ready() -> void:
	_preparar_tela($Conta)
	_limpar($Contexto/Continuar)
	_limpar($Conta/Resposta)
	_cor_texto($Conta/Resposta, Color.BLACK)

func _subtela(nome: String) -> void:
	$Contexto.visible = (nome == "Contexto")
	$Conta.visible = (nome == "Conta")

func executar(d: Dictionary, chances: int) -> bool:
	# 1) contexto
	$Contexto/Texto.text = d["contexto"].to_upper()
	_subtela("Contexto")
	await $Contexto/Continuar.pressed

	# 2) conta
	var tiles = [$Conta/Tile1, $Conta/Tile2, $Conta/Tile3, $Conta/Tile4]
	for i in 4:
		tiles[i].text = d["tiles"][i].to_upper()
	var resposta: Button = $Conta/Resposta
	_limpar(resposta)
	resposta.text = ""
	var botoes = $Conta/Opcoes.get_children()
	for i in botoes.size():
		botoes[i].text = d["opcoes"][i].to_upper()
	_subtela("Conta")

	var acertou: bool = await _perguntar($Conta, botoes, d["certa"], chances,
			"Resposta errada, tente outra opção!")
	if acertou:
		_pintar(resposta, COR_CERTA)
		resposta.text = d["opcoes"][d["certa"]].to_upper()
		await _mensagem($Conta, "Parabéns, você acertou!", COR_CERTA, true)
		await _mensagem($Conta, d["final"], COR_CERTA, true)
	else:
		await _mensagem($Conta, "Suas chances acabaram! Tente de novo depois.", COR_ERRADA, true)
	return acertou
