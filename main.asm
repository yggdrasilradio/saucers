 opt c

 setdp 0

 org $0

collision rmb 1
color	rmb 1
frame	rmb 1
joyf	rmb 1
vsync	rmb 1
seed	rmb 2
tick	rmb 1
xcurs	rmb 1
ycurs	rmb 1
joyx	rmb 1
joyy	rmb 1
lastb	rmb 1
joyb	rmb 1
sptr	rmb 2
temp	rmb 1

* SAUCER 1
ysa1	rmb 1	; y position
xsa1	rmb 1	; x position
xsa1d	rmb 1	; direction

* SAUCER 2
ysa2	rmb 1	; y position
xsa2	rmb 1	; x position
xsa2d	rmb 1	; direction

* REGISTER STORAGE
sreg	rmb 2
ureg	rmb 2
areg	rmb 1

 org $1000

STACK rmb 1

NSPRITES equ 8

SPRITE struct
ADDR rmb 2
XPOS rmb 1
YPOS rmb 1
;XDELTA rmb 1
;YDELTA rmb 1
 endstruct

sprites rmb sizeof{SPRITE}*(NSPRITES+1)

 IFGE *-$2000
 ERROR Overlay error
 ENDC

 org $2000

start

 * Disable IRQ and FIRQ
 lbsr DisableIRQ

 * Relocate stack
 lds #STACK

 * Set direct page
 clra
 clrb
 tfr a,dp

 * Clear sound sample pointer
 std sptr

 * Clear and debounce joystick fire button
 sta joyb
 lda #2
 sta joyf

 * Turn off ROMs
 lbsr romsoff

 * 1.78 Mhz CPU
 lbsr fast

 * Initialize MMU
 lbsr InitMMU

 * Seed random number routine
 addd $112	; throw in the BASIC timer
 bne no@	; can't be zero
 ldd #123
no@
 std seed

 * Init CPU
 lbsr cpuinit

 * Init graphics
 lbsr gfxinit

 * Init sprites
 lbsr InitSprites

 * Clear screens
 lbsr Task0
 lbsr gfxcls
 lbsr Task1
 lbsr gfxcls

 * Start cursor at center of screen
 lda #128/2
 sta xcurs
 lda #96/2
 sta ycurs

 * Init saucer 1 and saucer 2
 ldd #30*256+30 ; y : x
 std ysa1
 ldd #60*256+90 ; y : x
 std ysa2
 ldd #$01FF
 sta xsa1d
 stb xsa2d

 * Initialize IRQ routine
 lbsr InitIRQ

 * Enable IRQ interrupts
 lbsr EnableIRQ

mainloop

 lbsr FlipScreens

* Turn on border (DEBUG)
; lda #100
; sta $ff9a

 lbsr DrawFrame

 tst joyb	; joystick button pressed?
 beq no@
 * Start laser sound
 leau laser,pcr
 stu sptr
 clr joyb
 * Add explosion sprite
 leau explosion,pcr
 clra
 ldb xcurs
 addd #1
 tfr d,x
 ldb ycurs
 addd #1
 tfr d,y
 lbsr AddSprite
no@

* Turn off border (DEBUG)
; lda #0
; sta $ff9a

 lbra mainloop

* FIRQ interrupt handler
FIRQ
 pshs a,u
 ldu sptr	; pointer to sound data
 beq no@	; sample to play?
*************
 lda ,u+	; get next sample
 bne notdone@
 ldu #0		; last sample, clear pointer
notdone@
 sta $ff20	; save to DAC
 stu sptr	; save new pointer value
*************
no@
 lda $FF93
 puls a,u	; dismiss interrupt
 rti

* IRQ interrupt handler
IRQ

 * Countdown timer for joystick fire button
 tst joyf
 beq no@
 dec joyf
no@

 * Poll joystick
 lbsr JoyIn

 * Hard boot to RSDOS if BREAK pressed
 ldb #KEYBREAK
 lbsr KeyIn
 bne no@
 lbsr reset
no@

 * Set VSYNC flag
 inc vsync

 * Dismiss interrupt
 lda $FF92
 rti

 incl video.asm
 incl utils.asm
 incl joystick.asm
 incl drawframe.asm
 incl laser.asm
 incl sprites.asm
 incl spritedata.asm

SCREEN EQU $E000

 end start
