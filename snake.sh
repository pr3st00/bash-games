#!/bin/bash

#
# A snake game written in bash.
#
# Author: Fernando Costa de Almeida
#

. ./subs/array.sh
. ./subs/board.sh
. ./subs/snake.sh
. ./subs/food.sh
. ./subs/game.sh
. ./subs/screen.sh

. ./subs/logging.sh

main() {
	screen.hide_cursor
	game_loop &
	read_input $!
	game_over
	screen.restore_cursor
}

main "$@"

exit 0

# EOF
