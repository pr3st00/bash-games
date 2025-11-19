#!/bin/bash

. ./subs/array.sh
. ./subs/board.sh
. ./subs/snake.sh
. ./subs/food.sh
. ./subs/game.sh
. ./subs/screen.sh

. ./subs/logging.sh

main() {
	local PID

	screen.hide_cursor
	game_loop &
	PID=$!
	read_input $PID
	game_over
	screen.restore_cursor
}

main "$@"

exit 0

# EOF
