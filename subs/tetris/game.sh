# Game parameters
CONSTANT_DELAY=0.1
# 0 -> 10
SPEED=10
DIRECTION=N
ROTATE=N
GRAVITY_FRAME_SKIP=3

# Signals
SIG_UP=USR1
SIG_RIGHT=USR2
SIG_DOWN=URG
SIG_LEFT=IO
SIG_QUIT=WINCH
SIG_DEAD=HUP

SIG_ROTATE_L=QUIT
SIG_ROTATE_R=ALRM

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

game.rotate() {
	local direction=$1
	trace2 "Rotating to [$direction]"

	ROTATE="$direction"
}

game.handle.signals() {
	trap "game.change.direction U"	$SIG_UP
	trap "game.change.direction R"	$SIG_RIGHT
	trap "game.change.direction D"	$SIG_DOWN
	trap "game.change.direction L"	$SIG_LEFT
	trap "game.rotate L"		$SIG_ROTATE_L
	trap "game.rotate R"		$SIG_ROTATE_R
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
			[1])	kill -$SIG_ROTATE_L	$game_pid
				;;
			[2])	kill -$SIG_ROTATE_R	$game_pid
				;;
		esac
	done
}

game.is.over() {
	local keys=$(array.keys "board")
	local x
	local result=1

	for ((x=1;x<$COLS;x++)); do
		[[ $(array.get "board" "$x,2") == "$DEAD_PIECE" ]] && result=0
	done

	return $result
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

	local frame=0
	
	while (true); do
		timer_start "game_loop"
		changedCells=()
		((frame++))

		score.refresh

		if game.is.over; then
			kill -$SIG_DEAD	$$
			return 1
		fi

		if [[ $((frame % $GRAVITY_FRAME_SKIP)) == 0 ]]; then
			piece.gravity
		fi

		piece.rotate
		piece.move
		piece.add.board

		board.draw

		sleep $(bc <<< "$CONSTANT_DELAY + (10-$SPEED)/10")

		timer_stop "game_loop"		
	done
}

# EOF
