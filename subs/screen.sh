# Screen parameters
TEXT_COLOR="\e[31;43m"
NO_COLOR="\e[0m"

DELTA_X=5
DELTA_Y=3

# Number of process spawn for updating the screen
WORKERS=10

screen.refresh() {
	trace "Refreshing screen with $WORKERS workers"

        local CHUNK_SIZE=$(( (${#changedCells[@]} + WORKERS - 1) / WORKERS ))

        for ((i=0; i<${#changedCells[@]}; i+=CHUNK_SIZE)); do
                chunk=("${changedCells[@]:i:CHUNK_SIZE}")
                (
                for key in "${chunk[@]}"
                do
                        value=$(array.get "board" "$key")
                        [[ $value == "$BLANK" ]] && value=" ";

			x=$(($(echo $key | cut -d',' -f1)+DELTA_X))
			y=$(($(echo $key | cut -d',' -f2)+DELTA_Y))
                        debug "Drawing character [$value] at position $x $y - changedCell = $key"
                        screen.echoAt "$value" $x $y
                done ) &
        done
	
	trace "Refresh completed"
}

screen.restore_cursor() {
        echo -e "\033[?25h"
        stty echo
        clear
}

screen.hide_cursor() {
        clear
        stty -echo
        echo -e "\033[?25l"
}

screen.echoAt() {
        timer_start "echoAt"
        local mesg x y

        mesg=$1
        x=$2
        y=$3

        echo -e "\033[${y};${x}H$mesg"
        timer_stop "echoAt"
}

# EOF
