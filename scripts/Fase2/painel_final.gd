extends Control

signal continuar

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Fundo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	move_child($Fundo, 0)	# botão transparente por cima da seta da imagem
	$Continuar.focus_mode = Control.FOCUS_NONE
	for estado in ["normal", "hover", "pressed", "disabled"]:
		$Continuar.add_theme_stylebox_override(estado, StyleBoxEmpty.new())
	$Continuar.pressed.connect(func(): continuar.emit())
