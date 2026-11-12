extends Node

var nivelAtual: int = 1

var player := AudioStreamPlayer.new()

func _ready() -> void:
	add_child(player)

func falar(caminho: String) -> bool:
	if not ResourceLoader.exists(caminho):
		push_warning("Áudio não encontrado: " + caminho)
		return false
	player.stop()
	player.stream = load(caminho)
	player.play()
	return true

# Fala e só continua quando o áudio terminar
func falarEEsperar(caminho: String) -> void:
	if falar(caminho):
		await player.finished

func esperarTerminar() -> void:
	if player.playing:
		await player.finished
