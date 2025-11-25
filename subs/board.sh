# Board parameters
COLS=50
ROWS=30

BORDER_COLOR="\e[30;43m"
NO_COLOR="\e[0m"

BLANK="B"
BORDERX="${BORDER_COLOR} ${NO_COLOR}"
BORDERY="${BORDER_COLOR} ${NO_COLOR}"

# Holds cells for which the value changed, so the screen refresher can update them
declare -a changedCells

# --------------------------------
# x,y	x,y	x,y	x,y
# 1,1	2,1	3,1	4,1
# 1,2	2,2	3,2	4,2
# 1,3	2,3	3,3	4,3
# --------------------------------

board.initialize() {
	timer_start "board.initialize"

	local x y
	
	trace "Initializing board"
	changedCells=()

	(
	for ((x=2;x<COLS;x++))
	do
		for ((y=2;y<ROWS;y++))
		do
			trace2 "Setting value $BLANK at position $x $y"
			array.add "board" "$x,$y" "$BLANK"
		done
	done ) &
	
	for ((x=1;x<=COLS;x++))
	do
		trace2 "Setting value $BORDERX at positions $x,1 and $x,$ROWS"
		array.add "board" "$x,1"   	"$BORDERX"
		array.add "board" "$x,$ROWS" 	"$BORDERX"
		changedCells+=("$x,1")
		changedCells+=("$x,$ROWS")
	done

	for ((y=1;y<=ROWS;y++))
	do
		trace2 "Setting value $BORDERY at position 1,$y and $COLS,$y"
		array.add "board" "1,$y" 	"$BORDERY"
		array.add "board" "$COLS,$y" 	"$BORDERY"
		changedCells+=("1,$y")
		changedCells+=("$COLS,$y")
	done

	wait
	
	trace "Board initialized"
	timer_stop "board.initialize"
}

board.draw() {
	timer_start "board.draw"

	trace "Drawing board"
	
	screen.refresh

	timer_stop "board.draw"
}

board.debug() {
	local x y value

	for ((y=1;y<=ROWS;y++))
	do
		for ((x=1;x<=COLS;x++))
		do
			value=$(array.get "board" "$x,$y")
			printf "%s" "$x,$y -> $value, "
		done
		echo 
	done
}

# EOF
