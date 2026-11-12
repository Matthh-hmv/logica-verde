extends Node2D

# ============ AJUSTE AQUI ============
const VIDEO := "res://Assets/Vídeos/Tutorial Fase 1.ogv"
const PROXIMA_CENA := "res://cenas/fase 1.1 e 1.2/fase_1_1.tscn"  # cena que abre ao clicar em Continuar

# Opcionais (deixe "" para usar o padrão)
const FUNDO := "res://Assets/Fundos e telas/Fundo fases.png"
const FONTE := "res://Assets/Fontes/Minecraft.ttf"

# true = o botão Continuar só libera quando o vídeo terminar
const EXIGIR_VIDEO_ATE_O_FIM := false

# Áudios dos botões (deixe "" para não narrar)
const AUDIO_CONTINUAR := "res://Assets/Áudios/Continuar.wav"
const AUDIO_REVER := "res://Assets/Áudios/Rever o video.wav"
const AUDIO_PAUSAR := ""    # "Pausar vídeo"
const AUDIO_RETOMAR := ""   # "Continuar vídeo"
# =====================================

const TELA := Vector2(1920, 1080)

# Posições e tamanhos (do mockup)
const PAINEL_POS := Vector2(450, 225)
const PAINEL_TAM := Vector2(1020, 573)
const TITULO_POS := Vector2(450, 240)
const TITULO_TAM := Vector2(1020, 110)
const VIDEO_POS := Vector2(612, 358)
const VIDEO_TAM := Vector2(695, 391)
const BARRA_POS := Vector2(612, 842)
const BARRA_TAM := Vector2(695, 211)
const REVER_POS := Vector2(674, 911)
const CONTINUAR_POS := Vector2(987, 911)
const BOTAO_TAM := Vector2(260, 73)
const PAUSA_TAM := Vector2(64, 64)

const BORDA_VIDEO := 8   # espessura da borda do vídeo

# Cores
const COR_PAINEL := Color("e8d5bc")
const COR_BORDA := Color("4a3a2e")
const COR_BARRA := Color("f0d5b5")
const COR_BARRA_BORDA := Color("3a1c1a")
const COR_BOTAO := Color("4a3a2e")
const COR_BOTAO_HOVER := Color("6b5545")
const COR_BOTAO_PRESSED := Color("33271e")
const COR_TEXTO_BOTAO := Color("f3efe6")
const COR_FOCO := Color("ffcc33")

var video: VideoStreamPlayer
var botaoRever: Button
var botaoContinuar: Button
var botaoPausa: Button
var _fonte: Font = null


func _ready() -> void:
	# nós colocados no editor (ex.: botão Voltar), para ficarem por cima no final
	var existentes := get_children()

	if FONTE != "" and ResourceLoader.exists(FONTE):
		_fonte = load(FONTE)

	_criaFundo()
	_criaPainel()
	_criaVideo()
	_criaBarraBotoes()
	_iniciaVideo()

	for no in existentes:
		move_child(no, -1)


# ---------- Construção da tela ----------

func _criaFundo() -> void:
	if FUNDO != "" and ResourceLoader.exists(FUNDO):
		var imagem := TextureRect.new()
		imagem.texture = load(FUNDO)
		imagem.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		imagem.stretch_mode = TextureRect.STRETCH_SCALE
		imagem.size = TELA
		imagem.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(imagem)
	else:
		var cor := ColorRect.new()
		cor.color = Color("e6dcc8")
		cor.size = TELA
		cor.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(cor)


func _criaPainel() -> void:
	_criaCaixa(PAINEL_POS, PAINEL_TAM, COR_PAINEL, COR_BORDA, 4, 24)

	var titulo := Label.new()
	titulo.text = "Tutorial"
	titulo.position = TITULO_POS
	titulo.size = TITULO_TAM
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_estiloTexto(titulo, 90, COR_BORDA)
	add_child(titulo)


