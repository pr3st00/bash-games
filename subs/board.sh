# Board parameters
BLANK="."
BORDERX="-"
BORDERY="|"
COLS=40
ROWS=20

declare -a changedCells

# --------------------------------
# x,y   x,y     x,y     x,y
# 1,1	2,1	3,1	4,1
# 1,2	2,2	3,2	4,2
# 1,3	2,3	3,3	4,3
# --------------------------------

board.initialize() {
	timer_start "board.initialize"

	local x y value
	
	trace "Initializing board"
		
	for ((x=1;x<=COLS;x++))
	do
		for ((y=1;y<=ROWS;y++))
		do
			debug "Setting value $BLANK at position $x $y"
			array.add "board" "$x,$y" "$BLANK"
		done
	done
	
	for ((x=1;x<=COLS;x++))
	do
		debug "Setting value $BORDERX at positions $x,1 and $x,$ROWS"
		array.add "board" "$x,1"   	"$BORDERX"
		array.add "board" "$x,$ROWS" 	"$BORDERX"
	done

	for ((y=1;y<=ROWS;y++))
	do
		debug "Setting value $BORDERY at position 1,$y and $COLS,$y"
		array.add "board" "1,$y" 	"$BORDERY"
		array.add "board" "$COLS,$y" 	"$BORDERY"
	done
	
	debug "Board initialized"
	timer_stop "board.initialize"
}

board.draw() {
	timer_start "board.draw"
	local rowValue

	trace "Drawing board"
	
	#board.initialize
	
	array.copy "snakeHead" "board"
	array.copy "snakeTail" "board"

	for ((y=1;y<=ROWS;y++))
	do
		unset rowValue
		for ((x=1;x<=COLS;x++))
		do
			value=$(array.get "board" "$x,$y")
			debug "Drawing character [$value] at position $x $y"
			rowValue+="$value"
		done

		echoAt "$rowValue" 1 $y
	done
	
	timer_stop "board.draw"
}

board.draw.optimized() {
	timer_start "board.draw.optimized"
	local rowValue

	trace "Drawing board optimized"
	
	#board.initialize
	
	array.copy "snakeHead" "board"
	array.copy "snakeTail" "board"
	
	for key in "${changedCells[@]}"
	do
		x=$(echo $key | cut -d',' -f1)
		y=$(echo $key | cut -d',' -f2)
		value=$(array.get "board" "$key")
		debug "Drawing character [$value] at position $x $y - changedCell = $key"
		echoAt "$value" $x $y
	done
	
	timer_stop "board.draw.optimized"
}

board.debug() {
	for ((y=1;y<=ROWS;y++))
	do
		for ((x=1;x<=COLS;x++))
		do
			value=$(array.get "board" "$x,$y")
			echo -n "$x,$y -> $value, "
		done
		echo 
	done
}

# EOF
