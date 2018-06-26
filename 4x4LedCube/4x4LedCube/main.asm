;
; 4x4LedCube.asm
;
; Created: 2018. 06. 20. 20:16:29
; Author : zoltan
;


; Replace with your application code
.include "m16def.inc"

.org 0x0000
     jmp start

.org 0x002A

delay_5ms:
    ldi  r20, 7			; 5 ms delay 
    ldi  r21, 125
L1: dec  r21
    brne L1
    dec  r20
    brne L1
    rjmp PC+1			; 5 ms delay end
	ret

start:
    ldi	r19, 0xFF	
	out	DDRD, r19	; All layer pins are outputs (DDRD)
	out	DDRA, r19	; All LED low pins are outputs (DDRA)
	out	DDRC, r19	; All LED high pins are outputs (DDRC)
	ldi r19, 0x00
	out	PORTA, r19	; LEDs 0..7 are on
	out PORTC, r19	; LEDs 8..15 are on
reset:
	ldi r18, 0x01	; Only the top layer is active
	out PORTD, r18

loop:
	lsl r18				; Layer no. shifted left
	rcall delay_5ms		; 5ms delay
	out PORTD, r18
	cpi r18, 0b00010000	; Is it at the end?
	breq reset			; If yes, reset layer no. to 0001
	jmp	loop			; Else, return to the bit shift
