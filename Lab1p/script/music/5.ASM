ORG 00H ;???????

JMP START  ;??????

ORG 0BH;???T0????

JMP EXT0   ;???T0?????

START: 
MOV TMOD,#00000001B;??T0??1

MOV IE,#10000010B;??T0??

MOV DPTR,#TABLE   ;?????

LOOP:  
CLR A   ;?0

MOVC A,@A+DPTR   ;??

MOV R1,A   ;????8???R1

INC DPTR   ;???1

CLR A  ;?0

MOVC A,@A+DPTR  ;??

MOV R0,A  ;????8???R0

ORL A,R1   ;???
JZ NEXT0  ;?0????

MOV A,R0

ANL A,R1  ;???

CJNE A,#0FFH,NEXT;?1??????

JMP  START   ;??????

NEXT:  
MOV TH0,R1   ;???????

MOV TL0,R0   ;???????

SETB TR0  ;?????T0

JMP NEXT1;???NEXT1

NEXT0: 
CLR TR0   ;?????,????

NEXT1:
CLR A ;?0

INC DPTR ;???1

MOVC A,@A+DPTR;?????

MOV R2,A ;??????R2

LOOP1:  
ACALL   DELAY ;???????

DJNZ R2,LOOP1;??????

INC DPTR ;???1

JMP LOOP ;???LOOP?

EXT0:  
MOV TH0,R1  ;?????

MOV TL0,R0

CPL P3.4  ;????

RETI ;???????

DELAY:  
MOV R7,#02  ;?????

D2: 
MOV R6,#187

D3: 
MOV R5,#248

DJNZ R5,$

DJNZ R6,D3

DJNZ R7,D2

RET  ;???????

TABLE:   ;???

  DB 0FDH,80H,03H,0FDH,80H,01H

  DB 0FDH,0C6H,04H,0FDH,80H,04H

  DB 0FEH,2AH,04H,0FEH,02H,04H

  DB 00H,00H,04H

 DB 0FDH,80H,03H,0FDH,80H,01H

DB 0FDH,0C6H,04H,0FDH,80H,04H

   DB 0FEH,5CH,04H,0FEH,2AH,04H

   DB 00H,00H,04H

  DB 0FDH,80H,03H,0FDH,80H,01H

 DB 0FEH,0C0H,04H,0FEH,84H,04H

 DB 0FEH,2AH,04H,0FEH,02H,04H

 DB 0FDH,0C6H,04H

 DB 0FEH,98H,03H,0FEH,98H,01H

   DB 0FEH,84H,04H,0FEH,2AH,04H

  DB 0FEH,5CH,04H,0FEH,2AH,04H

 DB 00H,00H,004H

 DB 0FEH,0FEH  ;???

END  ;????