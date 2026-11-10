class_name BancoDesafios

# CONTAS: imagens prontas (contexto e conta). opcoes = texto dos 3 botões.
# certa = índice da opção correta (começa em 0). final = mensagem depois do "Parabéns".
const CONTAS := [
	{
		"imagem_contexto": "res://Assets/Contas Fase1/conta1_contexto.png",
		"imagem_conta": "res://Assets/Contas Fase1/conta1.png",
		"opcoes": ["36", "02", "21"], "certa": 0,
		"final": "Agora a praça tem 36 árvores, com mais sombra e ar limpo!",
	},
	{
		"imagem_contexto": "res://imagens/contas/conta2_contexto.png",
		"imagem_conta": "res://imagens/contas/conta2_conta.png",
		"opcoes": ["16", "32", "30"], "certa": 1,
		"final": "Foram 32 bicicletas: menos carros e mais ar limpo na cidade!",
	},
	{
		"imagem_contexto": "res://imagens/contas/conta3_contexto.png",
		"imagem_conta": "res://imagens/contas/conta3_conta.png",
		"opcoes": ["11", "24", "25"], "certa": 2,
		"final": "Agora são 25 painéis gerando energia limpa para a escola!",
	},
	{
		"imagem_contexto": "res://imagens/contas/conta4_contexto.png",
		"imagem_conta": "res://imagens/contas/conta4_conta.png",
		"opcoes": ["31", "49", "41"], "certa": 0,
		"final": "Continuam 31 alunos. O transporte coletivo leva muita gente de uma vez!",
	},
	{
		"imagem_contexto": "res://imagens/contas/conta5_contexto.png",
		"imagem_conta": "res://imagens/contas/conta5_conta.png",
		"opcoes": ["33", "21", "22"], "certa": 1,
		"final": "Ainda funcionam 21 lixeiras. Vamos consertar as outras para reciclar mais!",
	},
	{
		"imagem_contexto": "res://imagens/contas/conta6_contexto.png",
		"imagem_conta": "res://imagens/contas/conta6_conta.png",
		"opcoes": ["16", "46", "48"], "certa": 2,
		"final": "Foram 48 mudas! A cidade vai ficar mais verde e fresca.",
	},
]

# SUSTENTAVEIS: imagem_pergunta = quadro pronto. Cada opção é uma carta (nome + imagem).
# certa = índice da carta correta (começa em 0). "final" é opcional.
const SUSTENTAVEIS := [
	{
		"imagem_pergunta": "res://imagens/sustentavel/pergunta1.png", "certa": 1,
		"opcoes": [
			{"nome": "Sacola plástica", "imagem": "res://imagens/cartas/sacola.png"},
			{"nome": "Ecobag", "imagem": "res://imagens/cartas/ecobag.png"},
		],
	},
	{
		"imagem_pergunta": "res://imagens/sustentavel/pergunta2.png", "certa": 0,
		"opcoes": [
			{"nome": "Bicicleta", "imagem": "res://imagens/cartas/bicicleta.png"},
			{"nome": "Carro", "imagem": "res://imagens/cartas/carro.png"},
		],
	},
	{
		"imagem_pergunta": "res://imagens/sustentavel/pergunta3.png", "certa": 0,
		"opcoes": [
			{"nome": "Banho de 5 minutos", "imagem": "res://imagens/cartas/banho_curto.png"},
			{"nome": "Banho de 20 minutos", "imagem": "res://imagens/cartas/banho_longo.png"},
		],
	},
	{
		"imagem_pergunta": "res://imagens/sustentavel/pergunta4.png", "certa": 1,
		"opcoes": [
			{"nome": "Copo descartável", "imagem": "res://imagens/cartas/copo.png"},
			{"nome": "Garrafa reutilizável", "imagem": "res://imagens/cartas/garrafa.png"},
		],
	},
	{
		"imagem_pergunta": "res://imagens/sustentavel/pergunta5.png", "certa": 1,
		"opcoes": [
			{"nome": "Lixeira comum", "imagem": "res://imagens/cartas/lixo_comum.png"},
			{"nome": "Lixeira de reciclagem", "imagem": "res://imagens/cartas/reciclagem.png"},
		],
	},
	{
		"imagem_pergunta": "res://imagens/sustentavel/pergunta6.png", "certa": 0,
		"opcoes": [
			{"nome": "Luz natural da janela", "imagem": "res://imagens/cartas/janela.png"},
			{"nome": "Todas as lâmpadas acesas", "imagem": "res://imagens/cartas/lampadas.png"},
		],
	},
]
