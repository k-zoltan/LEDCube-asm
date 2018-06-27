;
; 4x4LedCube.asm
;
; Created: 2018. 06. 20. 20:16:29
; Author : zoltan
;


; Replace with your application code
.include "m16def.inc"

.org 0x0000
     jmp init


shift:
	cpi r16, 0x0F		; If all LEDs are lit
	breq _high_bits
	ldi r23, 0x00
	lsl r16
	ori r16, 0x01		; Áldott legyen az ORI!
	ret
	_high_bits:
		ldi r23, 0x00
		;cpi r20, 0x0F
		lsl r17
		ori r17, 0x01
		ret


delay_5ms:
    ldi  r20, 7			; 5 ms delay 
    ldi  r21, 125
L1: dec  r21
    brne L1
    dec  r20
    brne L1
    rjmp PC+1			; 5 ms delay end
	ret

init:
	LDI R16, low(RAMEND)
    OUT SPL, R16
    LDI R16, high(RAMEND)
    OUT SPH, R16
	ldi r16, 0x00
	ldi r17, 0x00
	ldi	r19, 0xFF	
	out	DDRD, r19	; All layer pins are outputs (DDRD)
	out	DDRA, r19	; All LED low pins are outputs (DDRA)
	out	DDRC, r19	; All LED high pins are outputs (DDRC)
start:
	ldi r19, 0x00
	out	PORTA, r19	; LEDs 0..7 are off
	out PORTC, r19	; LEDs 8..15 are off
	ldi r23, 0x00
reset:
	ldi r18, 0x01	; Only the top layer is active
	out PORTD, r18
loop:
	lsl r18				; Layer no. shifted left
	call delay_5ms		; 5ms delay
	out PORTD, r18
	out PORTA, r16
	out PORTC, r17
	cpi r18, 0x10	; Is it at the end?
	breq reset			; If yes, reset layer no. to 0001
	inc r23
	cpi r23, 0xFF	; After ~1.3 sec, shift the LED ports
	breq _shift
	brne _end
_shift:
	call shift
	rjmp reset
_end:
	jmp	loop			; Else, return to the bit shift
