SNAKE_COLOR="\e[32;42m"
NO_COLOR="\e[0m"

SNAKE_TAIL="${SNAKE_COLOR}T${NO_COLOR}"
SNAKE_HEAD="${SNAKE_COLOR}H${NO_COLOR}"

snake.initialize() {
	timer_start "snake.initialize"
	trace "Initializing snake"

	array.add snakeHead "5,5" "$SNAKE_HEAD"
	array.add snakeTail "5,6" "$SNAKE_TAIL"
	array.add snakeTail "5,7" "$SNAKE_TAIL"

	timer_stop "snake.initialize"
}

snake.move() {
	timer_start "snake.move"
	local x y i key
	local keyList

	trace "Moving snake"

	snake.trace "Initial"

	changedCells+=($(array.keys snakeHead))
	changedCells+=($(array.keys snakeTail))

	# 1. Move head to the selected direction
	for key in $(array.keys snakeHead); do
		x=$(echo $key | cut -d',' -f1)
		y=$(echo $key | cut -d',' -f2)
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
		food.create
	else
		# 2. Move
		trace2 "Removing snakeTail last element"
		removedKey=$(array.remove.last snakeTail 1)
		array.remove.last snakeTail
		trace2 "Element to be removed: $removedKey"

		array.add "board" "$removedKey" "$BLANK"
		changedCells+=("$removedKey")
	fi

	snake.trace "Final"

	timer_stop "snake.move"
}

snake.hasEaten() {
	for keys in $(arrays.keys snakeHead); do
		if [[ $(array.get "board" $key) == "$FOOD" ]]; then
			return 0;
		fi
	done

	return 1;
}

snake.trace() {
	local stage=$1

	trace2 "\n\nSNAKE HEAD ($stage): \n\n $(array.print.sorted snakeHead)" 
	trace2 "\n\nSNAKE TAIL ($stage): \n\n $(array.print.sorted snakeTail)"
}

# EOF
