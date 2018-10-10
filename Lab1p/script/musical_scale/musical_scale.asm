			org 000H
			sjmp start
notes:		db 96,85,76,72,64,57,51,48;
duration: 	db 131,147,165,175,196,220,255;
	
			org 0040H
start:		mov R3,#7
loop4:		jb P1.0,forward
			dec R3
			sjmp mod7
forward:	inc R3
mod7:		mov a,R3
			mov b,#8
			div ab
			mov a,b
			mov R3,b
			mov dptr,#duration
			movc a,@a+dptr
			mov R2,a
loop3:		mov a,b
			mov dptr,#notes
			movc a,@a+dptr
			mov R1,a
loop2:		mov R0,#10
loop1:		djnz R1,loop2    ;96*3
			cpl P3.1
			djnz R2,loop3    ;(7+96*3)*131
			mov R1,20
delay2:		mov R0,#255
delay1:		djnz R0,$        ;255*2
			djnz R1,delay2   ;(255*2+3)*255
			sjmp loop4
			sjmp $
			end