class_name PainelDesafio
extends Control

signal opcao_escolhida(indice: int)

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
		_limpar(botoes[i])
		_cor_texto(botoes[i], Color.BLACK)
	_cor_texto(tela.get_node("Mensagem"), Color.BLACK)

func _ao_clicar_opcao(i: int) -> void:
	opcao_escolhida.emit(i)

func _perguntar(tela: Control, botoes: Array, certa: int, chances: int, msg_errada: String) -> bool:
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
		errados.append(escolhido)
		_pintar(botoes[escolhido], COR_ERRADA)
		botoes[escolhido].disabled = true
		await get_tree().create_timer(0.6).timeout

		if chances > 0:
			await _mensagem(tela, msg_errada, COR_MSG_ERRADA, true)
			tela.get_node("Mensagem").hide()
			tela.get_node("Opcoes").show()
			for i in errados:   # as erradas continuam vermelhas e travadas
				_pintar(botoes[i], COR_ERRADA)
				botoes[i].disabled = true
	return false

func _mensagem(tela: Control, texto: String, cor: Color, esperar_clique: bool) -> void:
	var msg: Button = tela.get_node("Mensagem")
	tela.get_node("Opcoes").hide()
	_pintar(msg, cor)
	msg.text = texto.to_upper()
	msg.show()
	if esperar_clique:
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
