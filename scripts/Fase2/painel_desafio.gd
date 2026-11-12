class_name PainelDesafio
extends Control

signal opcao_escolhida(indice: int)

# ---------- NARRAÇÃO (fase 2) ----------
const PASTA_FASE2 := "res://Assets/Áudios/Fases/Fase 2 (Kamilla)/"
const PASTA_GERAL := PASTA_FASE2 + "geral/"
const AUDIO_CONTINUAR := PASTA_GERAL + "continuar.wav"
const AUDIO_PERGUNTA_SUSTENTAVEL := PASTA_GERAL + "Qual o objeto mais sustentável.wav"

# Áudios que ainda não existem: grave e coloque o caminho aqui.
# Deixe "" para a mensagem ficar sem fala.
const AUDIO_ACERTOU := ""             # "Parabéns, você acertou!" (painel sustentável)
const AUDIO_ERROU_CONTA := ""         # "Resposta errada, tente outra opção!"
const AUDIO_ERROU_SUSTENTAVEL := ""   # "Temos uma opção melhor! Tente novamente"
const AUDIO_CHANCES_ACABARAM := ""    # "Suas chances acabaram! Tente de novo depois."

# true = o aluno só avança depois de ouvir o áudio até o fim
const OUVIR_ATE_O_FIM := true

# áudio de cada opção, lido ao passar o mouse (preenchido em cada painel)
var audios_opcoes: Array[String] = []

# true enquanto a fala inicial (conta / pergunta) toca: o hover não a interrompe
var _hover_bloqueado := false

const COR_CERTA := Color("4f9d69")        # verde (opção certa, caixa da resposta, mensagens de acerto)
const COR_ERRADA := Color("f9a090")       # rosa das opções erradas
const COR_MSG_ERRADA := Color("ff826a")   # salmão da caixa "resposta errada"
const ESTADOS := ["normal", "hover", "pressed", "disabled"]
const CORES_FONTE := ["font_color", "font_hover_color", "font_pressed_color",
		"font_disabled_color", "font_focus_color"]

# Liga os botões de "Opcoes", deixa-os transparentes (aparece a arte da imagem)
# e define a cor do texto: preto nas opções, branco na mensagem
func _preparar_tela(tela: Control) -> void:
	var botoes = tela.get_node("Opcoes").get_children()
	for i in botoes.size():
		botoes[i].pressed.connect(_ao_clicar_opcao.bind(i))
		botoes[i].mouse_entered.connect(_ao_passar_mouse.bind(i))
		_limpar(botoes[i])
		_cor_texto(botoes[i], Color.BLACK)
	_cor_texto(tela.get_node("Mensagem"), Color.BLACK)

func _ao_clicar_opcao(i: int) -> void:
	opcao_escolhida.emit(i)

func _perguntar(tela: Control, botoes: Array, certa: int, chances: int, msg_errada: String, audio_errada := "") -> bool:
	var errados: Array[int] = []
	tela.get_node("Mensagem").hide()
	tela.get_node("Opcoes").show()
	for b in botoes:
		_limpar(b)
		b.disabled = false

	while chances > 0:
		var escolhido: int = await opcao_escolhida
		if escolhido in errados:
			continue   # já marcada como errada: ignora o clique, sem gastar chance

		if escolhido == certa:
			for i in botoes.size():
				_pintar(botoes[i], COR_CERTA if i == certa else COR_ERRADA)
				botoes[i].disabled = true
			await get_tree().create_timer(1.2).timeout
			return true

		# errou: marca em vermelho e trava essa opção
		chances -= 1
		_registrar_erro()
		errados.append(escolhido)
		_pintar(botoes[escolhido], COR_ERRADA)
		botoes[escolhido].disabled = true
		await get_tree().create_timer(0.6).timeout

		if chances > 0:
			await _mensagem(tela, msg_errada, COR_MSG_ERRADA, true, audio_errada)
			tela.get_node("Mensagem").hide()
			tela.get_node("Opcoes").show()
			for i in errados:   # as erradas continuam vermelhas e travadas
				_pintar(botoes[i], COR_ERRADA)
				botoes[i].disabled = true
	return false

# audio: fala ao mostrar a mensagem | bloquear: só libera o clique quando a fala terminar
func _mensagem(tela: Control, texto: String, cor: Color, esperar_clique: bool, audio := "", bloquear := false) -> void:
	var msg: Button = tela.get_node("Mensagem")
	tela.get_node("Opcoes").hide()
	_pintar(msg, cor)
	msg.text = texto.to_upper()
	msg.show()
	_falar(audio)
	if esperar_clique:
		if bloquear and OUVIR_ATE_O_FIM:
			msg.disabled = true
			await Narrador.esperarTerminar()
			msg.disabled = false
		await msg.pressed
	else:
		await get_tree().create_timer(1.5).timeout

# Pinta o botão com uma cor sólida (por cima da arte)
func _pintar(botao: Button, cor: Color) -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = cor
	sb.set_border_width_all(4)
	sb.set_corner_radius_all(6)
	sb.border_color = cor.darkened(0.5)
	botao.flat = false          # botão "flat" não desenha a cor de fundo
	botao.focus_mode = Control.FOCUS_NONE
	for estado in ESTADOS:
		botao.add_theme_stylebox_override(estado, sb)

# Deixa o botão invisível: só aparece a arte da imagem por baixo
func _limpar(botao: Button) -> void:
	botao.focus_mode = Control.FOCUS_NONE
	for estado in ESTADOS:
		botao.add_theme_stylebox_override(estado, StyleBoxEmpty.new())

func _cor_texto(botao: Button, cor: Color) -> void:
	for nome in CORES_FONTE:
		botao.add_theme_color_override(nome, cor)

# ---------- Narração ----------

func _falar(caminho: String) -> void:
	if caminho != "":
		Narrador.falar(caminho)

# lê a opção quando o mouse passa por cima
func _ao_passar_mouse(i: int) -> void:
	if _hover_bloqueado:
		return
	if i < audios_opcoes.size():
		_falar(audios_opcoes[i])

# narra o botão ao passar o mouse (não fala se ele estiver bloqueado)
func _narrar_ao_passar(botao: Button, audio: String) -> void:
	botao.mouse_entered.connect(func() -> void:
		if not botao.disabled:
			_falar(audio)
	)

# fala o áudio e espera o clique no botão (bloqueado até o fim da fala, se configurado)
func _esperar_botao(botao: Button, audio: String) -> void:
	_falar(audio)
	if OUVIR_ATE_O_FIM:
		botao.disabled = true
		await Narrador.esperarTerminar()
		botao.disabled = false
	await botao.pressed

# Segura a leitura por hover até a fala inicial terminar. Quando termina, se o mouse
# já estiver sobre uma opção (ex.: o clique anterior foi na mesma posição), lê essa opção.
# Chamar SEM await, logo depois de _falar(...).
func _liberar_hover_apos_fala(botoes: Array) -> void:
	_hover_bloqueado = true
	await Narrador.esperarTerminar()
	_hover_bloqueado = false
	var pos := get_global_mouse_position()
	for i in botoes.size():
		if botoes[i].is_visible_in_tree() and botoes[i].get_global_rect().has_point(pos):
			_ao_passar_mouse(i)
			break

# Chamado a cada resposta errada. Cada painel sobrescreve para somar no Aluno.
func _registrar_erro() -> void:
	pass
