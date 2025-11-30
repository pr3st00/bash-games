NO_COLOR="\e[0m"

PIECE_COLOR="\e[32;42m"
PIECE="${PIECE_COLOR}P${NO_COLOR}"

DEAD_PIECE_COLOR="\e[32;44m"
DEAD_PIECE="${DEAD_PIECE_COLOR} ${NO_COLOR}"

PIECE_STATUS="IDLE"

NO_COLISION_DETECTED=0
COLISION_DETECTED_X=1
COLISION_DETECTED_Y=2

piece.initialize() {
	timer_start "piece.initialize"
	trace "Initializing piece"

	local key

	local pieceNumber=$(( (RANDOM % 6) + 1 ))
	local pieceNumber=1
	CUR_PIECE="$pieceNumber,1"

	for key in ${PIECES["$CUR_PIECE"]}; do
		if [[ $(array.get "board" "$key") != "$DEAD_PIECE" ]]; then
			array.add "piece" "$key" "$PIECE"
		fi
	done

	piece.add.to.changed "piece"

	piece.trace "Initial piece"
	timer_stop "piece.initialize"
}

piece.rotate() {
	[[ $ROTATE != "L" && $ROTATE != "R" ]] && return 1

	timer_start "piece.rotate"

	trace "Rotating piece to [$ROTATE]"

	piece.trace "Before rotate"

	local curPieceX=${CUR_PIECE%%,*}
        local curPieceY=${CUR_PIECE#*,}
	local nextPiece="$curPieceX,$curPieceY"
	local keys

	case "$ROTATE" in
                        [L])	((curPieceY++))
				;;
                        [R])	((curPieceY--))
				;;
	esac

	if [[ $curPieceY -gt 5 ]]; then
		curPieceY=2
	elif [[ $curPieceY -lt 2 ]]; then
		curPieceY=5
	fi

	nextPiece="$curPieceX,$curPieceY"

	CUR_PIECE=$nextPiece

	local curKeys=$(array.keys "piece")
	declare -a keyOps

	for key in ${PIECES["$nextPiece"]}; do
		keyOps+=("$key")
	done

	piece.add.to.changed "piece"
	piece.remove.from.board "piece"

	piece.kill "piece"

	trace2 "NEXTPIECE = [$nextPiece], KeyOps = [${keyOps[*]}]"

	local i=0

	for key in $curKeys; do
		local x=${key%%,*}
        	local y=${key#*,}

		local ops=${keyOps[$i]}
		local opx=${ops%%,*}
        	local opy=${ops#*,}

		local newx=$((x+opx))
		local newy=$((y+opy))

		trace2 "x,y = [$x,$y], opx,opy = [$opx,$opy], newx,newy [$newx,$newy]"

		array.add 	"piece" "$newx,$newy"	"$PIECE"

		((i++))
	done

	piece.add.to.changed "piece"

	piece.trace "After rotate"
	timer_stop "piece.rotate"

	unset ROTATE

	return 0
}

piece.is.moving() {
	PIECE_STATUS="MOVING"
}

piece.stop.moving() {
	PIECE_STATUS="IDLE"
}

piece.still.moving() {
	[[ $PIECE_STATUS == "MOVING" ]]
}

piece.move() {
	timer_start "piece.move"

	trace "Moving piece"

	piece.trace "Before move"
	piece.change.direction
	piece.trace "After move"

	timer_stop "piece.move"
}

piece.remove.from.board() {
	local name=$1

        local keys=$(array.keys "$name")
	local key

        for key in $keys; do
                local x=${key%%,*}
                local y=${key#*,}
                array.remove    "$name" "$key"
                array.add       "board" "$x,$y" "$BLANK"
                changedCells+=("$x,$y")
        done
}

piece.change.direction() {
        local keys=$(array.keys "piece")
	local key

	trace "Performing direction change logic ($DIRECTION)"

	[[ -z $DIRECTION ]] && return 1

	piece.is.moving

	piece.colision.detection "piece"
	local result=$?

	if [[ $result == "$COLISION_DETECTED_X" || $result == "$COLISION_DETECTED_Y" ]]; then
		unset DIRECTION
		piece.stop.moving
		return 1
	fi

	piece.remove.from.board "piece"

        for key in $keys; do
                local x=${key%%,*}
                local y=${key#*,}

		case "$DIRECTION" in
			R) ((x++));;
			L) ((x--));;
			U) sleep .3;;
			D) ((y++));;
			*) ;;
		esac

                array.add "piece" "$x,$y" "$PIECE"
        done

	piece.add.to.changed "piece"

	piece.stop.moving

	unset DIRECTION

        return 0
}

piece.gravity() {
	local keys=$(array.keys "piece")
	local key

	trace "Performing gravity logic"

	piece.trace "Before gravity"

	piece.colision.detection "piece"

	if [[ $? == "$COLISION_DETECTED_Y" ]]; then
		piece.kill "piece"
		piece.initialize
		return 1;
	fi

	piece.remove.from.board "piece"

	for key in $keys; do
		local x=${key%%,*}
		local y=${key#*,}
		((y++))
		array.add "piece" "$x,$y" "$PIECE"
	done

	piece.add.to.changed "piece"

	piece.trace "After gravity"

	return 0
}

piece.colision.detection() {
	local name=$1
	local result=$NO_COLISION_DETECTED

	local keys=$(array.keys "$name")
	local key

        for key in $keys; do
                local x=${key%%,*}
                local y=${key#*,}

		case "$DIRECTION" in
			R) ((x++));;
			L) ((x--));;
			U) sleep .3;;
			D) ((y++));;
			*) ((y++));;
		esac

		if [[ $x -le 1 || $x -ge $((COLS)) ]]; then
                        trace2 "X Colision detected for value [$curValue] at [$x,$y]"
                        result=$COLISION_DETECTED_X;
			break;
                fi

                local curValue=$(array.get "board" "$x,$y")

		if [[ $curValue == "$DEAD_PIECE" || $y -ge $((ROWS)) ]]; then
                        trace2 "Y Colision detected for value [$curValue] at [$x,$y]"
                        result=$COLISION_DETECTED_Y;
			break;
                fi
        done

	return $result
}

piece.add.board() {
        array.copy "piece" "board"
	piece.add.to.changed "piece"
}

piece.add.to.changed() {
	local name=$1
	local key

	for key in $(array.keys "$name"); do
		changedCells+=("$key")
	done
}

piece.trace() {
        local stage=$1

        if trace.enabled; then
                trace2 "\n\nPIECE ($stage): \n\n $(array.print.sorted piece)"
		return 0
	else
		return 1
        fi
}

piece.kill() {
	local name=$1

	local keys=$(array.keys "$name")
	local key

	piece.add.to.changed 	"$name"
	piece.remove.from.board "$name"
	array.kill "$name"

	for key in $keys; do
		array.add 	"board" "$key" "$DEAD_PIECE"
	done
}

# EOF
