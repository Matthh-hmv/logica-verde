extends PainelDesafio

func _ready() -> void:
	_preparar_tela($Conta)

func _subtela(nome: String) -> void:
	$Contexto.visible = (nome == "Contexto")
	$Conta.visible = (nome == "Conta")

func executar(d: Dictionary, chances: int) -> bool:
	# 1) contexto (imagem pronta)
	$Contexto/Imagem.texture = load(d["imagem_contexto"])
	_subtela("Contexto")
	await $Contexto/Continuar.pressed

	# 2) conta (imagem pronta com a caixa vazia)
	$Conta/Imagem.texture = load(d["imagem_conta"])
	var resposta: Button = $Conta/Resposta
	_limpar(resposta)
	resposta.flat = true
	resposta.text = ""
	var botoes = $Conta/Opcoes.get_children()
	for i in botoes.size():
		botoes[i].text = d["opcoes"][i]
	_subtela("Conta")

	var acertou: bool = await _perguntar($Conta, botoes, d["certa"], chances,
			"Resposta errada, tente outra opção!")
	if acertou:
		resposta.flat = false
		_pintar(resposta, COR_CERTA)
		resposta.text = d["opcoes"][d["certa"]]
		await _mensagem($Conta, "Parabéns, você acertou!", COR_CERTA, true)
		await _mensagem($Conta, d["final"], COR_CERTA, true)
	else:
		await _mensagem($Conta, "Suas chances acabaram! Tente de novo depois.", COR_ERRADA, true)
	return acertou
