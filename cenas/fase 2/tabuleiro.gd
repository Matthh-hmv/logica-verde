extends Node2D

@onready var onibus: Sprite2D = $Onibus
@export var casa_inicial: Casa

var atual: Casa
var movendo := false

func _ready() -> void:
	atual = casa_inicial
	onibus.global_position = atual.global_position

func _mover(direcao: String) -> void:
	print("direção: ", direcao, " | casa atual: ", atual.name, " | destino: ", atual.get(direcao))
	if movendo:
		return
	var destino: Casa = atual.get(direcao)
	if destino == null:
		_bloqueado()
		return
	movendo = true
	var tween := create_tween()
	tween.tween_property(onibus, "global_position", destino.global_position, 0.5)
	await tween.finished
	atual = destino
	movendo = false
	_chegou(atual)

func _bloqueado() -> void:
	# pequeno "tremidinha" para indicar que não há caminho
	var pos := onibus.position
	var tween := create_tween()
	tween.tween_property(onibus, "position:x", pos.x + 6, 0.05)
	tween.tween_property(onibus, "position:x", pos.x - 6, 0.05)
	tween.tween_property(onibus, "position:x", pos.x, 0.05)

func _chegou(casa: Casa) -> void:
	if casa.eh_escola:
		print("Chegou na escola!")
	# aqui você pode abrir o popup de desafio de matemática


func _on_botao_cima_pressed() -> void:
	_mover("cima")

func _on_botao_baixo_pressed() -> void:
	_mover("baixo")

func _on_botao_direita_pressed() -> void:
	_mover("direita")
	
func _on_botao_esquerda_pressed() -> void:
	_mover("esquerda")
