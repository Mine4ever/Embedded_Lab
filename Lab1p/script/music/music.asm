SPK EQU P1.0; SPK: PIN_174 (SPKER)
; INPUT
PAUSE EQU P3.0; PAUSE: PIN_233 (Key 0)

org 0000H; code segment align
jmp START; goto START => 2 cycles

; @name: START
; @desc: ???
; @param: TABLE {Array} - ?????????????
; @param: S_PARA {Array} - ?????
; @param: DELAY_T {Array} - ???????
; @write: R0, R1, R2, R3, R4, R5, R7, A
; @cycle: Infinity
START:
  mov R3, #00H; => 1 cycle
  NEXT:
    mov A, R3; => 1 cycle
    mov DPTR, #TABLE; => 2 cycles
    movc A, @A + DPTR; => 2 cycles
    jz START; => 2 cycles
    mov R7, A; => 1 cycle
    inc R3; => 1 cycle

    mov A, R3; => 1 cycle
    movc A, @A + DPTR; => 2 cycles
    mov R2, A; => 1 cycle
    
    acall SONG; => ... @see {SONG}
    inc R3; => 1 cycle
    sjmp NEXT; => 2 cycles

; @name: SONG
; @desc: ?????????
; @param: R2 - ???? R2 ?????? (????????2)
; @param: DELAY_T {Array} - ???????
; @param: S_PARA {Array} - ?????
; @param: R7 - ????
; @write: R0, R1, R2, R4, R5, A
; @alias:
;   - [0]: S_PARA[R7]
;   - [1]: DELAY_T[R7]
; @cycle: R2 * [0] * [1] * 48 + R2 * [0] * 40 + R2 * 36 + 9 (if R2 != 0)
; @cycle: [0] * [1] * 24 + [0] * 20 + 28 (only if R2 = 0)
; @note: ???? t = 12 * @cycle / CPU_FREQUENCY
; @note: ???? f = (R2 * 2 * [0]) / t
; @note: ????? SONG ??????????????
; @note: ??????? R2 ?? SONG ?????????,?????
SONG:; call this => 2 cycles
  mov A, R2; 1 cycle
  RL A; 1 cycle
  jnz KEEP; 2 cycles
    mov A, #01H; 1 cycle
  KEEP:; branch => 2 cycles (+1 only if R2 = 0)
  mov R2, A; 1 cycle
  REPEAT:; [0] * [1] * 24 + [0] * 20 + 18 cycles for each, hit R2 * 2 (1 only if R2 = 0) times => R2 * [0] * [1] * 48 + R2 * [0] * 40 + R2 * 36 cycles
    acall EIGHTH; => [0] * [1] * 24 + [0] * 20 + 16 cycles
    djnz R2, REPEAT; => 2 cycles
  ret; return => 2 cycles

; @name: EIGHTH
; @desc: ?? 1/8 ??????
; @param: DELAY_T {Array} - ???????
; @param: S_PARA {Array} - ?????
; @param: R7 - ????
; @write: R0, R1, R4, R5, A
; @cycle: S_PARA[R7] * DELAY_T[R7] * 24 + S_PARA[R7] * 20 + 16
; @note: ???? n = S_PARA[R7]
; @note: ??????? t = 12 * @cycle / CPU_FREQUENCY
; @note: ?? f = n / t
; @note: ???????????????????
EIGHTH:; call this => 2 cycles
  ; R4 := DELAY_T[R7]
  mov A, R7; => 1 cycle
  mov DPTR, #DELAY_T; => 2 cycles
  movc A, @A + DPTR; => 2 cycles
  mov R4, A; 1 cycle
  ; R5 := S_PARA[R7]
  mov A, R7; => 1 cycle
  mov DPTR, #S_PARA; => 2 cycles
  movc A, @A + DPTR; => 2 cycles
  mov R5, A; => 1 cycle
  NEXTCYC:; R4 * 24 + 20 cycles each loop, hit R5 times => R5 * R4 * 24 + R5 * 20 cycles
    jb PAUSE, $; while (!PAUSE);
    acall SOUND; => R4 * 24 + 18 cycles
    djnz R5, NEXTCYC; => 2 cycles
  ret; return => 2 cycles

