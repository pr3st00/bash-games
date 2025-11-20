# Screen parameters
TEXT_COLOR="\e[31;43m"
NO_COLOR="\e[0m"

score.refresh() {
	trace "Refreshing score"
        trace2 "Current score is $SCORE"

	screen.echoAt "${TEXT_COLOR} SCORE: $SCORE ${NO_COLOR}" $((DELTA_X + 1)) $((DELTA_Y - 1)) 

	trace "Refresh completed"
}

score.add() {
	local points=$1
	
	SCORE=$((SCORE+points))
}

# EOF
