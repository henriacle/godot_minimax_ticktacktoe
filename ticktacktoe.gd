extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var players = [1, 2]
var currentPlayer = players[0]
var gameover = false
var cpuRound = false

var grid = [
0,0,0,
0,0,0,
0,0,0
]

var blocos = []
var narrador = null

# Called when the node enters the scene tree for the first time.
func _ready():
	blocos = [$block, $block2, $block3, $block4, $block5, $block6,
	$block7, $block8, $block9]
	
	narrador = $narrador
	
	$reiniciar.connect("restart", self, "_on_restart_game")
	
	for bloco in blocos:
		bloco.connect("hit", self, "_on_setTick")
	narrador.text = "Vez do jogador " + str(currentPlayer)

func _verificaVencedor(grid):
	var winConditions = [
	[grid[0], grid[1], grid[2]],
	[grid[3], grid[4], grid[5]],
	[grid[6], grid[7], grid[8]],
	[grid[0], grid[3], grid[6]],
	[grid[1], grid[4], grid[7]],
	[grid[2], grid[5], grid[8]],
	[grid[0], grid[4], grid[8]],
	[grid[2], grid[4], grid[6]],
	]
	
	var gotWinner = null
	
	for win in winConditions:
		var player = ""
		for condition in win:
			player += str(condition)
		if(player == "111"):
			gotWinner = player
		elif(player == "222"):
			gotWinner = player
	return gotWinner

func checkWinner(player):
	if(player == "111"):
		narrador.text = "Jogador 1 venceu!"
		gameover = true
	elif(player == "222"):
		narrador.text =  "Jogador 2 venceu!"
		gameover = true	

func resetGame():
	players = [1, 2]
	currentPlayer = players[0]
	gameover = false
	cpuRound = false
	
	grid = [
	0,0,0,
	0,0,0,
	0,0,0
	]

	for block in blocos:
		block.setFrame(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _getPossibleMoves():
	var possiblePositions = [];

	for gr in range(grid.size()):
		if(grid[gr] == 0):
			possiblePositions.push_front(gr)		
	return possiblePositions
	
func cpuPlay():
	var verificaVencedor = _verificaVencedor(grid);
	checkWinner(verificaVencedor)
	
	var posicao = 0;
	if(gameover || !cpuRound):
		return

	var possiblePositions = _getPossibleMoves();
	var minimaxPlay = minimax(possiblePositions)
	
	if(possiblePositions.size() == 0):
		gameover = true
		narrador.text = "Deu velha!"
		return
		
	grid[minimaxPlay] = currentPlayer;
	blocos[minimaxPlay].setFrame(currentPlayer)
	currentPlayer = players[0]	

	cpuRound = false
	narrador.text = "Vez do jogador " + str(currentPlayer)
	verificaVencedor = _verificaVencedor(grid);
	checkWinner(verificaVencedor)
	
func minimax(possiblePositions):
	var jogada = null
	var jogadas = {}
	var bestMove = 4

	if(possiblePositions.has(4)):
		return 4

	for move in possiblePositions:
		var curPlayer = 2
		jogadas[move] = {
			"cpuScore": 0,
			"playerScore": 0
		}
		
		var containsVencedor = []
		var board = grid.duplicate()
		
		board[move] = 1
		var verificaVencedor = _verificaVencedor(board);
			
		if(verificaVencedor == '111'):
			return move
		else:
			board[move] = 0

		board[move] = curPlayer

		for gridPos in range(board.size()):
			if(board[gridPos] == 0):
				board[gridPos] = curPlayer
				verificaVencedor = _verificaVencedor(board);
				if(curPlayer == 2):
					curPlayer = 1
				elif(curPlayer == 1):
					curPlayer = 2
		
			if(verificaVencedor == '222'):
				jogadas[move].cpuScore += 10
				jogadas[move].playerScore += -10
			elif(verificaVencedor == '111'):
				jogadas[move].playerScore 	+= 10
				jogadas[move].cpuScore 		+= -10
			elif(verificaVencedor == null):
				jogadas[move].cpuScore 	  += 0
				jogadas[move].playerScore += 0			
	
	var positionToChoose = null
	var score = 0;
	
	for move in possiblePositions:
		if(jogadas[move].cpuScore > jogadas[move].playerScore && jogadas[move].cpuScore > score):
			score = jogadas[move].cpuScore
			positionToChoose = move
			
	return positionToChoose
	
func _on_setTick(posicao):
	var verificaVencedor = _verificaVencedor(grid);
	checkWinner(verificaVencedor)

	if(gameover || cpuRound):
		return;
	
	if(grid[posicao] > 0):
		return
			
	grid[posicao] = currentPlayer;
	blocos[posicao].setFrame(currentPlayer)
	
	
	currentPlayer = players[1]
	cpuRound = true	
	narrador.text = "Vez do jogador " + str(currentPlayer)
	verificaVencedor = _verificaVencedor(grid);
	checkWinner(verificaVencedor)
	cpuPlay()
	
func _on_restart_game():
	resetGame()

func _on_reiniciar_mouse_exited():
	pass # Replace with function body.
