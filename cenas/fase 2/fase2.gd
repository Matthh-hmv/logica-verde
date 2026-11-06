extends Node2D

@onready var onibus : Sprite2D = $Onibus
@export var caminho : Array[Node]
var place : int = 0
var numeroDeCasas : int

func _ready() -> void:
	numeroDeCasas = caminho.size()
	print(numeroDeCasas)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_click") and place <= (numeroDeCasas - 1):
		var tween = create_tween()
		tween.tween_property(onibus, "position", caminho[place].position, 1)
		place += 1
		
	elif place >= numeroDeCasas:
		print("fora do caminho")
