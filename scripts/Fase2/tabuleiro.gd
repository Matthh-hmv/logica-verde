extends Node2D

@onready var onibus: Sprite2D = $Onibus
@onready var painel: PainelLateral = $Painel

@export var casa_inicial: Casa
@export var estrela_amarela: Texture2D
@export var chances_conta := 3
@export var chances_sustentavel := 2
@export_multiline var instrucao_inicial := "Ande até a próxima casa azul"

var atual: Casa
var movendo := false
var fim := false

func _ready() -> void:
	if casa_inicial == null:
		push_error("Defina a Casa Inicial no Inspector do tabuleiro!")
		return
	atual = casa_inicial
	onibus.global_position = atual.global_position
	_sortear_desafios()
	painel.mostrar_direcoes(instrucao_inicial)
	$Painel/PainelFinal.continuar.connect(_ao_continuar)

func _sortear_desafios() -> void:
	var azuis := []
	var vermelhas := []
	for c in get_tree().get_nodes_in_group("casas"):
		if c.tipo == Casa.Tipo.AZUL:
			azuis.append(c)
		elif c.tipo == Casa.Tipo.VERMELHA:
			vermelhas.append(c)

	var contas := BancoDesafios.CONTAS.duplicate()
	contas.shuffle()
	for i in mini(azuis.size(), contas.size()):
		azuis[i].desafio = contas[i]

	var escolhas := BancoDesafios.SUSTENTAVEIS.duplicate()
	escolhas.shuffle()
	for i in mini(vermelhas.size(), escolhas.size()):
		vermelhas[i].desafio = escolhas[i]

func _mover(direcao: String) -> void:
	if movendo or fim:
		return
	var destino: Casa = atual.vizinhas.get(direcao)
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
	var pos := onibus.position
	var tween := create_tween()
	tween.tween_property(onibus, "position:x", pos.x + 6, 0.05)
	tween.tween_property(onibus, "position:x", pos.x - 6, 0.05)
	tween.tween_property(onibus, "position:x", pos.x, 0.05)

func _chegou(casa: Casa) -> void:
	if casa.eh_escola:
		painel.mostrar_final()
		print("Chegou na escola!")
		return
		
	if casa.completada or casa.desafio.is_empty():
		return

	var acertou := false
	if casa.tipo == Casa.Tipo.AZUL:
		acertou = await painel.executar_conta(casa.desafio, chances_conta)
	else:
		acertou = await painel.executar_sustentavel(casa.desafio, chances_sustentavel)

	if acertou:
		casa.completar(estrela_amarela)
		painel.mostrar_direcoes(casa.instrucao_seguinte)
	else:
		painel.mostrar_direcoes()


func _on_botao_cima_pressed() -> void:
	_mover("cima")

func _on_botao_baixo_pressed() -> void:
	_mover("baixo")

func _on_botao_direita_pressed() -> void:
	_mover("direita")

func _on_botao_esquerda_pressed() -> void:
	_mover("esquerda")
	
func _ao_continuar() -> void:
	print("Fim do jogo, continuar...")
	# get_tree().change_scene_to_file("res://caminho_da_proxima_cena.tscn")
