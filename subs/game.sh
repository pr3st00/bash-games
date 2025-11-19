SPEED=10
DIRECTION=D

# signals
SIG_UP=USR1
SIG_RIGHT=USR2
SIG_DOWN=URG
SIG_LEFT=IO
SIG_QUIT=WINCH
SIG_DEAD=HUP

change_direction() {
	local direction=$1
	trace2 "Changing direction to [$direction]"
	
	DIRECTION="$direction"
}

handle_signals() {
	trap "change_direction U" $SIG_UP
	trap "change_direction R" $SIG_RIGHT
	trap "change_direction D" $SIG_DOWN
	trap "change_direction L" $SIG_LEFT
	trap "exit 1;"		  $SIG_QUIT
}

read_input() {
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

colision_detection() {
	local x y
	local key value

	for key in $(array.keys snakeHead); do
		x=$(echo $key | cut -d',' -f1)
		y=$(echo $key | cut -d',' -f2)
	done

	if [[ $x -le 1 || $x -ge $((COLS-1)) ]]; then
		trace2 "Colision detected for X = $x"
		return 0
	fi

	if [[ $y -le 1 || $y -ge $((ROWS-1)) ]]; then
		trace2 "Colision detected for Y = $y"
		return 0
	fi

	trace2 "No colision detected for X = $x"
	return 1
}

game_over() {
	clear
	screen.echoAt "${TEXT_COLOR}**** GAME OVER *****${NO_COLOR}" $((COLS/2-20)) $((ROWS/2))
	read
	clear
}

game_loop() {
	handle_signals

	snake.initialize
	board.initialize
	food.create
	board.draw
	
	while (true); do
		timer_start "game_loop"
		changedCells=()

		snake.move
		board.draw
		sleep $((10-$SPEED));
		if colision_detection; then
			kill -$SIG_DEAD	$$
			return 0
		fi

		timer_stop "game_loop"		
	done
}

# EOF
