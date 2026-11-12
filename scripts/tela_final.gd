extends Node2D

# ============ AJUSTE AQUI ============
const TITULO := "LÓGICA\nVERDE"
const SUBTITULO := "JOGO CONCLUÍDO!"

# Cena do menu principal. Deixe "" para procurar automaticamente nos caminhos abaixo
const MENU_PRINCIPAL := ""
const MENU_CANDIDATOS := [
	"res://cenas/tela_inicial.tscn",
	"res://cenas/telaInicial.tscn",
]

# Opcionais (deixe "" para usar o padrão)
const FUNDO := "res://Assets/Fundos e telas/Fundo fases.png"
const FONTE := "res://Assets/Fontes/Minecraft.ttf"
const LOGO := ""            # imagem do logo (no lugar do título em texto)
const ESTRELA_CHEIA := ""   # imagem da estrela cheia (senão desenha em código)
const ESTRELA_VAZIA := ""   # imagem da estrela vazia

# Pontuação mínima para cada quantidade de estrelas (abaixo da segunda: 1 estrela)
const PONTOS_3_ESTRELAS := 80
const PONTOS_2_ESTRELAS := 50

# true = o botão Menu principal zera os dados do aluno antes de voltar
const ZERAR_AO_VOLTAR_AO_MENU := true

# Áudios (deixe "" para não narrar)
const AUDIO_JOGO_CONCLUIDO := ""
const AUDIO_MENU_PRINCIPAL := ""
# =====================================

const TELA := Vector2(1920, 1080)

# Posições e tamanhos (do mockup)
const TITULO_POS := Vector2(210, 55)
const TITULO_TAM := Vector2(1500, 220)
const SUBTITULO_POS := Vector2(210, 292)
const SUBTITULO_TAM := Vector2(1500, 70)
const LOGO_POS := Vector2(560, 40)
const LOGO_TAM := Vector2(800, 240)

const CARTAO_TAM := Vector2(475, 235)
const CARTAO1_POS := Vector2(467, 412)
const CARTAO2_POS := Vector2(977, 412)
const MENU_POS := Vector2(467, 680)
const MENU_TAM := Vector2(985, 85)

const ESTRELAS_TOTAL := 3
const ESTRELA_TAM := Vector2(52, 52)
const ESTRELA_ESPACO := 20.0

# Cores
const COR_VERDE := Color("2f7a4f")
const COR_VERDE_ESCURO := Color("245c3b")
const COR_BORDA := Color("3b8068")
const COR_CARTAO := Color("f4efe8")
const COR_CARTAO_HOVER := Color("e4efe6")
const COR_CARTAO_PRESSED := Color("d3e5d8")
const COR_FOCO := Color("ffcc33")
const COR_ESTRELA := Color("f7c531")
const COR_ESTRELA_BORDA := Color("8a5a12")
const COR_VAZIA := Color("ddd6cc")
const COR_VAZIA_BORDA := Color("b3a99b")

var _fonte: Font = null
var _atrasoEstrela := 0.5   # as estrelas conquistadas aparecem uma de cada vez


func _ready() -> void:
	Aluno.pausar_tempo()
	if FONTE != "" and ResourceLoader.exists(FONTE):
		_fonte = load(FONTE)

	var pontos1 :int = Aluno.pontosFase1()
	var pontos2 :int = Aluno.pontosFase2()

	_criaFundo()
	_criaTitulo()
	_criaCartao("FASE 1", pontos1, CARTAO1_POS)
	_criaCartao("FASE 2", pontos2, CARTAO2_POS)
	_criaBotaoMenu()

	_registraRelatorio()
	_falar(AUDIO_JOGO_CONCLUIDO)


# ---------- Construção da tela ----------

func _criaFundo() -> void:
	var imagem := TextureRect.new()
	imagem.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	imagem.stretch_mode = TextureRect.STRETCH_SCALE
	imagem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if FUNDO != "" and ResourceLoader.exists(FUNDO):
		imagem.texture = load(FUNDO)
	else:
		# sem imagem: degradê verde claro -> bege
		var degrade := Gradient.new()
		degrade.set_color(0, Color("e3f0e1"))
		degrade.set_color(1, Color("f2e3d1"))
		var textura := GradientTexture2D.new()
		textura.gradient = degrade
		textura.fill_from = Vector2(0, 0)
		textura.fill_to = Vector2(0, 1)
		textura.width = 8
		textura.height = 256
		imagem.texture = textura
	imagem.size = TELA
	add_child(imagem)


