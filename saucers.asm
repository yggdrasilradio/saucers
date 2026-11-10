* Set up the saucers table
InitSaucers
 ldu #saucers
 lda #NSAUCERS
 ldx #0
loop@
 stx SAUCER.ADDR,u
 stx SAUCER.XPOS,u
 leau sizeof{SAUCER},u
 deca
 bne loop@
 rts

* Create a new saucer
CreateSaucer
 rts

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
* kill saucer if completely offscreen?
; lbsr IsVisible
; beq >
* kill saucer
; ldx #0
; stx SAUCER.ADDR,y
; stx SAUCER.XPOS,y
; bra endloop@
 *
!
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

* Is a saucer still onscreen at all?
IsVisible
 rts
