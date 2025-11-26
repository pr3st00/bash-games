# Game parameters
CONSTANT_DELAY=0.05
# 0 -> 10
SPEED=10
DIRECTION=N

# Signals
SIG_UP=USR1
SIG_RIGHT=USR2
SIG_DOWN=URG
SIG_LEFT=IO
SIG_QUIT=WINCH
SIG_DEAD=HUP

declare -A prohibitedMoves

game.change.direction() {
	local direction=$1
	trace2 "Changing direction to [$direction]"

	if piece.still.moving; then
		trace2 "Not changing direction cause the piece is still moving"
		return 1
	fi

	DIRECTION="$direction"
}

game.handle.signals() {
	trap "game.change.direction U"	$SIG_UP
	trap "game.change.direction R"	$SIG_RIGHT
	trap "game.change.direction D"	$SIG_DOWN
	trap "game.change.direction L"	$SIG_LEFT
	trap "exit 1;"		  	$SIG_QUIT
}

game.read.input() {
	local key game_pid

	game_pid=$1

	debug "Game PID is $game_pid"

	trap "" SIGINT SIGQUIT
	trap "return;" $SIG_DEAD

	while true; do
		read -s -n 1 key
		trace2 "Got key $key"

		case "$key" in
			[qQ]) 	kill -$SIG_QUIT		$game_pid
				return
				;;
			[wW]) 	kill -$SIG_UP		$game_pid
				;;
			[sS])	kill -$SIG_DOWN		$game_pid
				;;
			[aA]) 	kill -$SIG_LEFT		$game_pid
				;;
			[dD])	kill -$SIG_RIGHT	$game_pid
				;;
		esac
	done
}

game.collision.detection() {
	local x y key

	trace "Running collision detection"
	trace2 "No collision detected for [$x,$y]"

	return 1
}

game.over() {
	clear
	local score=$(score.get)
	screen.echoAt "${TEXT_COLOR}     GAME OVER     ${NO_COLOR}" $((COLS/2-10)) $((ROWS/2))
	screen.echoAt "${TEXT_COLOR}   SCORE: $score   ${NO_COLOR}" $((COLS/2-10)) $((ROWS/2 + 1))
	screen.echoAt "${TEXT_COLOR} (press enter key) ${NO_COLOR}" $((COLS/2-10)) $((ROWS/2 + 2))
	read -s 
	clear
}

game.loop() {
	game.handle.signals

	board.initialize
	piece.initialize
	piece.add.board
	board.draw
	
	while (true); do
		timer_start "game_loop"
		changedCells=()

		score.refresh

		if game.collision.detection; then
			kill -$SIG_DEAD	$$
			return 1
		fi

		piece.move
		piece.add.board

		board.draw

		sleep $(bc <<< "$CONSTANT_DELAY + (10-$SPEED)/10")

		timer_stop "game_loop"		
	done
}

# EOF
