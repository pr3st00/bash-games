DEBUG=0
TRACE=0
TIMING=0
TIMER=0

TEXT_COLOR="\e[31;43m"
NO_COLOR="\e[0m"

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

restore_cursor() {
	echo -e "\033[?25h"
	stty echo
	clear
}

hide_cursor() {
	clear
	stty -echo
	echo -e "\033[?25l"
}

# EOF
