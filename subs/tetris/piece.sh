PIECE_COLOR="\e[32;42m"
NO_COLOR="\e[0m"

DEAD_PIECE="D"
PIECE="${PIECE_COLOR}P${NO_COLOR}"

PIECE_STATUS="IDLE"

piece.initialize() {
	timer_start "piece.initialize"
	trace "Initializing piece"

	for key in 3,2 3,3 3,4 4,4 5,4; do
		array.add "piece" "$key" "$PIECE"
	done

	piece.add.to.changed "piece"

	timer_stop "piece.initialize"
}

piece.still.moving() {
	[[ $PIECE_STATUS == "MOVING" ]]
}

piece.move() {
	timer_start "piece.move"

	trace "Moving piece"

	piece.trace "Before gravity"
	piece.gravity
	piece.trace "After gravity"

	piece.trace "Before move"
	piece.change.direction
	piece.trace "After move"

	timer_stop "piece.move"
}

piece.remove.from.board() {
	local name=$1

        local keys=$(array.keys "$name")

        for key in $keys; do
                x=${key%%,*}
                y=${key#*,}
                array.remove    $name "$x,$y"
                array.add       board "$x,$y" "$BLANK"
                changedCells+=("$x,$y")
        done
}

piece.change.direction() {
        local keys=$(array.keys "piece")

        trace "Performing gravity logic"

	PIECE_STATUS="MOVING"

	piece.remove.from.board "piece"

        for key in $keys; do
                x=${key%%,*}
                y=${key#*,}

		case "$DIRECTION" in
			R) ((x++));;
			L) ((x--));;
			U) sleep .3;;
			D) ((y++));;
			*) ;;
		esac

                curValue=$(array.get board "$x,$y")
                
		if [[ $curValue == "$DEAD_PIECE" || $x -ge $((COLS -2)) || $x -le 2 ]]; then
                        trace2 "Colision detected for value [$curValue] at [$x,$y]" && sleep 3
			unset DIRECTION
                        return 1;
                fi

                array.add "piece" "$x,$y" "$PIECE"
        done

	piece.add.to.changed "piece"

	unset DIRECTION

	PIECE_STATUS="IDLE"

        return 0
}

piece.gravity() {
	local keys=$(array.keys "piece")

	trace "Performing gravity logic"

	for key in $keys; do
		x=${key%%,*}
		y=${key#*,}
		((y++))
		curValue=$(array.get board "$x,$y")
		if [[ $curValue == "$DEAD_PIECE" || $y -ge $ROWS ]]; then
			trace2 "Colision detected for value [$curValue] at [$x,$y]" && sleep 3
			return 1;
		fi
	done

	piece.remove.from.board "piece"

	for key in $keys; do
		x=${key%%,*}
		y=${key#*,}
		((y++))
		array.add	"piece" "$x,$y" "$PIECE"
	done

	piece.add.to.changed "piece"

	return 0
}

piece.colision.detection() {
	sleep 1
}

piece.add.board() {
        array.copy "piece" "board"
	piece.add.to.changed "piece"
}

piece.add.to.changed() {
	local name=$1

	for key in $(array.keys "$name"); do
		changedCells+=("$key")
	done
}

piece.trace() {
        local stage=$1

        if trace.enabled; then
                trace2 "\n\nPIECE ($stage): \n\n $(array.print.sorted piece)" && sleep 1
        fi
}

# EOF
