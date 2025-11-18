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
	test $DEBUG -eq 1 && echoAt "$@                                           " 1 $((ROWS+5)) 
}

trace() {
	test $TRACE -eq 1 && echoAt "--> $@                                         " 1 $((ROWS+3))
}

trace2() {
	test $TRACE -eq 1 && echoAt "----> $@                                       " 1 $((ROWS+4))
}

echoAt() {
	timer_start "echoAt"
	local mesg x y
	mesg=$1
	x=$2
	y=$3
	echo -e "\033[${y};${x}H$mesg"
	timer_stop "echoAt"
}

function trap_signal() {
	debug "Signal received, reading $FIFO_FILE "
	character=$(cat $FIFO_FILE)
}

restore_cursor() {
	echo -e "\033[?25h"
	clear
}

hide_cursor() {
	echo -e "\033[?25l"
}

handle_signals() {
	trap trap_signal SIGUSR1
	trap restore_cursor SIGTERM
}

# EOF
