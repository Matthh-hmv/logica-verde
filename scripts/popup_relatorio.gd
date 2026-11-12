class_name PopupRelatorio
extends CanvasLayer

# Popup do relatório: pede o email da professora, envia o .csv (todos os alunos da sessão)
# pelo Resend e mostra a confirmação.
# Uso (na tela inicial):
#   var popup := PopupRelatorio.new()
#   add_child(popup)
#   popup.abrir(PopupRelatorio.Modo.RELATORIO)   # ou Modo.SAIR
# Ele se remove sozinho. No modo SAIR, o jogo fecha depois do OK (ou em "sair sem enviar").

signal fechado

enum Modo { RELATORIO, SAIR }

# ============ AJUSTE AQUI ============
const RESEND_API_KEY := ""   # cole aqui a chave da API do Resend
const REMETENTE := "Lógica Verde <onboarding@resend.dev>"
const URL_API := "https://api.resend.com/emails"

# true = depois de enviar, o arquivo vira "enviado_<data>.csv" e a próxima sessão começa do zero
const ARQUIVAR_APOS_ENVIO := true

const FONTE := "res://Assets/Fontes/Minecraft.ttf"
# =====================================

# Cores
const COR_PAINEL := Color("f5efe6")
const COR_BORDA := Color("3b8068")
const COR_VERDE := Color("2f7a4f")
const COR_TEXTO := Color("2b3a32")
const COR_BTN := Color("3aa862")
const COR_BTN_BORDA := Color("2a7d49")
const COR_ERRO := Color("c0392b")
const COR_FOCO := Color("ffcc33")

var _modo: Modo = Modo.RELATORIO
var _fonte: Font = null
var _caixa: VBoxContainer
var _http: HTTPRequest
var _campo: LineEdit
var _erro: Label
var _botaoEnviar: Button
var _botoesTela: Array[Button] = []
var _ocupado := false
var _naTelaEmail := false


# true se existe relatório gravado (algum aluno terminou o jogo nesta sessão)
static func temRelatorio() -> bool:
	return FileAccess.file_exists(RelatorioCSV.ARQUIVO) \
			and FileAccess.get_file_as_bytes(RelatorioCSV.ARQUIVO).size() > 0


func _ready() -> void:
	layer = 100
	if FONTE != "" and ResourceLoader.exists(FONTE):
		_fonte = load(FONTE)

	_http = HTTPRequest.new()
	_http.timeout = 30.0
	add_child(_http)
	_http.request_completed.connect(_aoResposta)

	var raiz := Control.new()
	add_child(raiz)
	raiz.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# fundo escuro que também bloqueia os cliques na tela de trás
	var escuro := ColorRect.new()
	escuro.color = Color(0, 0, 0, 0.6)
	escuro.mouse_filter = Control.MOUSE_FILTER_STOP
	raiz.add_child(escuro)
	escuro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var centro := CenterContainer.new()
	centro.mouse_filter = Control.MOUSE_FILTER_IGNORE
	raiz.add_child(centro)
	centro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var painel := PanelContainer.new()
	var estilo := _estilo(COR_PAINEL, COR_BORDA, 6, 20)
	estilo.set_content_margin_all(44)
	painel.add_theme_stylebox_override("panel", estilo)
	painel.custom_minimum_size = Vector2(880, 0)
	centro.add_child(painel)

	_caixa = VBoxContainer.new()
	_caixa.add_theme_constant_override("separation", 26)
	painel.add_child(_caixa)


func abrir(modo: Modo) -> void:
	_modo = modo
	if not temRelatorio():
		_telaAviso("SEM RELATÓRIO", "Nenhum aluno terminou o jogo ainda, então não há dados para enviar.")
		return
	_telaEmail("", Aluno.emailProfessora)


func _input(evento: InputEvent) -> void:
	# ESC fecha o popup na tela do email (sem sair do jogo)
	if _naTelaEmail and not _ocupado and evento.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_voltar()


# ---------- Telas ----------

