#!/bin/bash

. ./subs/array.sh
. ./subs/board.sh
. ./subs/snake.sh
. ./subs/food.sh
. ./subs/game.sh
. ./subs/screen.sh

. ./subs/functions.sh

main() {
	local PID

	hide_cursor
	game_loop &
	PID=$!
	read_input $PID
	restore_cursor
}

main "$@"

# EOF
