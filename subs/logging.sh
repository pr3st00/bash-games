# Logging parameters
DEBUG=0
TRACE=0
TIMING=0
TIMER=0

CLEAR_LINE="\e[2K"

trace.enabled() {
	[[ $TRACE -eq 1 ]]
}

timer_start() {
	if [[ $TIMING -eq 0 ]]; then
		return
	fi
	
	TIMER=$(/usr/bin/date +%s)
}

timer_stop() {
	if [[ $TIMING -eq 0 ]]; then
		return
	fi

	local name=$1
	local stop=$(/usr/bin/date +%s)
	local elapsed=$((stop-TIMER))
	
	echo "$name,$TIMER,$stop,$elapsed" >> /dev/stderr
}

debug() {
	test $DEBUG -eq 1 && screen.echoAt "${CLEAR_LINE}[DEBUG] $@" 		1 $((ROWS+4)) 
}

trace() {
	test $TRACE -eq 1 && screen.echoAt "${CLEAR_LINE}--> $@" 	1 $((ROWS+5))
}

trace2() {
	test $TRACE -eq 1 && screen.echoAt "${CLEAR_LINE}----> $@" 	1 $((ROWS+6))
}

# EOF