func _telaEmail(mensagemErro: String, valor: String) -> void:
	_limpa()
	_naTelaEmail = true
	_caixa.add_child(_texto("ENVIAR RELATÓRIO", 54, COR_VERDE))
	_caixa.add_child(_texto("Digite o email que vai receber o relatório de desempenho dos alunos.", 30, COR_TEXTO))

	_campo = LineEdit.new()
	_campo.text = valor
	_campo.placeholder_text = "nome@email.com"
	_campo.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_campo.custom_minimum_size = Vector2(0, 74)
	_campo.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_EMAIL_ADDRESS
	_campo.add_theme_font_size_override("font_size", 32)
	_campo.add_theme_color_override("font_color", COR_TEXTO)
	_campo.add_theme_color_override("font_placeholder_color", Color("8a9a90"))
	_campo.add_theme_color_override("caret_color", COR_VERDE)
	if _fonte != null:
		_campo.add_theme_font_override("font", _fonte)
	_campo.add_theme_stylebox_override("normal", _estilo(Color.WHITE, COR_BORDA, 4, 12))
	_campo.add_theme_stylebox_override("focus", _estilo(Color.WHITE, COR_FOCO, 5, 12))
	_caixa.add_child(_campo)

	_erro = _texto(mensagemErro, 26, COR_ERRO)
	_erro.visible = mensagemErro != ""
	_caixa.add_child(_erro)
	_campo.text_changed.connect(func(_t: String) -> void: _erro.visible = false)
	_campo.text_submitted.connect(func(_t: String) -> void: _enviar())

	var linha := _linhaBotoes()
	_botaoEnviar = _botao("ENVIAR" if _modo == Modo.RELATORIO else "ENVIAR E SAIR", true)
	_botaoEnviar.pressed.connect(_enviar)
	linha.add_child(_botaoEnviar)

	var secundario := _botao("CANCELAR" if _modo == Modo.RELATORIO else "SAIR SEM ENVIAR", false)
	secundario.pressed.connect(_aoSecundario)
	linha.add_child(secundario)
	_botoesTela = [_botaoEnviar, secundario]

	if _modo == Modo.SAIR:
		var voltar := _botao("VOLTAR AO MENU", false)
		voltar.pressed.connect(_voltar)
		voltar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		_caixa.add_child(voltar)
		_botoesTela.append(voltar)

	_campo.call_deferred("grab_focus")


func _telaSucesso() -> void:
	_limpa()
	_caixa.add_child(_icone())
	_caixa.add_child(_texto("RELATÓRIO GERADO!", 54, COR_VERDE))
	_caixa.add_child(_texto("O arquivo em formato .CSV com o desempenho dos alunos foi enviado no seu email.", 30, COR_TEXTO))
	_adicionaOK()


func _telaAviso(titulo: String, texto: String) -> void:
	_limpa()
	_caixa.add_child(_texto(titulo, 54, COR_VERDE))
	_caixa.add_child(_texto(texto, 30, COR_TEXTO))
	_adicionaOK()


func _adicionaOK() -> void:
	var ok := _botao("OK", true)
	ok.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ok.pressed.connect(_finalizar)
	_caixa.add_child(ok)
	_botoesTela = [ok]
	ok.call_deferred("grab_focus")


# ---------- Envio ----------

