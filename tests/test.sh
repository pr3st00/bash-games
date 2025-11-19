#!/bin/bash -x

. ../subs/array.sh
. ../subs/board.sh
. ../subs/snake.sh
. ../subs/food.sh
. ../subs/game.sh
. ../subs/screen.sh

. ../subs/logging.sh

pause() {
	echo
	echo "(press enter)" && read
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

echo "Printing original array (sorted)"
echo
array.print.sorted myArray
echo
pause
clear

echo "Printing original array keys"
echo
array.keys "myArray"
echo
pause
clear

echo "Printing original array (original order)"
echo
array.print myArray
echo
pause
clear

array.copy myArray destArray

echo "Printing copied array"
echo
array.print destArray
echo
pause
clear

echo "Removing first element from array"
echo
array.remove myArray "8,8"
array.print myArray
echo
pause
clear

echo "Removing last element from array"
echo
array.remove.last myArray
array.print myArray
echo
pause
clear

clear
echo "Testing array.rowContains"

for value in nonExistent secondValue
	do
		echo
		echo "VALUE: $value"
		if array.rowContains myArray 1 "$value"; then
		echo "Array contains $value"
	else
		echo "Array DOES NOT contain $value"
	fi
done
pause
clear

# EOF