func _criaVideo() -> void:
	# fundo escuro atrás do vídeo
	_criaCaixa(VIDEO_POS, VIDEO_TAM, Color("1f1f1f"), Color("1f1f1f"), 0, 6)

	# o vídeo fica um pouco menor que a caixa, para a borda aparecer inteira
	var margem := Vector2(BORDA_VIDEO, BORDA_VIDEO)
	video = VideoStreamPlayer.new()
	video.expand = true
	video.position = VIDEO_POS + margem
	video.size = VIDEO_TAM - margem * 2.0
	video.finished.connect(_onVideoTerminou)
	video.gui_input.connect(_onVideoClicado)
	add_child(video)

	if ResourceLoader.exists(VIDEO):
		video.stream = load(VIDEO)
	else:
		var aviso := Label.new()
		aviso.text = "Vídeo não encontrado:\n" + VIDEO
		aviso.position = VIDEO_POS
		aviso.size = VIDEO_TAM
		aviso.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		aviso.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		aviso.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_estiloTexto(aviso, 28, Color.WHITE)
		add_child(aviso)
		push_warning("Tutorial: vídeo não encontrado em " + VIDEO)

	# moldura por cima do vídeo (centro transparente)
	_criaCaixa(VIDEO_POS, VIDEO_TAM, Color(0, 0, 0, 0), COR_BORDA, BORDA_VIDEO, 6)

	_criaBotaoPausa()


func _criaBotaoPausa() -> void:
	botaoPausa = Button.new()
	botaoPausa.flat = true
	botaoPausa.size = PAUSA_TAM
	botaoPausa.position = Vector2(
		VIDEO_POS.x + VIDEO_TAM.x / 2.0 - PAUSA_TAM.x / 2.0,
		VIDEO_POS.y + VIDEO_TAM.y - PAUSA_TAM.y - 20.0
	)
	botaoPausa.add_theme_stylebox_override("focus", _estiloFoco(32))
	botaoPausa.draw.connect(_desenhaBotaoPausa)
	botaoPausa.pressed.connect(_alternaPausa)
	botaoPausa.mouse_entered.connect(_falarPausa)
	botaoPausa.focus_entered.connect(_falarPausa)
	add_child(botaoPausa)


# desenha o círculo com o ícone de pausa ou de play
func _desenhaBotaoPausa() -> void:
	var centro := PAUSA_TAM / 2.0
	botaoPausa.draw_circle(centro, 30.0, Color(0.12, 0.1, 0.08, 0.8))
	botaoPausa.draw_arc(centro, 30.0, 0.0, TAU, 48, COR_TEXTO_BOTAO, 3.0)
	if _estaParado():
		var triangulo := PackedVector2Array([Vector2(26, 18), Vector2(26, 46), Vector2(48, 32)])
		botaoPausa.draw_colored_polygon(triangulo, COR_TEXTO_BOTAO)
	else:
		botaoPausa.draw_rect(Rect2(22, 18, 8, 28), COR_TEXTO_BOTAO)
		botaoPausa.draw_rect(Rect2(36, 18, 8, 28), COR_TEXTO_BOTAO)


func _criaBarraBotoes() -> void:
	_criaCaixa(BARRA_POS, BARRA_TAM, COR_BARRA, COR_BARRA_BORDA, 8, 8)

	botaoRever = _criaBotao("REVER O VÍDEO", REVER_POS)
	botaoRever.pressed.connect(_onReverPressed)
	_narrarAoFocar(botaoRever, AUDIO_REVER)

	botaoContinuar = _criaBotao("CONTINUAR", CONTINUAR_POS)
	botaoContinuar.pressed.connect(_onContinuarPressed)
	_narrarAoFocar(botaoContinuar, AUDIO_CONTINUAR)

	# libera o Continuar só no fim do vídeo, se configurado
	botaoContinuar.disabled = EXIGIR_VIDEO_ATE_O_FIM and video.stream != null


# ---------- Vídeo ----------

func _iniciaVideo() -> void:
	if video.stream != null:
		video.play()
	botaoPausa.queue_redraw()