func _enviar() -> void:
	if _ocupado:
		return
	var email := _campo.text.strip_edges()
	if not _emailValido(email):
		_erro.text = "Digite um email válido, por exemplo: nome@gmail.com"
		_erro.visible = true
		return

	Aluno.emailProfessora = email   # fica guardado para os próximos envios

	if RESEND_API_KEY == "":
		_telaEmail("Envio não configurado: falta a chave da API no script popup_relatorio.gd.", email)
		return

	var bytes := FileAccess.get_file_as_bytes(RelatorioCSV.ARQUIVO)
	if bytes.is_empty():
		_telaAviso("SEM RELATÓRIO", "Nenhum aluno terminou o jogo ainda, então não há dados para enviar.")
		return

	var alunos := bytes.get_string_from_utf8().count("Fase 1 - ")
	var d := Time.get_date_dict_from_system()
	var dataTexto := "%02d/%02d/%04d" % [d.day, d.month, d.year]
	var payload := {
		"from": REMETENTE,
		"to": [email],
		"subject": "Relatório de desempenho - Lógica Verde (%s)" % dataTexto,
		"html": "<h2>Relatório de desempenho - Lógica Verde</h2><p>Alunos neste relatório: <strong>%d</strong></p><p>Segue em anexo o arquivo .csv com o desempenho de cada aluno.</p>" % alunos,
		"attachments": [{
			"filename": "relatorio_desempenho_%04d-%02d-%02d.csv" % [d.year, d.month, d.day],
			"content": Marshalls.raw_to_base64(bytes),
		}],
	}
	var cabecalhos := PackedStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer " + RESEND_API_KEY,
	])

	_ocupado = true
	_travaBotoes(true)
	_botaoEnviar.text = "ENVIANDO..."
	var codigo := _http.request(URL_API, cabecalhos, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if codigo != OK:
		_ocupado = false
		_telaEmail("Não foi possível iniciar o envio. Tente de novo.", email)


func _aoResposta(resultado: int, codigoHttp: int, _cabecalhos: PackedStringArray, corpo: PackedByteArray) -> void:
	_ocupado = false
	var email := Aluno.emailProfessora

	if resultado != HTTPRequest.RESULT_SUCCESS:
		_telaEmail("Sem conexão com a internet. Verifique e tente de novo.", email)
		return

	if codigoHttp >= 200 and codigoHttp < 300:
		_arquivar()
		_telaSucesso()
		return

	push_warning("Resend: HTTP %d - %s" % [codigoHttp, corpo.get_string_from_utf8()])
	_telaEmail("O serviço de email recusou o envio (código %d). Confira o email digitado e tente de novo." % codigoHttp, email)


# depois de enviar, guarda o arquivo como "enviado" para a próxima sessão começar limpa
func _arquivar() -> void:
	if not ARQUIVAR_APOS_ENVIO:
		return
	var t := Time.get_datetime_dict_from_system()
	var novo := "%senviado_%04d%02d%02d_%02d%02d%02d.csv" % [RelatorioCSV.PASTA, t.year, t.month, t.day, t.hour, t.minute, t.second]
	DirAccess.rename_absolute(RelatorioCSV.ARQUIVO, novo)


func _emailValido(email: String) -> bool:
	var regex := RegEx.new()
	regex.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")
	return regex.search(email) != null


# ---------- Saída ----------

# botão secundário da tela do email: cancelar (relatório) ou sair sem enviar (sair)
func _aoSecundario() -> void:
	if _modo == Modo.SAIR:
		get_tree().quit()
	else:
		_voltar()


# fecha só o popup
func _voltar() -> void:
	fechado.emit()
	queue_free()


# depois do OK: no modo SAIR fecha o jogo, senão só fecha o popup
func _finalizar() -> void:
	if _modo == Modo.SAIR:
		get_tree().quit()
	else:
		_voltar()


# ---------- Ajudantes de interface ----------

func _limpa() -> void:
	_naTelaEmail = false
	for filho in _caixa.get_children():
		_caixa.remove_child(filho)
		filho.queue_free()


func _travaBotoes(travar: bool) -> void:
	for b in _botoesTela:
		b.disabled = travar


func _linhaBotoes() -> HBoxContainer:
	var linha := HBoxContainer.new()
	linha.alignment = BoxContainer.ALIGNMENT_CENTER
	linha.add_theme_constant_override("separation", 28)
	_caixa.add_child(linha)
	return linha


func _estilo(fundo: Color, borda: Color, espessura: int, raio: int) -> StyleBoxFlat:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = fundo
	estilo.border_color = borda
	estilo.set_border_width_all(espessura)
	estilo.set_corner_radius_all(raio)
	return estilo


func _estiloFoco(raio: int) -> StyleBoxFlat:
	var estilo := StyleBoxFlat.new()
	estilo.draw_center = false
	estilo.border_color = COR_FOCO
	estilo.set_border_width_all(5)
	estilo.set_corner_radius_all(raio)
	return estilo


func _texto(conteudo: String, tamanho: int, cor: Color) -> Label:
	var label := Label.new()
	label.text = conteudo
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", tamanho)
	label.add_theme_color_override("font_color", cor)
	if _fonte != null:
		label.add_theme_font_override("font", _fonte)
	return label


func _botao(conteudo: String, principal: bool) -> Button:
	var b := Button.new()
	b.text = conteudo
	b.custom_minimum_size = Vector2(300, 82)
	var fundo := COR_BTN if principal else COR_PAINEL
	var corTexto := Color.WHITE if principal else COR_VERDE
	b.add_theme_stylebox_override("normal", _estilo(fundo, COR_BTN_BORDA, 4, 14))
	b.add_theme_stylebox_override("hover", _estilo(fundo.lightened(0.12) if principal else Color("e4efe6"), COR_BTN_BORDA, 4, 14))
	b.add_theme_stylebox_override("pressed", _estilo(fundo.darkened(0.12), COR_BTN_BORDA, 4, 14))
	b.add_theme_stylebox_override("disabled", _estilo(Color("b8c4bc"), Color("93a398"), 4, 14))
	b.add_theme_stylebox_override("focus", _estiloFoco(14))
	b.add_theme_font_size_override("font_size", 30)
	for nome in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		b.add_theme_color_override(nome, corTexto)
	b.add_theme_color_override("font_disabled_color", Color("f2f2f2"))
	if _fonte != null:
		b.add_theme_font_override("font", _fonte)
	return b


# check verde desenhado em código
func _icone() -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(110, 84)
	c.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	c.draw.connect(func() -> void:
		c.draw_polyline(PackedVector2Array([Vector2(12, 44), Vector2(42, 74), Vector2(98, 10)]), COR_VERDE, 16.0)
	)
	return c