; @name: SOUND
; @desc: ??????????
; @param: R4 - ??????????
; @write: R0, R1, A
; @cycle: R4 * 24 + 18 (????)
; @note: ?????? 50 %
; @note: ???????? 1 cycle
SOUND:; => call this => 2 cycles
  setb SPK; => 1 cycle
  acall SDELAY; => R4 * 12 + 6 cycles
  clr SPK; => 1 cycle
  acall SDELAY; => R4 * 12 + 6 cycles
  ret; return => 2 cycles

; @name: SDELEY
; @desc: Soft Delay (???)
; @param: R4 - ??????????
; @write: R0, R1, A
; @cycle: R4 * 12 + 6
SDELAY:; call this => 2 cycles
  mov A, R4; => 1 cycle
  mov R0, A; => 1 cycle
  XL2:; 12 cycles each loop, hit R4 times => R4 * 12 cycles
    mov R1, #03H; => 1 cycle
    DL1:; 3 cycles each loop, hit 3 times => 9 cycles
      nop; => 1 cycle
      djnz R1, DL1; => 2 cycles
    djnz R0, XL2; => 2 cycles
  ret; return => 2 cycles

; @name: S_PARA
; @desc: ??????????????
; @note: ???????(FFH, 00H) ????,????????
S_PARA:
ds 1DH
db 15H, 16H, 00H
db 19H, 00H, 1CH, 00H, 1FH, 21H, 00H, 25H
db 00H, 29H, 2CH, 00H, 31H, 34H, 37H, 00H
db 3EH, 41H, 00H, 49H, 00H, 52H, 57H, 00H
db 62H

; @name: DELAY_T
; @desc: ?????
; @note: ???????(FFH, 00H) ????,????????
DELAY_T:
ds 1DH
db 7EH, 77H, 00H
db 6AH, 00H, 5EH, 00H, 54H, 4FH, 00H, 46H
db 00H, 3FH, 3BH, 00H, 35H, 32H, 2FH, 00H
db 2AH, 27H, 00H, 23H, 00H, 1FH, 1DH, 0C0H
db 1AH


; @name: TABLE
; @desc: «???» ?????
; @note: ?????????
; @note: ?????????? S_PARA ? DELAY_T ?????
; @note: ?????????????????
TABLE:
DW 2008H, 2708H, 2704H, 2504h, 2908H
DW 2008H, 2708H, 2704H, 2504H, 2908H
DW 2208H, 2908H, 2904H, 2704H, 2A08H
DW 2208H, 2906H, 2A02H, 2904H, 2704H, 2504H, 2202H, 2002H
DW 2008H, 2708H, 2704H, 2504H, 2908H
DW 2008H, 2708H, 2704H, 2504H, 2908H
DW 2208H, 2908H, 2904H, 2704H, 2A08H
DW 2208H, 2906H, 2A02H, 2904H, 2704H, 2504H, 2C02H, 2D02H
DW 2D04H, 2904H, 2904H, 2504H, 2504H, 2204H, 2504H, 2C04H
DW 2C04H, 2704H, 2704H, 2404H, 2404H, 2004H, 2404H, 2504H
DW 2208H, 2504H, 2204H, 2504H, 2202H, 2502H, 2502H, 2702H, 2902H, 2A02H
DW 2A02H, 2704H, 2708H, 2908H, 2A08H

DW 2C03H, 2A03H, 2903H, 2903H, 2A03H, 2C03H, 2C03H, 2A03H, 2903H, 2903H, 2502H

DW 2C03H, 2A03H, 2903H, 2903H, 2A03H, 2C03H, 2C03H, 2A03H, 2903H, 2903H, 2501H, 2701H

DW 2904H, 2C04H, 2C04H, 2502H, 2702H, 2904H, 2C04H, 2C04H, 2502H, 2702H
DW 2504H, 2704H, 2504H, 2704H, 2904H, 2702H, 2902H, 2A04H, 2902H, 2A02H

DW 2C03H, 2A03H, 2903H, 2903H, 2A03H, 2C03H, 2C03H, 2A03H, 2903H, 2903H, 2502H

DW 2C03H, 2A03H, 2903H, 2903H, 2A03H, 2C03H, 2C03H, 2A03H, 2903H, 2903H, 2501H, 2701H
DW 2904H, 2C04H, 2C04H, 2502H, 2702H, 2904H, 2C04H, 2C04H, 2502H, 2902H
DW 2504H, 2704H, 2504H, 2704H, 2904H, 2A04H, 2C04H, 3004H

DW 3020H
DW 0000H

end