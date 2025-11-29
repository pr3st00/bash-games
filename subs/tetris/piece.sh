PIECE_COLOR="\e[32;42m"
PIECE="${PIECE_COLOR}P${NO_COLOR}"

DEAD_PIECE_COLOR="\e[32;44m"
DEAD_PIECE="${DEAD_PIECE_COLOR} ${NO_COLOR}"

PIECE_STATUS="IDLE"

NO_COLOR="\e[0m"

NO_COLISION_DETECTED=0
COLISION_DETECTED_X=1
COLISION_DETECTED_Y=2

# All tetris pieces and their hardcoded rotations to LEFT
PIECE[1,1]="3,2 3,3 3,4 4,4 5,4"
PIECE[1,2]="-2,-2 -1,-1 0,0 -1,-1 -2,-2"
PIECE[1,3]="3,2 3,3 3,4 4,4 5,4"
PIECE[1,4]="3,2 3,3 3,4 4,4 5,4"

PIECE[2,1]="3,2 3,3 4,2 4,3"
PIECE[2,2]="3,2 3,3 4,2 4,3"
PIECE[2,3]="3,2 3,3 4,2 4,3"
PIECE[2,4]="3,2 3,3 4,2 4,3"

PIECE[3,1]="3,2 3,3 3,4 3,5 3,6"
PIECE[3,2]="3,2 3,3 3,4 3,5 3,6"
PIECE[3,3]="3,2 3,3 3,4 3,5 3,6"
PIECE[3,4]="3,2 3,3 3,4 3,5 3,6"

PIECE[4,1]="3,2 3,3 4,3"
PIECE[4,2]="3,2 3,3 4,3"
PIECE[4,3]="3,2 3,3 4,3"
PIECE[4,4]="3,2 3,3 4,3"

PIECE[5,1]="3,2 4,2 5,2 4,3"
PIECE[5,2]="3,2 4,2 5,2 4,3"
PIECE[5,3]="3,2 4,2 5,2 4,3"
PIECE[5,4]="3,2 4,2 5,2 4,3"

PIECE[6,1]="3,2 4,2 5,2 4,3 4,4"
PIECE[6,2]="3,2 4,2 5,2 4,3 4,4"
PIECE[6,3]="3,2 4,2 5,2 4,3 4,4"
PIECE[6,4]="3,2 4,2 5,2 4,3 4,4"

piece.initialize() {
	timer_start "piece.initialize"
	trace "Initializing piece"

	local pieceNumber=$(( (RANDOM % 6) + 1 ))
	pieceNumber=1
	CUR_PIECE="$pieceNumber,1"

	for key in ${PIECE["$CUR_PIECE"]}; do
		if [[ $(array.get "board" "$key") != "$DEAD_PIECE" ]]; then
			array.add "piece" "$key" "$PIECE"
		fi
	done

	piece.add.to.changed "piece"

	timer_stop "piece.initialize"
}

piece.rotate() {
	[[ -z $ROTATE || $ROTATE == "N" ]] && return 1

	timer_start "piece.rotate"

	trace "Rotating piece to [$ROTATE]"

	piece.trace "Before rotate" && sleep 1

	local curPieceX=${CUR_PIECE%%,*}
        local curPieceY=${CUR_PIECE#*,}
	local nextPiece="$curPieceX,$curPieceY"

	if [[ $ROTATE == "L" ]]; then
		((curPieceY++))
		if [[ $curPieceY -gt 4 ]]; then
			curPieceY=1
		fi
		nextPiece="$curPieceX,$curPieceY"
	fi

	CUR_PIECE=$nextPiece

	local curKeys=$(array.keys "piece")
	local keyOps=${PIECE[$nextPiece]}

	piece.add.to.changed "piece"
	piece.remove.from.board "piece"

	local i=0

	for key in $curKeys; do
		((i++))
		x=${key%%,*}
        	y=${key#*,}

		ops=${keyOps[$i]}
		opx=${ops%%,*}
        	opy=${ops#*,}

		x=$((x+opx))
		y=$((y+opy))

		array.add "piece" "$x,$y" "$PIECE"
	done

	piece.add.to.changed "piece"

	piece.trace "After rotate" && sleep 1

	unset ROTATE

	timer_stop "piece.rotate"

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

        for key in $keys; do
                x=${key%%,*}
                y=${key#*,}
                array.remove    "$name" "$key"
                array.add       "board" "$x,$y" "$BLANK"
                changedCells+=("$x,$y")
        done
}

piece.change.direction() {
        local keys=$(array.keys "piece")

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
                x=${key%%,*}
                y=${key#*,}

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
		x=${key%%,*}
		y=${key#*,}
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

        for key in $keys; do
                x=${key%%,*}
                y=${key#*,}

		case "$DIRECTION" in
			R) ((x++));;
			L) ((x--));;
			U) sleep .3;;
			D) ((y++));;
			*) ((y++));;
		esac

		if [[ $x -le 1 || $x -ge $((COLS)) ]]; then
                        trace2 "X Colision detected for value [$curValue] at [$x,$y]" && sleep 1
                        result=$COLISION_DETECTED_X;
			break;
                fi

                curValue=$(array.get "board" "$x,$y")

		if [[ $curValue == "$DEAD_PIECE" || $y -ge $((ROWS)) ]]; then
                        trace2 "Y Colision detected for value [$curValue] at [$x,$y]" && sleep 1
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

	for key in $(array.keys "$name"); do
		changedCells+=("$key")
	done
}

piece.trace() {
        local stage=$1

        if trace.enabled; then
                trace2 "\n\nPIECE ($stage): \n\n $(array.print.sorted piece)"
        fi
}

piece.kill() {
	local name=$1

	local keys=$(array.keys "$name")

	piece.add.to.changed 	"$name"
	piece.remove.from.board "$name"
	array.kill "$name"

	for key in $keys; do
		array.add 	"board" "$key" "$DEAD_PIECE"
	done
}

# EOF
