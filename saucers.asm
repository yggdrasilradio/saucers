* Set up the saucers table
InitSaucers
 ldu #saucers
 lda #NSAUCERS
 clrb
 ldx #0
loop@
 stx SAUCER.ADDR,u
 stx SAUCER.XPOS,u
 stb SAUCER.XDELTA,u
 leau sizeof{SAUCER},u
 deca
 bne loop@
 rts

* Create a new saucer
*
* B Y value
CreateSaucer
 ldu #saucer
 pshs b
 lbsr rand
 anda #127	; random x
 ldb ,s
 tfr d,x	; X register  = x : y
 lbsr rand
 andb #1	; x delta is 0 or 1
 incb		; x delta is 1 or 2
 anda #1
 beq >
 negb
! lbsr AddSaucer
 puls b,pc

* Are there any saucers with a specific Y value?
*
*  lda #YVALUE
*  lbsr FindSaucer
*  bne found@
*  beq notfound@
*
FindSaucer
 ldb #NSAUCERS
 pshs b
 ldu #saucers
loop@
 cmpa SAUCER.YPOS,u
 beq found@
 leau sizeof{SAUCER},u
 dec ,s
 bne loop@
 clra
found@
 tsta
 puls a,pc

* Add new saucer to saucer table
* U saucer addr
* X xpos : ypos
* B xdelta
*
* Stack:
*	A ,s	counter
*	B 1,s	xdelta
AddSaucer
 lda #NSAUCERS
 pshs d
 ldy #saucers
loop@
 ldd SAUCER.ADDR,y
 bne endloop@
 stu SAUCER.ADDR,y
 stx SAUCER.XPOS,y
 ldb 1,s
 stb SAUCER.XDELTA,y
 bra exit@
endloop@
 leay sizeof{SAUCER},y
 dec ,s
 bne loop@
exit@
 leas 2,s
 rts

* Draw all the saucers
DrawSaucers
 ldy #saucers
 lda #NSAUCERS
 pshs a
loop@
 ldx SAUCER.ADDR,y
 beq endloop@
 ldu SAUCER.ADDR,y
 lda frame		; use alternate sprite
 anda #4
 beq >
 leau 64,u
! lda SAUCER.YPOS,y
 ldb SAUCER.XPOS,y
* U sprite data
* B x coordinate
* A y coordinate
 lbsr DrawSprite
 lda SAUCER.XPOS,y	; x += xdelta
 adda SAUCER.XDELTA,y
 sta SAUCER.XPOS,y
endloop@
 leay sizeof{SAUCER},y
 dec ,s
 bne loop@
 leas 1,s
 rts

* See if we hit any saucers
DestroySaucer
 ldd xcurs	; make the hitbox
 adda #4
 addb #4
 std xhit
 ldu #saucers
 lda #NSAUCERS
 pshs a
 ldx #0
loop@
 ldd SAUCER.XPOS,u	; is this a saucer?
 beq endloop@
* Check X
 cmpa xhit
 bhi endloop@
 adda #8
 cmpa xhit
 blo endloop@
* Check Y
 cmpb yhit
 bhi endloop@
 addb #8
 cmpb yhit
 blo endloop@
* Remove saucer
 stx SAUCER.ADDR,u
 stx SAUCER.XPOS,u
 clr SAUCER.XDELTA,u
endloop@
* Next saucer
 leau sizeof{SAUCER},u
 dec ,s
 bne loop@
 puls a,pc
