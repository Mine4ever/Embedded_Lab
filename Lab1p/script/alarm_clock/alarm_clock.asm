				org 0000H
				sjmp start
notes:			db 24          ;85,76,72,64,57,51,48
duration:		db 255
	
				org 0040H
start:			acall beep
				acall delay_short
				acall beep
				acall delay_short
				acall beep
				acall delay_long
				acall delay_long
				acall delay_long
				sjmp start
			
beep:			mov a,#0
				mov dptr,#duration
				movc a,@a+dptr
				mov R2,a
loop3:			mov a,#0
				mov dptr,#notes
				movc a,@a+dptr
				mov R1,a
loop2:			mov R0,#10
loop1:			djnz R0,$
				djnz R1,loop2
				cpl P3.1
				djnz R2,loop3
				ret
			
delay_short:	mov R1,#50
delay2:			mov R0,#50
delay1:			djnz R0,$
				djnz R1,delay2
				ret
				
delay_long:		mov R1,#255
delay4:			mov R0,#255
delay3:			djnz R0,$
				djnz R1,delay4
				ret
				
				sjmp $
				end