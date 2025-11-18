SPEED=10
DIRECTION=D

FIFO_FILE=/tmp/gameinput

read_input() {
	local key parent_pid

	parent_pid=$1

	debug "Parent id is $parent_pid"

	while read -s -N 1 key 
	do
		trace2 "Got key $key" 	&& read

		case "$key" in
			w) DIRECTION=U;;
			s) DIRECTION=D;;
			a) DIRECTION=L;;
			d) DIRECTION=R;;
			q) break;;
		esac
		
		debug "Saving file $FIFO_FILE"
		echo $key > $FIFO_FILE
		#kill -SIGUSR1 $parent_pid
	done </dev/stdin
}

get_input() {
	local defaultValue

	defaultValue=$1

	if [[ -f $FIFO_FILE ]]; then
		cat $FIFO_FILE;
	else
		echo $defaultValue
	fi 
}

colision_detection() {

	local x y
	local key

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
	echoAt "**** GAME OVER *****" $((COLS/2)) $((ROWS/2))
	read
	exit;
}

game_loop() {
	snake.initialize
	board.initialize
	board.draw
	
	while (true); do
		timer_start "game_loop"
		changedCells=()
		DIRECTION=$(get_input "R")
		
		snake.move
		board.draw.optimized
		sleep $((10-$SPEED));
		if colision_detection; then
			game_over
		fi
		timer_stop "game_loop"		
	done
}

# EOF
