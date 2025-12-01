declare -A PIECES
declare -A ROTATIONS

#
# PIECES 	: All tetris pieces coordinates
# ROTATIONS 	: All four left rotations. The key is [pieceNumber,rotationNumber] and the values are operations to be performed on the coordinates
#

# PIECE 1
PIECES[1]="3,2 3,3 3,4 4,4 5,4"
ROTATIONS[1,1]="0,2 1,1 2,0 1,-1 0,-2"
ROTATIONS[1,2]="2,0 1,-1 0,-2 -1,-1 -2,0"
ROTATIONS[1,3]="0,-2 -1,-1 -2,0 -1,1 0,2"
ROTATIONS[1,4]="-2,0 -1,1 0,2 1,1 2,0"


# PIECE 2
PIECES[2]="3,2 3,3 4,2 4,3"
ROTATIONS[2,1]="0,2 1,1 -1,1 0,0"
ROTATIONS[2,2]="2,0 1,-1 1,1 0,0"
ROTATIONS[2,3]="0,-2 -1,-1 1,-1 0,0"
ROTATIONS[2,4]="-2,0 -1,1 -1,-1 0,0"

# PIECE 3
PIECES[3]="3,2 3,3 3,4 3,5 3,6"
ROTATIONS[3,1]="0,2 1,1 2,0 3,-1 4,-2"
ROTATIONS[3,2]="2,0 1,-1 0,-2 -1,-3 -2,-4"
ROTATIONS[3,3]="0,-2 -1,-1 -2,0 -3,1 -4,2"
ROTATIONS[3,4]="-2,0 -1,1 0,2 1,3 2,4"

# PIECE 4
PIECES[4]="3,2 3,3 4,3"
ROTATIONS[4,1]="0,2 1,1 0,0"
ROTATIONS[4,2]="2,0 1,-1 0,0"
ROTATIONS[4,3]="0,-2 -1,-1 0,0"
ROTATIONS[4,4]="-2,0 -1,1 0,0"

# PIECE 5
PIECES[5]="3,2 4,2 5,2 4,3"
ROTATIONS[5,1]="0,2 -1,1 -2,0 0,0"
ROTATIONS[5,2]="2,0 1,1 0,2 0,0"
ROTATIONS[5,3]="0,-2 1,-1 2,0 0,0"
ROTATIONS[5,4]="-2,0 -1,-1 0,-2 0,0"

# PIECE 6
PIECES[6]="3,2 4,2 5,2 4,3 4,4"
ROTATIONS[6,1]="0,2 -1,1 -2,0 0,0 1,-1"
ROTATIONS[6,2]="2,0 1,1 0,2 0,0 -1,-1"
ROTATIONS[6,3]="0,-2 1,-1 2,0 0,0 -1,1"
ROTATIONS[6,4]="-2,0 -1,-1 0,-2 0,0 1,1"

# EOF
