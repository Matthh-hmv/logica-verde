extends Area2D
class_name CartaSelecionavel

signal clicked(carta: CartaSelecionavel)

@onready var textura_frente: Sprite2D = $TexturaFrente
@onready var colisao: CollisionShape2D = $CollisionShape2D


var isSelected: bool = false
var isLocked: bool = false
var id: int = -1
var valor: int = -1   # quantidade (carta de objeto) ou número (carta de número)


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if isLocked:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)

# Carrega a textura, lê o valor pelo final do nome do arquivo
# ("carta_bicicleta_3.png" -> 3, "numero_3.png" -> 3) e ajusta a colisão
func _aplicarTextura(caminho: String) -> void:
	textura_frente.texture = load(caminho)
	valor = id + 1   # id 0 = 1 item / número 1, id 1 = 2, ... (cartas em ordem crescente)
	_ajustarColisao()


func _ajustarColisao() -> void:
	if textura_frente.texture == null:
		return
	var tamanho: Vector2 = textura_frente.texture.get_size() * textura_frente.scale

	# uma shape nova para cada carta, senão todas dividem o mesmo recurso
	var shape := RectangleShape2D.new()
	shape.size = tamanho
	colisao.shape = shape

	if textura_frente.centered:
		colisao.position = textura_frente.position
	else:
		colisao.position = textura_frente.position + tamanho / 2.0


func combina(outra: CartaSelecionavel) -> bool:
	return valor == outra.valor


func selecionar(acertos: int) -> void:
	if isLocked or isSelected:
		return
	isSelected = true
	if acertos == 0:
		textura_frente.modulate = Color("fff28c")
	elif acertos == 1:
		textura_frente.modulate = Color("a6d9ff")
	else:
		textura_frente.modulate = Color("b3ffb3")
	


func deselecionar() -> void:
	if isLocked:
		return
	isSelected = false
	textura_frente.modulate = Color.WHITE


func par() -> void:
	isSelected = true
	isLocked = true
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.5, 0.3)
