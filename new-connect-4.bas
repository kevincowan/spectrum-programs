40 REM *** Initialize variables, strings and screen ***
41 DIM a(42)           : REM array of pieces
42 LET gameStatus=0    : REM -1 = draw, 0 = keep playing, >1 = player has won
43 LET moves=0         : REM maximum of 42
44 LET currentPlayer=1 : REM 1 or 2
45 INK 7: PAPER 0: BORDER 5: CLS
46 FOR i=1 TO 42: LET a(i)=0: NEXT i
47 LET rowcount=6
48 LET colcount=7
49 LET userColumn=0
50 LET placedRow=0
51 LET coordinate=0
52 LET rowsize=24
53 LET colsize=24
54 LET startx=8
55 LET starty=20
60 LET DEBUG=1 : REM 0 for no debug grid, 1 for debug grid

100 REM *** Start screen ***
110 BORDER 5: PAPER 0: INK 7: CLS
120 PRINT AT 8,2; "CONNECT 4"
121 PRINT AT 10,2;"Two Player Game"
122 PRINT AT 11,2;"Pick a column (1-7)"
123 PRINT AT 14,2;"PRESS ANY KEY TO START"
140 IF INKEY$="" THEN GO TO 140
150 REM *** Wait for key release ***
160 IF INKEY$<>"" THEN GO TO 160
170 CLS
180 IF DEBUG>0 THEN GO SUB 1100 : REM Draw empty board
181 GO SUB 4000 : REM Draw empty board

200 REM *** Main Game Loop ***
220 IF currentPlayer=1 THEN INK 2
221 IF currentPlayer=2 THEN INK 6
222 PRINT AT 0,0;"Player ";currentPlayer;" - it's your turn"
223 INK 7
224 PRINT AT 21,0; "                                "
230 GO SUB 320   : REM Get input
240 GO SUB 1400  : REM Place piece
250 IF DEBUG>0 THEN GO SUB 1300  : REM Update board
251 GO SUB 5000  : REM Update board
260 GO SUB 2000  : REM Check is there a winner
270 GO SUB 3000  : REM Handle any outcomes
280 GO TO 200

320 REM *** Get Input ***
330 LET i$=INKEY$
340 IF i$="" THEN GO TO 330
350 IF i$>="1" AND i$<=STR$ colcount THEN LET userColumn=VAL i$: RETURN
360 GO TO 330

1100 REM *** Draw Initial Debug Board ***
1110 FOR i=0 TO rowcount-1
1120   FOR j=0 TO colcount-1
1130     LET pos=(j+1)+(i*colcount)
1140     PRINT AT 18-i,j+24;a(pos)
1150   NEXT j
1160 NEXT i
1170 PRINT AT 20,24;"1234567"
1180 RETURN

1300 REM *** Update Debug Board ***
1310 IF a(coordinate)=1 THEN INK 2
1311 IF a(coordinate)=2 THEN INK 6
1312 PRINT AT 18-(placedRow-1),(userColumn-1)+24;a(coordinate)
1313 INK 7
1320 RETURN

1400 REM *** Place Piece ***
1410 LET row=1
1420 FOR p=userColumn TO userColumn+35 STEP 7
1430   IF a(p)=0 THEN GO TO 1470
1440   LET row=row+1
1450   IF row>6 THEN PRINT AT 21,0;"Column Full!": BEEP .2,1: RETURN
1460 NEXT p
1470 LET coordinate=p
1471 LET placedRow=row
1480 LET a(coordinate)=currentPlayer
1490 LET moves=moves+1
1500 LET currentPlayer=3-currentPlayer : REM Switch player (1->2, 2->1)
1510 RETURN

2000 REM *** Check is there a winner ***
2010 REM *** Check vertical wins ***
2020 FOR r=1 TO 3 : REM Only need to check first 3 rows as starting positions
2030   LET p=((r-1)*7)+userColumn
2040   IF a(p)>0 AND a(p)=a(p+7) AND a(p)=a(p+14) AND a(p)=a(p+21) THEN LET gameStatus=a(p): RETURN
2050 NEXT r

2100 REM *** Check horizontal wins ***
2110 LET rowStart=((placedRow-1)*7)+1
2120 FOR c=1 TO 4 : REM Only need to check first 4 positions in row
2130   LET p=rowStart+c-1
2140   IF a(p)>0 AND a(p)=a(p+1) AND a(p)=a(p+2) AND a(p)=a(p+3) THEN LET gameStatus=a(p): RETURN
2150 NEXT c

2200 REM *** Check diagonals from latest piece ***
2210 LET p=coordinate
2220 LET v=a(p)

2230 REM *** Check diagonal with step 6 (up-right and down-left) ***
2240 LET c=0
2250 FOR i=-3 TO 3
2260 IF i<>0 THEN IF p+i*6>0 AND p+i*6<43 THEN IF a(p+i*6)=v THEN LET c=c+1
2270 IF c=3 THEN LET gameStatus=v: RETURN
2280 NEXT i

2290 REM *** Check diagonal with step 8 (up-left and down-right) ***
2300 LET c=0
2310 FOR i=-3 TO 3
2320 IF i<>0 THEN IF p+i*8>0 AND p+i*8<43 THEN IF a(p+i*8)=v THEN LET c=c+1
2330 IF c=3 THEN LET gameStatus=v: RETURN
2340 NEXT i

2350 REM *** Check for draw (42 moves and no winner) ***
2360 IF moves=42 AND gameStatus=0 THEN LET gameStatus=-1
2370 RETURN

3000 REM *** Handle any outcomes ***
3010 IF gameStatus=0 THEN RETURN
3020 REM CLS
3030 IF gameStatus=-1 THEN PRINT AT 0,0;"GAME DRAWN!                     "
3040 IF gameStatus>0 THEN PRINT AT 0,0; "PLAYER ";gameStatus;" WINS!                  "
3050 PRINT AT 8,23;"R-RESTART"
3060 PRINT AT 9,23;"Q-QUIT"
3070 LET k$=INKEY$
3080 IF k$="" THEN GO TO 3070
3090 IF k$="R" OR k$="r" THEN RUN
3100 IF k$="Q" OR k$="q" THEN STOP
3110 GO TO 3070

4000 FOR n=1 TO 8
4010 PLOT INK 1;(n*colsize)-(colsize-startx),starty: DRAW INK 1;0,(rowcount*rowsize)
4020 NEXT n
4030 REM *** Draw horizontal lines ***
4040 FOR n=1 TO 7
4050 PLOT INK 1;startx,(n*rowsize)-(rowsize-starty): DRAW INK 1;(colcount*colsize),0
4060 NEXT n
4080 PRINT INK 7; AT 20,2;"1  2  3  4  5  6  7"
4090 RETURN

5000 REM *** Update Board ***
5010 IF a(coordinate)=1 THEN INK 2
5020 IF a(coordinate)=2 THEN INK 6
5031 LET posx=(colsize/2)+(userColumn*colsize)-(colsize-startx)
5032 LET posy=(rowsize/2)+((placedRow)*rowsize)-(rowsize-starty)
5033 CIRCLE posx,posy,5
5040 INK 7
5050 RETURN

6000 REM *** END OF PROGRAM ***
