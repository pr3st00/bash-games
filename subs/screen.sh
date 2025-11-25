# Screen parameters
TEXT_COLOR="\e[31;43m"
NO_COLOR="\e[0m"

DELTA_X=2
DELTA_Y=2

# Number of process spawn for updating the screen
WORKERS=10

screen.refresh() {
	trace "Refreshing screen with $WORKERS workers"

	local i key value chunk
        local chunk_size=$(( (${#changedCells[@]} + WORKERS - 1) / WORKERS ))

        for ((i=0; i<${#changedCells[@]}; i+=chunk_size)); do
                chunk=("${changedCells[@]:i:chunk_size}")
                (
                for key in "${chunk[@]}"
                do
                        value=$(array.get "board" "$key")
                        [[ $value == "$BLANK" ]] && value=" ";

			x=$((${key%%,*} + DELTA_X))
			y=$((${key#*,}  + DELTA_Y))

                        debug "Drawing character [$value] at position $x $y - changedCell = $key"
                        screen.echoAt "$value" $x $y
                done ) &
        done

	wait
	
	trace "Refresh completed"
}

screen.cursor.restore() {
        printf "\033[?25h"
        stty echo
        clear
}

screen.cursor.hide() {
        clear
        stty -echo
        printf "\033[?25l"
}

screen.echoAt() {
        timer_start "echoAt"
        local mesg x y

        mesg=$1
        x=$2
        y=$3

        printf "\033[${y};${x}H$mesg"
        timer_stop "echoAt"
}

screen.bip() {
	printf '\a';
}

# EOF
