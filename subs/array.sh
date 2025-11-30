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

array.key.exists() {
	local array=$1
	local key=$2

	declare -gA "${array}_MAP"
	local -n map=${array}_MAP

	[[ -v map["$key"] ]]
}

array.kill() {
	local array=$1

	declare -gA "${array}_MAP"
	declare -ga "${array}_ORDER"

	local -n map=${array}_MAP
	local -n order=${array}_ORDER

	unset map
	unset order
}

array.add() {
	local array=$1
	local key=$2
	local value=$3

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
	local array=$1
	local key=$2
	local returnValue=$3
	
	local -n map=${array}_MAP
	local -n order=${array}_ORDER

	local new_array=()

	for thisKey in "${order[@]}"; do
		[[ "$thisKey" != "$key" ]] && new_array+=("$thisKey")
	done

	order=("${new_array[@]}")

	unset map[$key];

	if [[ $returnValue == "1" ]]; then
		printf "%s\n" "$key"
	fi
}

array.remove.by.number() {
	local array=$1
	local index=$2
	local returnValue=$3

	local element

	local -n map=${array}_MAP
	local -n order=${array}_ORDER

	(( index < 0 || index >= ${#order[@]} )) && return 1

        element=${order[$index]};

        array.remove $array $element $returnValue
}

array.remove.first() {
	local array=$1
	local returnValue=$2

        array.remove.by.number $array 0 $returnValue
}

array.get() {
	local array=$1 
	local key=$2
	
	local -n map=${array}_MAP

	printf "%s\n" "${map["$key"]}";
}

array.print() {
	local array=$1
	local n=0

	for key in $(array.keys $array); do
		((n++))
		value=$(array.get "$array" "$key")
        	printf "%s" "[$key] => [$value]  "
		if [[ $n -gt $MAXROWS ]]; then
			printf "\n"
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
        	printf "%s" "[$key] => [$value]  "
		if [[ $n -gt $MAXROWS ]]; then
			printf "\n"
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

# EOF
