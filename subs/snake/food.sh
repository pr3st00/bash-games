FOOD_COLOR="\e[34;44m"
NO_COLOR="\e[0m"

FOOD="${FOOD_COLOR}F${NO_COLOR}"

food.create() {
	timer_start "food.create"

	local quantity=$1
	local i

	for ((i=0;i<quantity;i++)); do
		food.add
	done

	timer_stop "food.create"
}

food.add() {
	local x y

	x=$(( (RANDOM % (COLS - 2)) + 2 ))
	y=$(( (RANDOM % (ROWS - 2)) + 2 ))

	trace "Adding food at [$x,$y]"

	if [[ ! $(array.get "board" "$x,$y") == "$SNAKE_TAIL" ]]; then
		array.add board "$x,$y" "$FOOD"
		changedCells+=("$x,$y")

		return 0
	else
		return 1
	fi
}

food.eat() {
	timer_start "food.eat"

	local x=$1
	local y=$2

	trace "Eating food"

	score.add 10
	changedCells+=("$x,$y")

	screen.bip

	timer_stop "food.eat"
}

# EOF
