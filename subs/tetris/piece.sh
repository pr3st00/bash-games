PIECE_COLOR="\e[32;42m"
NO_COLOR="\e[0m"

PIECE="${PIECE_COLOR}P${NO_COLOR}"

piece.initialize() {
	timer_start "piece.initialize"
	trace "Initializing piece"

	array.add "piece" "5,5" "$PIECE"
	array.add "piece" "5,6" "$PIECE"
	array.add "piece" "6,7" "$PIECE"

	changedCells+=("5,5")
	changedCells+=("5,6")
	changedCells+=("5,7")

	timer_stop "piece.initialize"
}

piece.move() {
	timer_start "snake.move"
	local x y i key
	local keyList

	trace "Moving snake"

	snake.trace "Initial"

	# 1. Move head to the selected direction
	for key in $(array.keys snakeHead); do
		x=${key%%,*}
		y=${key#*,}
	done

	array.remove	snakeHead "$x,$y"
	array.add	snakeTail "$x,$y" "$SNAKE_TAIL"

	snake.trace "After head movement"
	
	case "$DIRECTION" in
		R) ((x++));;
		L) ((x--));;
		U) ((y--));;
		D) ((y++));;
		*) ;;
	esac
		
	trace2 "Moving snakeHead to $x $y"
	array.add snakeHead "$x,$y" "$SNAKE_HEAD"
	changedCells+=("$x,$y")

	snake.trace "New Head"

	if [[ $(array.get "board" "$x,$y") == "$FOOD" ]]; then
		food.eat "$x,$y"
		food.create 1
	else
		# 2. Move
		trace2 "Removing snakeTail oldest element"
		removedKey=$(array.remove.first snakeTail 1)
		array.remove.first snakeTail
		trace2 "Element to be removed: $removedKey"

		array.add "board" "$removedKey" "$BLANK"
		changedCells+=("$removedKey")
	fi

	snake.trace "Final"

	timer_stop "snake.move"
}

piece.add.board() {
        array.copy "piece" "board"

	changedCells+=("5,5")
	changedCells+=("5,6")
	changedCells+=("6,6")
	changedCells+=("5,5")
	changedCells+=("5,6")
	changedCells+=("5,7")
}

# EOF
