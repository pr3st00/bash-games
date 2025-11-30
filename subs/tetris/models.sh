declare -A PIECES

#
# All tetris pieces and their hardcoded rotations to LEFT
# 
# x,1 = initial coordinates of the piece
# x,2 = operations to be performed on the piece for a left rotation
# x,3 = next operations for a left rotation
# x,4 = final left rotation
#
PIECES[1,1]="3,2 3,3 3,4 4,4 5,4"
PIECES[1,2]="0,2 1,1 2,0 1,-1 0,-2"
PIECES[1,3]="2,0 1,-1 0,-2 -1,-1 -2,0"
PIECES[1,4]="0,-2 -1,-1 -2,0 -1,1 0,2"
PIECES[1,5]="-2,0 -1,1 0,2 1,1 2,0"

PIECES[2,1]="3,2 3,3 4,2 4,3"
PIECES[2,2]="1,1 0,0 0,0 0,0"
PIECES[2,3]="1,1 0,0 0,0 0,0"
PIECES[2,4]="1,1 0,0 0,0 0,0"
PIECES[2,5]="1,1 0,0 0,0 0,0"

PIECES[3,1]="3,2 3,3 3,4 3,5 3,6"
PIECES[3,2]="1,1 0,0 0,0 0,0 0,0"
PIECES[3,3]="1,1 0,0 0,0 0,0 0,0"
PIECES[3,4]="1,1 0,0 0,0 0,0 0,0"
PIECES[3,5]="1,1 0,0 0,0 0,0 0,0"

PIECES[4,1]="3,2 3,3 4,3"
PIECES[4,2]="1,1 0,0 0,0"
PIECES[4,3]="1,1 0,0 0,0"
PIECES[4,4]="1,1 0,0 0,0"
PIECES[4,5]="1,1 0,0 0,0"

PIECES[5,1]="3,2 4,2 5,2 4,3"
PIECES[5,2]="1,1 0,0 0,0 0,0"
PIECES[5,3]="1,1 0,0 0,0 0,0"
PIECES[5,4]="1,1 0,0 0,0 0,0"
PIECES[5,5]="1,1 0,0 0,0 0,0"

PIECES[6,1]="3,2 4,2 5,2 4,3 4,4"
PIECES[6,2]="1,1 0,0 0,0 0,0 0,0"
PIECES[6,3]="1,1 0,0 0,0 0,0 0,0"
PIECES[6,4]="1,1 0,0 0,0 0,0 0,0"
PIECES[6,5]="1,1 0,0 0,0 0,0 0,0"

# EOF
