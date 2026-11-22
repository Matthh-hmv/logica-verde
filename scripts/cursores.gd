extends Node

# Cursores personalizados do jogo (autoload "Cursores").
# - seta: cursor normal
# - mão: ao passar por cima de qualquer botão
# - mão com brilho: enquanto o botão do mouse está pressionado em cima de um botão
# - barra de texto: ao passar por cima de campos de escrita (LineEdit, TextEdit)
# Os botões são detectados sozinhos (todo BaseButton: Button, TextureButton...).
# Para usar a mão em outro nó de interface, ponha nele:
#   mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

const SETA := "res://assets/ui/cursores/cursorSeta.png"
const MAO := "res://assets/ui/cursores/cursorMao.png"
const CLIQUE := "res://assets/ui/cursores/cursorClique.png"
const TEXTO := "res://assets/ui/cursores/cursorTexto.png"

# Ponto do clique dentro da imagem (em pixels, a partir do canto de cima à esquerda)
const PONTA_SETA := Vector2(1, 1)
const PONTA_MAO := Vector2(28, 2)   # ponta do dedo
const PONTA_TEXTO := Vector2(14, 34)   # meio da barra

var _mao: Texture2D
var _clique: Texture2D


func _ready() -> void:
	Input.set_custom_mouse_cursor(load(SETA), Input.CURSOR_ARROW, PONTA_SETA)
	_mao = load(MAO)
	_clique = load(CLIQUE)
	Input.set_custom_mouse_cursor(_mao, Input.CURSOR_POINTING_HAND, PONTA_MAO)
	# campos de escrita já usam esse formato de cursor por padrão no Godot
	Input.set_custom_mouse_cursor(load(TEXTO), Input.CURSOR_IBEAM, PONTA_TEXTO)

	# botões que já existem e os que forem criados depois (troca de cena, popups)
	_aplicaEmBotoes(get_tree().root)
	get_tree().node_added.connect(_aoNodeAdicionado)


func _input(evento: InputEvent) -> void:
	if evento is InputEventMouseButton and evento.button_index == MOUSE_BUTTON_LEFT:
		var imagem := _clique if evento.pressed else _mao
		Input.set_custom_mouse_cursor(imagem, Input.CURSOR_POINTING_HAND, PONTA_MAO)


func _aoNodeAdicionado(node: Node) -> void:
	if node is BaseButton:
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _aplicaEmBotoes(node: Node) -> void:
	_aoNodeAdicionado(node)
	for filho in node.get_children():
		_aplicaEmBotoes(filho)
