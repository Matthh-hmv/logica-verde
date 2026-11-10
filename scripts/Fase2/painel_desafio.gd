class_name PainelDesafio
extends Control

signal opcao_escolhida(indice: int)

const COR_CERTA := Color("4e9a65")
const COR_ERRADA := Color("ff8a75")
const ESTADOS := ["normal", "hover", "pressed", "disabled"]

# Liga os botões de "Opcoes" da tela e deixa o texto da "Mensagem" branco
func _preparar_tela(tela: Control) -> void:
	var botoes = tela.get_node("Opcoes").get_children()
	for i in botoes.size():
		botoes[i].pressed.connect(_ao_clicar_opcao.bind(i))
	var msg: Button = tela.get_node("Mensagem")
	for cor in ["font_color", "font_hover_color", "font_pressed_color"]:
		msg.add_theme_color_override(cor, Color.WHITE)

func _ao_clicar_opcao(i: int) -> void:
	opcao_escolhida.emit(i)

func _perguntar(tela: Control, botoes: Array, certa: int, chances: int, msg_errada: String) -> bool:
	tela.get_node("Mensagem").hide()
	tela.get_node("Opcoes").show()
	for b in botoes:
		_limpar(b)
		b.disabled = false

	while chances > 0:
		var escolhido: int = await opcao_escolhida
		if escolhido == certa:
			for i in botoes.size():
				_pintar(botoes[i], COR_CERTA if i == certa else COR_ERRADA)
				botoes[i].disabled = true
			await get_tree().create_timer(1.2).timeout
			return true
		chances -= 1
		_pintar(botoes[escolhido], COR_ERRADA)
		botoes[escolhido].disabled = true
		await get_tree().create_timer(0.6).timeout
		if chances > 0:
			await _mensagem(tela, msg_errada, COR_ERRADA, false)
			tela.get_node("Mensagem").hide()
			tela.get_node("Opcoes").show()
	return false

func _mensagem(tela: Control, texto: String, cor: Color, esperar_clique: bool) -> void:
	var msg: Button = tela.get_node("Mensagem")
	tela.get_node("Opcoes").hide()
	_pintar(msg, cor)
	msg.text = texto
	msg.show()
	if esperar_clique:
		await msg.pressed
	else:
		await get_tree().create_timer(1.5).timeout

func _pintar(botao: Button, cor: Color) -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = cor
	sb.set_border_width_all(4)
	sb.border_color = cor.darkened(0.5)
	botao.focus_mode = Control.FOCUS_NONE
	for estado in ESTADOS:
		botao.add_theme_stylebox_override(estado, sb)

func _limpar(botao: Button) -> void:
	for estado in ESTADOS:
		botao.remove_theme_stylebox_override(estado)