func _criaTitulo() -> void:
	if LOGO != "" and ResourceLoader.exists(LOGO):
		var logo := TextureRect.new()
		logo.texture = load(LOGO)
		logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		logo.position = LOGO_POS
		logo.size = LOGO_TAM
		logo.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(logo)
	else:
		var titulo := _criaTexto(TITULO, TITULO_POS, TITULO_TAM, 92, COR_VERDE)
		titulo.add_theme_constant_override("line_spacing", -10)
		add_child(titulo)
	add_child(_criaTexto(SUBTITULO, SUBTITULO_POS, SUBTITULO_TAM, 46, COR_VERDE))


func _criaCartao(titulo: String, pontos: int, pos: Vector2) -> void:
	var cartao := Panel.new()
	cartao.add_theme_stylebox_override("panel", _estilo(COR_CARTAO, COR_BORDA, 5, 12))
	cartao.position = pos
	cartao.size = CARTAO_TAM
	cartao.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(cartao)

	cartao.add_child(_criaTexto(titulo, Vector2(0, 22), Vector2(CARTAO_TAM.x, 56), 42, COR_VERDE))
	cartao.add_child(_criaTexto("Pontuação: %d pts" % pontos, Vector2(0, 92), Vector2(CARTAO_TAM.x, 40), 28, COR_VERDE_ESCURO))

	var quantas := _estrelas(pontos)
	var total := ESTRELAS_TOTAL * ESTRELA_TAM.x + (ESTRELAS_TOTAL - 1) * ESTRELA_ESPACO
	var x0 := (CARTAO_TAM.x - total) / 2.0
	for i in ESTRELAS_TOTAL:
		var cheia := i < quantas
		var estrela := _criaEstrela(cheia, Vector2(x0 + i * (ESTRELA_TAM.x + ESTRELA_ESPACO), 150))
		cartao.add_child(estrela)
		if cheia:
			_animaEstrela(estrela)


func _criaBotaoMenu() -> void:
	var botao := Button.new()
	botao.text = "MENU PRINCIPAL"
	botao.position = MENU_POS
	botao.size = MENU_TAM
	botao.add_theme_stylebox_override("normal", _estilo(COR_CARTAO, COR_BORDA, 5, 12))
	botao.add_theme_stylebox_override("hover", _estilo(COR_CARTAO_HOVER, COR_BORDA, 5, 12))
	botao.add_theme_stylebox_override("pressed", _estilo(COR_CARTAO_PRESSED, COR_BORDA, 5, 12))
	botao.add_theme_stylebox_override("focus", _estiloFoco(12))
	_estiloTexto(botao, 32, COR_VERDE_ESCURO)
	botao.draw.connect(_desenhaCasa.bind(botao))
	botao.pressed.connect(_aoMenuPrincipal)
	botao.mouse_entered.connect(_falar.bind(AUDIO_MENU_PRINCIPAL))
	botao.focus_entered.connect(_falar.bind(AUDIO_MENU_PRINCIPAL))
	add_child(botao)


# ---------- Estrelas ----------

func _estrelas(pontos: int) -> int:
	if pontos >= PONTOS_3_ESTRELAS:
		return 3
	elif pontos >= PONTOS_2_ESTRELAS:
		return 2
	return 1


func _criaEstrela(cheia: bool, pos: Vector2) -> Control:
	var caminho := ESTRELA_CHEIA if cheia else ESTRELA_VAZIA
	var estrela: Control
	if caminho != "" and ResourceLoader.exists(caminho):
		var imagem := TextureRect.new()
		imagem.texture = load(caminho)
		imagem.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		imagem.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		estrela = imagem
	else:
		estrela = Control.new()
		estrela.draw.connect(_desenhaEstrela.bind(estrela, cheia))
	estrela.size = ESTRELA_TAM
	estrela.position = pos
	estrela.pivot_offset = ESTRELA_TAM / 2.0
	estrela.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return estrela


