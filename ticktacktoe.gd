extends Node2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var players = [1, 2]
var currentPlayer = players[0]
var gameover = false
var cpuRound = false
var timer = Timer.new()

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

func _verificaVencedor(compareGrid, playerToCompare):
	var winConditions = [
	[compareGrid[0], compareGrid[1], compareGrid[2]],
	[compareGrid[3], compareGrid[4], compareGrid[5]],
	[compareGrid[6], compareGrid[7], compareGrid[8]],
	[compareGrid[0], compareGrid[3], compareGrid[6]],
	[compareGrid[1], compareGrid[4], compareGrid[7]],
	[compareGrid[2], compareGrid[5], compareGrid[8]],
	[compareGrid[0], compareGrid[4], compareGrid[8]],
	[compareGrid[2], compareGrid[4], compareGrid[6]],
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
	return gotWinner == playerToCompare

func checkWinner(player):
	if(player == 1):
		narrador.text = "Jogador 1 venceu!"
		gameover = true
	elif(player == 2):
		narrador.text =  "Computador venceu!"
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
	
func _getPossibleMoves(grid):
	var possiblePositions = [];

	for gr in range(grid.size()):
		if(grid[gr] == 0):
			possiblePositions.push_back(gr)		
	return possiblePositions
	
func cpuPlay():
	var verificaVencedor = _verificaVencedor(grid, '111');
	if(verificaVencedor):
		checkWinner(1)
	
	var posicao = 0;
	if(gameover || !cpuRound):
		return

	var board = grid.duplicate()
	var possiblePositions = _getPossibleMoves(grid);
	var minimaxPlay = minimax(board, 2)
	if(possiblePositions.size() == 0):
		gameover = true
		narrador.text = "Deu velha!"
		return

	grid[minimaxPlay.index] = currentPlayer;
	blocos[minimaxPlay.index].setFrame(currentPlayer)
	currentPlayer = players[0]	

	cpuRound = false
	narrador.text = "Vez do jogador " + str(currentPlayer)
	verificaVencedor = _verificaVencedor(grid, '222');
	if(verificaVencedor):
		checkWinner(2)
	
func printGrid(grid):
	var haoy = """%s,%s,%s,
%s,%s,%s,
%s,%s,%s"""
	
	return haoy % [grid[0],grid[1],grid[2],grid[3],grid[4],grid[5],grid[6],grid[7],grid[8]]		
	
func minimax(newGrid, player, depth = 0, firstPlay = true):
	var jogadasPossiveis = _getPossibleMoves(newGrid);
	
	if (_verificaVencedor(newGrid, '111')):
		return {
			"score": -10
		}
	elif (_verificaVencedor(newGrid, '222')):
		return {
			"score": 10
		}
	elif (jogadasPossiveis.size() == 0):
		return {
			"score": 0
		}

	depth += 1
	var jogadasMinimax = [];
	
	for jogada in jogadasPossiveis:
		var move = {}
		move.index = jogada
		newGrid[jogada] = player

		if (player == 2):
			var resultado = minimax(newGrid, 1, depth, false);
			move.score = resultado.score;
		else:
			var resultado = minimax(newGrid, 2, depth, false);
			move.score = resultado.score;
	
		newGrid[jogada] = 0;
		jogadasMinimax.push_back(move);

	var melhorJogada;
	if player == 2:
    	var bestScore = -20;
    	for jogada in jogadasMinimax:
      		if (jogada.score > bestScore):
        		bestScore = jogada.score;
        		melhorJogada = jogada;
	else:
		var bestScore = 20;
		for jogada in jogadasMinimax:
			if (jogada.score < bestScore):
				bestScore = jogada.score;
				melhorJogada = jogada;

#	if(firstPlay):
#		print(jogadasMinimax)
#
	return melhorJogada;
						
func _on_setTick(posicao):
	var verificaVencedor = _verificaVencedor(grid, '222');
	if(verificaVencedor):
		checkWinner(2)

	if(gameover || cpuRound):
		return;
	
	if(grid[posicao] > 0):
		return
			
	grid[posicao] = currentPlayer;
	blocos[posicao].setFrame(currentPlayer)
	
	
	currentPlayer = players[1]
	cpuRound = true	
	if(cpuRound):
		narrador.text = "Vez do computador"
	verificaVencedor = _verificaVencedor(grid, '111');
	if(verificaVencedor):
		checkWinner(1)
		
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	get_parent().add_child(timer)
	timer.connect("timeout", self, "cpuPlay")
	timer.start()	

func _on_restart_game():
	resetGame()

func _on_reiniciar_mouse_exited():
	pass # Replace with function body.
