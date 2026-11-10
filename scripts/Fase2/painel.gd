class_name PainelLateral
extends Control

func _ready() -> void:
	mostrar("Direcoes")

func mostrar(nome: String) -> void:
	for tela in get_children():
		tela.visible = (tela.name == nome)

func mostrar_direcoes(texto := "") -> void:
	if texto != "":
		$Direcoes/Texto.text = texto
	mostrar("Direcoes")

func executar_conta(d: Dictionary, chances: int) -> bool:
	mostrar("PainelConta")
	return await $PainelConta.executar(d, chances)

func executar_sustentavel(d: Dictionary, chances: int) -> bool:
	mostrar("PainelSustentavel")
	return await $PainelSustentavel.executar(d, chances)
