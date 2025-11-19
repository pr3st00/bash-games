#!/bin/bash -x

. ../subs/array.sh
. ../subs/board.sh
. ../subs/snake.sh
. ../subs/food.sh
. ../subs/game.sh
. ../subs/screen.sh

. ../subs/logging.sh

TRACE=1

pause() {
	echo
	trace2 "(press enter)" && read
	echo
}

array.add "myArray" "8,8" "firstValue at 8 8"
array.add "myArray" "1,4" "secondValue at 1 4"
array.add "myArray" "1,2" "thirdValue at 1 2"

clear
echo "Testing echoAt '|' at position 10 4"
screen.echoAt "|" 10 4
pause
clear

clear
echo "Testing board initialization"
pause
board.initialize
array.print.sorted board
pause
clear

echo "Testing board drawing"
pause
clear
board.draw
pause
clear

# EOF
