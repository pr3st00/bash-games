#!/bin/bash

#
# A snake game written in bash.
#
# Author: Fernando Costa de Almeida
#

. ./subs/array.sh
. ./subs/board.sh
. ./subs/screen.sh
. ./subs/logging.sh

. ./subs/tetris/score.sh
. ./subs/tetris/piece.sh
. ./subs/tetris/game.sh


main() {
	screen.cursor.hide
	game.loop &
	game.read.input $!
	game.over
	screen.cursor.restore
}

main "$@"

exit 0

# EOF
