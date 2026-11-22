extends PainelDesafio

# true = "resposta.wav" já inclui o "Parabéns, você acertou!" no começo
# (toca na mensagem de parabéns). false = só a mensagem final (toca nela).
const RESPOSTA_INCLUI_PARABENS := true

func _ready() -> void:
	_preparar_tela($Conta)
	_limpar($Contexto/Continuar)
	_limpar($Conta/Resposta)
	_cor_texto($Conta/Resposta, Color.BLACK)
	_narrar_ao_passar($Contexto/Continuar, AUDIO_CONTINUAR)

# cada resposta errada de conta soma no relatório
func _registrar_erro() -> void:
	Aluno.erroConta += 1

func _subtela(nome: String) -> void:
	$Contexto.visible = (nome == "Contexto")
	$Conta.visible = (nome == "Conta")

# pasta 1 está com "opcao.wav" em vez de "opcao0.wav": aceita os dois nomes
func _caminho_opcao(pasta: String, i: int) -> String:
	var caminho := pasta + "opcao" + str(i) + ".wav"
	if i == 0 and not ResourceLoader.exists(caminho):
		caminho = pasta + "opcao.wav"
	return caminho

func executar(d: Dictionary, chances: int) -> bool:
	# pasta de áudios deste desafio (vem do banco de desafios)
	var pasta: String = PASTA_FASE2 + str(d.get("pasta", "")) + "/"

	# 1) contexto: narra o enunciado e só libera o Continuar quando terminar
	$Contexto/Texto.text = d["contexto"].to_upper()
	_subtela("Contexto")
	await _esperar_botao($Contexto/Continuar, pasta + "narracao.wav")

	# 2) conta
	var tiles = [$Conta/Tile1, $Conta/Tile2, $Conta/Tile3, $Conta/Tile4]
	for i in 4:
		tiles[i].text = d["tiles"][i].to_upper()
	var resposta: Button = $Conta/Resposta
	_limpar(resposta)
	resposta.text = ""
	var botoes = $Conta/Opcoes.get_children()
	audios_opcoes.clear()
	for i in botoes.size():
		botoes[i].text = d["opcoes"][i].to_upper()
		audios_opcoes.append(_caminho_opcao(pasta, i))   # lido ao passar o mouse
	_subtela("Conta")
	_falar(pasta + "conta.wav")
	_liberar_hover_apos_fala(botoes)   # sem await: o hover não corta a conta

	var acertou: bool = await _perguntar($Conta, botoes, d["certa"], chances,
			"Resposta errada, tente outra opção!", AUDIO_ERROU_CONTA)
	if acertou:
		_pintar(resposta, COR_CERTA)
		resposta.text = d["opcoes"][d["certa"]].to_upper()
		var audio_resposta := pasta + "resposta.wav"
		var audio_parabens := audio_resposta if RESPOSTA_INCLUI_PARABENS else ""
		var audio_final := "" if RESPOSTA_INCLUI_PARABENS else audio_resposta
		await _mensagem($Conta, "Parabéns, você acertou!", COR_CERTA, true, audio_parabens)
		# a mensagem final só libera o clique quando a fala terminar
		await _mensagem($Conta, d["final"], COR_CERTA, true, audio_final, true)
	else:
		await _mensagem($Conta, "Suas chances acabaram! Tente de novo depois.", COR_ERRADA, true, AUDIO_CHANCES_ACABARAM)
	return acertou
