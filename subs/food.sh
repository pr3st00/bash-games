FOOD_COLOR="\e[34;44m"
NO_COLOR="\e[0m"

FOOD="${FOOD_COLOR}F${NO_COLOR}"

food.create() {
	timer_start "food.create"
	local x y

	x=$(( (RANDOM % ($COLS - 2)) + 2 ))
	y=$(( (RANDOM % ($ROWS - 2)) + 2 ))

	trace "Adding food at [$x,$y]"

	array.add board "$x,$y" "$FOOD"
	changedCells+=("$x,$y")

	timer_stop "food.create"
}

food.eat() {
	timer_start "food.eat"

	local x y

	x=$1
	y=$2

	trace "Eating food"

	changedCells+=("$x,$y")

	timer_stop "food.eat"
}

# EOF
