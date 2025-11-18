MAXROWS=5

array.keys() {
  local array=$1
  local -n order=${array}_ORDER

  printf "%s\n" ${order[@]}
}

array.keys.sorted() {
  local array=$1
  local -n order=${array}_ORDER

  printf "%s\n" ${order[@]} | sort -n
}

array.add() {
	local array
	local key value

	array=$1
	key=$2
	value=$3

	declare -gA "${array}_MAP"
	declare -ga "${array}_ORDER"

	local -n map=${array}_MAP
	local -n order=${array}_ORDER
	
	if [[ ! " ${order[*]} " =~ " $key " ]]; then
		order+=("$key")
	fi

	map[$key]="$value";
}

array.remove() {
	local array 
	local key returnValue
	
	array=$1
	key=$2
	returnValue=$3

	local -n map=${array}_MAP
	local -n order=${array}_ORDER
	

	local new_array=()
	for thisKey in "${order[@]}"; do
		[[ "$thisKey" != "$key" ]] && new_array+=("$thisKey")
	done
	order=("${new_array[@]}")

	unset map[$key];

	if [[ $returnValue == "1" ]]; then
		echo "$key"
	fi
}

array.get() {
	local array key
	
	array=$1
	key=$2

	local -n map=${array}_MAP

	echo ${map["$key"]};
}

array.remove.last() {
	local array
	local keyList key

	array=$1
	returnValue=$2

	local -n map=${array}_MAP
	local -n order=${array}_ORDER

        lastElement=${order[0]};

        array.remove $array $lastElement $returnValue
}

array.print() {
	local array=$1
	local n=0

	for key in $(array.keys $array); do
		((n++))
		value=$(array.get "$array" "$key")
        	echo -n "$key => $value 	"
		if [[ $n -gt $MAXROWS ]]; then
			echo
			n=0
		fi
	done
}

array.print.sorted() {
	local array=$1
	local n=0

	for key in $(array.keys.sorted $array); do
		((n++))
		value=$(array.get "$array" "$key")
        	echo -n "$key => $value 	"
		if [[ $n -gt $MAXROWS ]]; then
			echo
			n=0
		fi
	done
}

array.copy() {
	local source=$1
	local dest=$2
	local key

	local -n map=${source}_MAP
	local -n order=${source}_ORDER

	for key in $(array.keys $source); do
		array.add "$dest" "$key" "${map[$key]}"
	done
}

array.rowContains() {
	local array 
	local row value key

	array=$1
	row=$2
	value=$3

	local -n map=${array}_MAP
	local -n order=${array}_ORDER

	for key in $(array.keys $array); do
		if [[ $key == *"${row},"* && ${map[$key]} == *"$value"* ]]; then
			return 0;
		fi
	done

	return 1;
}

# EOF