func _estaParado() -> bool:
	return video.stream == null or not video.is_playing() or video.paused


# pausa/retoma (ou recomeça, se o vídeo já terminou)
func _alternaPausa() -> void:
	if video.stream == null:
		return
	if video.is_playing():
		video.paused = not video.paused
	else:
		video.play()
	botaoPausa.queue_redraw()


func _onVideoClicado(evento: InputEvent) -> void:
	if evento is InputEventMouseButton and evento.pressed and evento.button_index == MOUSE_BUTTON_LEFT:
		_alternaPausa()


func _onVideoTerminou() -> void:
	botaoContinuar.disabled = false
	botaoPausa.queue_redraw()


func _onReverPressed() -> void:
	if video.stream == null:
		return
	video.stop()
	video.paused = false
	video.play()
	botaoPausa.queue_redraw()


func _onContinuarPressed() -> void:
	video.stop()
	Navegacao.irPara(PROXIMA_CENA)


func _falarPausa() -> void:
	var audio := AUDIO_RETOMAR if _estaParado() else AUDIO_PAUSAR
	if audio != "":
		Narrador.falar(audio)


# ---------- Ajudantes ----------

func _estilo(fundo: Color, borda: Color, espessura: int, raio: int) -> StyleBoxFlat:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = fundo
	estilo.border_color = borda
	estilo.set_border_width_all(espessura)
	estilo.set_corner_radius_all(raio)
	return estilo


# contorno amarelo que aparece quando o botão recebe foco pelo teclado
func _estiloFoco(raio: int) -> StyleBoxFlat:
	var estilo := StyleBoxFlat.new()
	estilo.draw_center = false
	estilo.border_color = COR_FOCO
	estilo.set_border_width_all(5)
	estilo.set_corner_radius_all(raio)
	return estilo


func _criaCaixa(pos: Vector2, tam: Vector2, fundo: Color, borda: Color, espessura: int, raio: int) -> Panel:
	var painel := Panel.new()
	painel.add_theme_stylebox_override("panel", _estilo(fundo, borda, espessura, raio))
	painel.position = pos
	painel.size = tam
	painel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(painel)
	return painel


func _criaBotao(texto: String, pos: Vector2) -> Button:
	var botao := Button.new()
	botao.text = texto
	botao.position = pos
	botao.size = BOTAO_TAM
	botao.add_theme_stylebox_override("normal", _estilo(COR_BOTAO, Color("1c1410"), 3, 16))
	botao.add_theme_stylebox_override("hover", _estilo(COR_BOTAO_HOVER, Color("1c1410"), 3, 16))
	botao.add_theme_stylebox_override("pressed", _estilo(COR_BOTAO_PRESSED, Color("1c1410"), 3, 16))
	botao.add_theme_stylebox_override("disabled", _estilo(Color("8a7d72"), Color("1c1410"), 3, 16))
	botao.add_theme_stylebox_override("focus", _estiloFoco(16))
	_estiloTexto(botao, 30, COR_TEXTO_BOTAO)
	add_child(botao)
	return botao


func _estiloTexto(controle: Control, tamanho: int, cor: Color) -> void:
	if _fonte != null:
		controle.add_theme_font_override("font", _fonte)
	controle.add_theme_font_size_override("font_size", tamanho)
	controle.add_theme_color_override("font_color", cor)
	if controle is Button:
		controle.add_theme_color_override("font_hover_color", cor)
		controle.add_theme_color_override("font_pressed_color", cor)
		controle.add_theme_color_override("font_focus_color", cor)
		controle.add_theme_color_override("font_disabled_color", Color("d9d0c6"))


# narra ao passar o mouse e ao receber foco pelo teclado
func _narrarAoFocar(botao: Button, audio: String) -> void:
	if audio == "":
		return
	botao.mouse_entered.connect(Narrador.falar.bind(audio))
	botao.focus_entered.connect(Narrador.falar.bind(audio))
