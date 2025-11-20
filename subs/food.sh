FOOD_COLOR="\e[34;44m"
NO_COLOR="\e[0m"

FOOD="${FOOD_COLOR}F${NO_COLOR}"

food.create() {
	timer_start "food.create"

	local count=$1
	local x y i

	count=$1

	for ((i=0;i<count;i++)); do
		x=$(( (RANDOM % ($COLS - 2)) + 2 ))
		y=$(( (RANDOM % ($ROWS - 2)) + 2 ))

		trace "Adding food at [$x,$y]"

		array.add board "$x,$y" "$FOOD"
		changedCells+=("$x,$y")
	done

	timer_stop "food.create"
}

food.eat() {
	timer_start "food.eat"

	local x y

	x=$1
	y=$2

	trace "Eating food"

	score.add 10
	changedCells+=("$x,$y")

	timer_stop "food.eat"
}

# EOF
