#!/bin/bash

. ../subs/array.sh
. ../subs/board.sh
. ../subs/snake.sh
. ../subs/food.sh
. ../subs/game.sh
. ../subs/screen.sh

. ../subs/logging.sh

declare -A myArray
declare -A destArray

pause() {
	echo
	echo "(press enter)" && read
	echo
}

clear

array.add "myArray" "8,8" "should not exit"
array.add "myArray" "8,8" "firstValue at 8 8"
array.add "myArray" "1,4" "secondValue at 1 4"
array.add "myArray" "1,2" "thirdValue at 1 2"

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

echo "Retrieving element with key [8,8]"
echo
curValue=$(array.get "myArray" "8,8")
echo "Value for key [8,8] is [$curValue]"
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

echo "Checking if key exists on array"
echo
array.print myArray
echo
echo
for key in "8,8" "nonExistingKey"
do
	if array.key.exists myArray $key; then
		echo "Key $key exists"
	else
		echo "Key $key does not exist"
	fi
done
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

echo "Removing oldest element from array"
echo
array.remove.first myArray
array.print myArray
echo
pause
clear

# EOF
