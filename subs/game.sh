# Game parameters
SPEED=10
DIRECTION=D
INITIAL_FOOD=3

# Signals
SIG_UP=USR1
SIG_RIGHT=USR2
SIG_DOWN=URG
SIG_LEFT=IO
SIG_QUIT=WINCH
SIG_DEAD=HUP

declare -A prohibitedMoves

prohibitedMoves["U"]="D";
prohibitedMoves["D"]="U";
prohibitedMoves["L"]="R";
prohibitedMoves["R"]="L";

game.change.direction() {
	local direction=$1
	trace2 "Changing direction to [$direction]"

	if [[ ${prohibitedMoves[$DIRECTION]} == "$direction" ]]; then
		trace2 "Prohibited Move"
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

game.colision.detection() {
	local x y key

	trace "Running colision detection"

	for key in $(array.keys snakeHead); do
		x=$(echo $key | cut -d',' -f1)
		y=$(echo $key | cut -d',' -f2)
	done

	# Have we hit right or left walls?
	if [[ $x -le 1 || $x -ge $((COLS-1)) ]]; then
		trace2 "Colision detected for X = $x"
		return 0
	fi

	# Have we hit up or down walls?
	if [[ $y -le 1 || $y -ge $((ROWS-1)) ]]; then
		trace2 "Colision detected for Y = $y"
		return 0
	fi

	# Does our head overlaps with our tail after movement?
	if [[ $(array.get "board" "$x,$y") == "$SNAKE_TAIL" ]]; then
		trace2 "Colision detected for [$x,$y]" && sleep 5
		return 0
	fi

	trace2 "No colision detected for [$x,$y]"
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

	snake.initialize
	board.initialize
	food.create $INITIAL_FOOD
	board.draw
	
	while (true); do
		timer_start "game_loop"
		changedCells=()

		score.refresh
		snake.move

		if game.colision.detection; then
			kill -$SIG_DEAD	$$
			return 0
		fi

		board.draw
		sleep $((10-$SPEED));

		timer_stop "game_loop"		
	done
}

# EOF
