class_name BancoDesafios

# CONTAS
# contexto = texto do enunciado
# tiles    = os 4 quadrados da conta [dezena, unidade, operador, segundo número]
# opcoes   = texto dos 3 botões de resultado
# certa    = índice da opção correta (0, 1 ou 2)
# final    = mensagem depois do "Parabéns"
const CONTAS := [
	{
		"contexto": "Nossa praça tinha 31 árvores, e hoje os alunos plantaram mais 5.\n\nQuantas árvores temos no total agora?",
		"tiles": ["3", "1", "+", "5"],
		"opcoes": ["36", "02", "21"], "certa": 0,
		"final": "Agora a praça tem 36 árvores, com mais sombra e ar limpo!",
	},
	{
		"contexto": "Na ciclofaixa da escola passaram 24 bicicletas de manhã e mais 8 à tarde.\n\nQuantas bicicletas passaram no total?",
		"tiles": ["2", "4", "+", "8"],
		"opcoes": ["16", "32", "30"], "certa": 1,
		"final": "Foram 32 bicicletas: menos carros e mais ar limpo na cidade!",
	},
	{
		"contexto": "A escola já tem 18 painéis solares e vai instalar mais 7.\n\nQuantos painéis serão no total?",
		"tiles": ["1", "8", "+", "7"],
		"opcoes": ["11", "24", "25"], "certa": 2,
		"final": "Agora são 25 painéis gerando energia limpa para a escola!",
	},
	{
		"contexto": "O ônibus saiu com 40 alunos e 9 desceram na primeira parada.\n\nQuantos alunos continuam no ônibus?",
		"tiles": ["4", "0", "-", "9"],
		"opcoes": ["31", "49", "41"], "certa": 0,
		"final": "Continuam 31 alunos. O transporte coletivo leva muita gente de uma vez!",
	},
	{
		"contexto": "O bairro tinha 27 lixeiras de coleta seletiva, mas 6 quebraram.\n\nQuantas lixeiras ainda funcionam?",
		"tiles": ["2", "7", "-", "6"],
		"opcoes": ["33", "21", "22"], "certa": 1,
		"final": "Ainda funcionam 21 lixeiras. Vamos consertar as outras para reciclar mais!",
	},
	{
		"contexto": "A rua da escola tinha 45 lâmpadas antigas, e a prefeitura já trocou 8 por luzes de LED.\n\nQuantas lâmpadas ainda faltam trocar?",
		"tiles": ["4", "5", "-", "8"],
		"opcoes": ["53", "37", "36"], "certa": 1,
		"final": "Faltam 37 lâmpadas. As luzes de LED iluminam melhor e gastam menos energia!",
	},
	
	{
		"contexto": "No ponto de reciclagem foram entregues 26 garrafas de vidro de manhã e mais 7 à tarde.\n\nQuantas garrafas foram recicladas?",
		"tiles": ["2", "6", "+", "7"],
		"opcoes": ["19", "32", "33"], "certa": 2,
		"final": "Foram 33 garrafas! Reciclar o lixo mantém as ruas e os rios da cidade limpos.",
	},
	
	{
		"contexto": "Na horta comunitária do bairro colhemos 34 alfaces ontem e mais 5 hoje.\n\nQuantas alfaces colhemos no total?",
		"tiles": ["3", "4", "+", "5"],
		"opcoes": ["39", "29", "38"], "certa": 0,
		"final": "Colhemos 39 alfaces! Produzir comida perto de casa deixa a cidade mais saudável.",
	}
]

# SUSTENTAVEIS
# opcoes = as 2 cartas (nome + imagem do objeto)
# certa  = índice da carta mais sustentável (0 ou 1)
# final  = opcional
const SUSTENTAVEIS := [
	{
		"opcoes": [
			{"nome": "Sacola plástica", "imagem": "res://Assets/Objetos/sacola_de_plastico.png"},
			{"nome": "Ecobag", "imagem": "res://Assets/Objetos/ecobag.png"},
		],
		"certa": 1,
	},
	{
		"opcoes": [
			{"nome": "Bicicleta", "imagem": "res://Assets/Objetos/bicicleta.png"},
			{"nome": "Moto", "imagem": "res://Assets/Objetos/moto.png"},
		],
		"certa": 0,
	},
	{
		"opcoes": [
			{"nome": "Copo plástico", "imagem": "res://Assets/Objetos/copo_plastico.png"},
			{"nome": "Caneca", "imagem": "res://Assets/Objetos/caneca.png"},
		],
		"certa": 1,
	},
	{
		"opcoes": [
			{"nome": "Carro", "imagem": "res://Assets/Objetos/carro.png"},
			{"nome": "Ônibus", "imagem": "res://Assets/Objetos/onibus.png"},
		],
		"certa": 1,
	},
	{
		"opcoes": [
			{"nome": "Garrafa reutilizável", "imagem": "res://Assets/Objetos/garrafa_reutilizavel.png"},
			{"nome": "Garrafa plástica", "imagem": "res://Assets/Objetos/garrafa_de_agua_de_plastico.png"},
		],
		"certa": 0,
	}
]
