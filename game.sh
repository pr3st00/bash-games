#!/bin/bash

. ./subs/array.sh
. ./subs/board.sh
. ./subs/snake.sh
. ./subs/game.sh

. ./subs/functions.sh

main() {
	clear
	hide_cursor
	handle_signals
	game_loop
	PID=$!
	read_input $PID
	wait
	restore_cursor
}

main "$@"

# EOF
