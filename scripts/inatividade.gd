extends CanvasLayer

# Verificação de inatividade (autoload "Inatividade").
# Se ninguém mexer no mouse, teclado ou tela por TEMPO_LIMITE segundos, o jogo pausa
# (o cronômetro do aluno também para) e pergunta "TEM ALGUÉM JOGANDO?".
# - SIM: fecha o popup e o jogo continua de onde parou.
# - NÃO (ou sem resposta por TEMPO_RESPOSTA segundos): descarta a partida em andamento
#   e volta para a tela inicial, pronta para o próximo aluno.

const TEMPO_LIMITE := 300.0      # 5 minutos sem interação
const TEMPO_RESPOSTA := 60.0     # 0 = espera para sempre pela resposta
const TELA_INICIAL := "res://cenas/telaInicial.tscn"
# telas onde não faz sentido perguntar (ninguém está jogando nelas)
const TELAS_IGNORADAS := [TELA_INICIAL]

const FONTE := "res://assets/fontes/minecraft.ttf"
const SIM := "res://assets/ui/botoes/botaoSim.png"
const SIM_PRESSIONADO := "res://assets/ui/botoes/botaoSimPressionado.png"
const NAO := "res://assets/ui/botoes/botaoNao.png"
const NAO_PRESSIONADO := "res://assets/ui/botoes/botaoNaoPressionado.png"

const COR_FUNDO := Color(0, 0, 0, 0.45)
const COR_PAINEL := Color("e8e2d4")
const COR_BORDA := Color("4a3b2d")
const COR_TEXTO := Color("3b2a1a")

signal respondido(alguemJogando: bool)

var tempoLimite := TEMPO_LIMITE   # dá para mudar em testes
var _parado := 0.0
var _esperandoResposta := 0.0
var _aberto := false
var _raiz: Control
var _botaoSim: TextureButton


func _ready() -> void:
	layer = 100   # acima de todas as telas e popups do jogo
	process_mode = Node.PROCESS_MODE_ALWAYS   # continua funcionando com o jogo pausado
	_montaPopup()
	_raiz.visible = false


func _input(evento: InputEvent) -> void:
	if evento is InputEventMouse or evento is InputEventKey \
			or evento is InputEventScreenTouch or evento is InputEventScreenDrag \
			or evento is InputEventJoypadButton:
		_parado = 0.0


func _process(delta: float) -> void:
	if _aberto:
		if TEMPO_RESPOSTA > 0.0:
			_esperandoResposta += delta
			if _esperandoResposta >= TEMPO_RESPOSTA:
				_aoNao()
		return

	if _telaIgnorada():
		_parado = 0.0
		return

	_parado += delta
	if _parado >= tempoLimite:
		abrir()


func abrir() -> void:
	if _aberto:
		return
	_aberto = true
	_esperandoResposta = 0.0
	get_tree().paused = true
	_raiz.visible = true
	_botaoSim.grab_focus()


func estaAberto() -> bool:
	return _aberto


func _fechar() -> void:
	_aberto = false
	_parado = 0.0
	_raiz.visible = false
	get_tree().paused = false


func _aoSim() -> void:
	_fechar()
	respondido.emit(true)


func _aoNao() -> void:
	_fechar()
	Aluno.resetar()
	Narrador.player.stop()
	Navegacao.historico.clear()
	get_tree().change_scene_to_file(TELA_INICIAL)
	respondido.emit(false)


func _telaIgnorada() -> bool:
	var cena := get_tree().current_scene
	return cena == null or cena.scene_file_path in TELAS_IGNORADAS


# ---------- Interface ----------

func _montaPopup() -> void:
	_raiz = Control.new()
	_raiz.set_anchors_preset(Control.PRESET_FULL_RECT)
	_raiz.mouse_filter = Control.MOUSE_FILTER_STOP   # bloqueia cliques no jogo por trás
	add_child(_raiz)

	var fundo := ColorRect.new()
	fundo.color = COR_FUNDO
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	_raiz.add_child(fundo)

	var centro := CenterContainer.new()
	centro.set_anchors_preset(Control.PRESET_FULL_RECT)
	_raiz.add_child(centro)

	var painel := PanelContainer.new()
	painel.custom_minimum_size = Vector2(680, 460)
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = COR_PAINEL
	estilo.border_color = COR_BORDA
	estilo.set_border_width_all(10)
	estilo.border_width_bottom = 16
	estilo.set_corner_radius_all(28)
	estilo.shadow_color = Color(0, 0, 0, 0.25)
	estilo.shadow_size = 14
	estilo.shadow_offset = Vector2(0, 8)
	painel.add_theme_stylebox_override("panel", estilo)
	centro.add_child(painel)

	var coluna := VBoxContainer.new()
	coluna.alignment = BoxContainer.ALIGNMENT_CENTER
	coluna.add_theme_constant_override("separation", 56)
	painel.add_child(coluna)

	var texto := Label.new()
	texto.text = "TEM ALGUÉM\nJOGANDO?"
	texto.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texto.add_theme_font_override("font", load(FONTE))
	texto.add_theme_font_size_override("font_size", 52)
	texto.add_theme_color_override("font_color", COR_TEXTO)
	texto.add_theme_constant_override("line_spacing", 6)
	coluna.add_child(texto)

	var botoes := HBoxContainer.new()
	botoes.alignment = BoxContainer.ALIGNMENT_CENTER
	botoes.add_theme_constant_override("separation", 48)
	coluna.add_child(botoes)

	_botaoSim = _botao(SIM, SIM_PRESSIONADO, _aoSim)
	botoes.add_child(_botaoSim)
	botoes.add_child(_botao(NAO, NAO_PRESSIONADO, _aoNao))


func _botao(normal: String, pressionado: String, acao: Callable) -> TextureButton:
	var b := TextureButton.new()
	b.texture_normal = load(normal)
	b.texture_pressed = load(pressionado)
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.pressed.connect(acao)
	return b
