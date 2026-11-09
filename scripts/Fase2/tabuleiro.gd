extends Node2D

@onready var onibus: Sprite2D = $Onibus
@export var casa_inicial: Casa
@export var tela_conta: PackedScene
@export var tela_sustentavel: PackedScene

var atual: Casa
var movendo := false

func _ready() -> void:
	if casa_inicial == null:
		push_error("Defina a Casa Inicial no Inspector do tabuleiro!")
		return
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
	await _chegou(atual)
	movendo = false

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
		return
	if casa.completada:
		return
	match casa.tipo:
		Casa.Tipo.AZUL:
			await _abrir_desafio(tela_conta, 3, casa)
		Casa.Tipo.VERMELHA:
			await _abrir_desafio(tela_sustentavel, 2, casa)

func _abrir_desafio(cena: PackedScene, chances: int, casa: Casa) -> void:
	var tela = cena.instantiate()
	tela.chances = chances
	$Telas.add_child(tela)
	var acertou: bool = await tela.terminou
	tela.queue_free()
	if acertou:
		casa.completar()


func _on_botao_cima_pressed() -> void:
	_mover("cima")

func _on_botao_baixo_pressed() -> void:
	_mover("baixo")

func _on_botao_direita_pressed() -> void:
	_mover("direita")
	
func _on_botao_esquerda_pressed() -> void:
	_mover("esquerda")
