extends Control

signal continuar

const AUDIO_FINAL := "res://Assets/Áudios/Fases/Fase 2 (Kamilla)/geral/Parabens, você chegou até a escola.wav"
const AUDIO_CONTINUAR := "res://Assets/Áudios/Fases/Fase 2 (Kamilla)/geral/continuar.wav"

# true = o Continuar só libera depois de ouvir o áudio final até o fim
const OUVIR_ATE_O_FIM := true

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Fundo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	move_child($Fundo, 0)	# botão transparente por cima da seta da imagem
	$Continuar.focus_mode = Control.FOCUS_NONE
	for estado in ["normal", "hover", "pressed", "disabled"]:
		$Continuar.add_theme_stylebox_override(estado, StyleBoxEmpty.new())
	$Continuar.mouse_entered.connect(_ao_passar_continuar)
	$Continuar.pressed.connect(func(): continuar.emit())

# chamado pelo painel lateral quando a tela final aparece
func narrar_final() -> void:
	Narrador.falar(AUDIO_FINAL)
	if OUVIR_ATE_O_FIM:
		$Continuar.disabled = true
		await Narrador.esperarTerminar()
		$Continuar.disabled = false

func _ao_passar_continuar() -> void:
	if not $Continuar.disabled:
		Narrador.falar(AUDIO_CONTINUAR)
