class_name PainelLateral
extends Control

func _ready() -> void:
	mostrar_direcoes()

func mostrar_direcoes(_texto := "") -> void:
	$PainelConta.hide()
	$PainelSustentavel.hide()


func executar_conta(d: Dictionary, chances: int) -> bool:
	$PainelConta.show()
	var acertou: bool = await $PainelConta.executar(d, chances)
	$PainelConta.hide()
	return acertou

func executar_sustentavel(d: Dictionary, chances: int) -> bool:
	$PainelSustentavel.show()
	var acertou: bool = await $PainelSustentavel.executar(d, chances)
	$PainelSustentavel.hide()
	return acertou
	