# estrela de 5 pontas desenhada em código
func _desenhaEstrela(estrela: Control, cheia: bool) -> void:
	var centro := estrela.size / 2.0
	var raio := minf(estrela.size.x, estrela.size.y) / 2.0 - 3.0
	var pontos := PackedVector2Array()
	for i in 10:
		var r := raio if i % 2 == 0 else raio * 0.45
		var angulo := -PI / 2.0 + i * PI / 5.0
		pontos.append(centro + Vector2(cos(angulo), sin(angulo)) * r)
	estrela.draw_colored_polygon(pontos, COR_ESTRELA if cheia else COR_VAZIA)
	pontos.append(pontos[0])
	estrela.draw_polyline(pontos, COR_ESTRELA_BORDA if cheia else COR_VAZIA_BORDA, 3.0, true)


# a estrela "pula" para dentro da tela, uma depois da outra
func _animaEstrela(estrela: Control) -> void:
	var atraso := _atrasoEstrela
	_atrasoEstrela += 0.3
	estrela.scale = Vector2.ZERO
	var tween := create_tween()
	tween.tween_interval(atraso)
	tween.tween_property(estrela, "scale", Vector2.ONE * 1.25, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(estrela, "scale", Vector2.ONE, 0.12)


# ícone de casa ao lado do texto do botão
func _desenhaCasa(botao: Button) -> void:
	var fonte: Font = _fonte if _fonte != null else ThemeDB.fallback_font
	var largura := fonte.get_string_size(botao.text, HORIZONTAL_ALIGNMENT_LEFT, -1, 32).x
	var cx := botao.size.x / 2.0 - largura / 2.0 - 38.0
	var cy := botao.size.y / 2.0
	var cor := COR_VERDE_ESCURO
	botao.draw_polyline(PackedVector2Array([
		Vector2(cx - 16, cy), Vector2(cx, cy - 16), Vector2(cx + 16, cy)]), cor, 4.0)
	botao.draw_polyline(PackedVector2Array([
		Vector2(cx - 11, cy - 4), Vector2(cx - 11, cy + 14),
		Vector2(cx + 11, cy + 14), Vector2(cx + 11, cy - 4)]), cor, 4.0)
	botao.draw_rect(Rect2(cx - 3, cy + 5, 6, 9), cor)


# ---------- Relatório e saída ----------

# grava as linhas do aluno no .csv (uma vez só por aluno)
func _registraRelatorio() -> void:
	if Aluno.relatorioRegistrado:
		return
	var caminho := RelatorioCSV.registrar(Aluno.nome, Aluno.tempoFase1, Aluno.errosFase1,
			Aluno.tempoFase2, Aluno.erroConta, Aluno.erroObjeto)
	if caminho != "":
		Aluno.relatorioRegistrado = true


func _cenaMenu() -> String:
	if MENU_PRINCIPAL != "":
		return MENU_PRINCIPAL
	for caminho in MENU_CANDIDATOS:
		if ResourceLoader.exists(caminho):
			return caminho
	return ""


func _aoMenuPrincipal() -> void:
	var menu := _cenaMenu()
	if menu == "":
		push_error("Tela final: cena do menu principal não encontrada. Defina MENU_PRINCIPAL no topo do script.")
		return
	# (depois) aqui entra o envio do relatório por email
	if ZERAR_AO_VOLTAR_AO_MENU:
		Aluno.resetar()
	Navegacao.historico.clear()
	get_tree().change_scene_to_file(menu)


# ---------- Ajudantes ----------

func _falar(caminho: String) -> void:
	if caminho != "":
		Narrador.falar(caminho)


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


func _criaTexto(texto: String, pos: Vector2, tam: Vector2, tamanhoFonte: int, cor: Color) -> Label:
	var label := Label.new()
	label.text = texto
	label.position = pos
	label.size = tam
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_estiloTexto(label, tamanhoFonte, cor)
	return label


func _estiloTexto(controle: Control, tamanho: int, cor: Color) -> void:
	if _fonte != null:
		controle.add_theme_font_override("font", _fonte)
	controle.add_theme_font_size_override("font_size", tamanho)
	controle.add_theme_color_override("font_color", cor)
	if controle is Button:
		controle.add_theme_color_override("font_hover_color", cor)
		controle.add_theme_color_override("font_pressed_color", cor)
		controle.add_theme_color_override("font_focus_color", cor)
