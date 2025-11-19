DEBUG=0
TRACE=1
TIMING=0
TIMER=0

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
	test $DEBUG -eq 1 && screen.echoAt "$@							" 1 $((ROWS+5)) 
}

trace() {
	test $TRACE -eq 1 && screen.echoAt "--> $@						" 1 $((ROWS+3))
}

trace2() {
	test $TRACE -eq 1 && screen.echoAt "----> $@						" 1 $((ROWS+4))
}

# EOF
