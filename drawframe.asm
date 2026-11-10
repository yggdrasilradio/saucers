DrawFrame

 inc frame

 * BEGIN SCREEN DRAWING
 lbsr gfxcls

* Turn on border (DEBUG)
; lda #55
; sta $ff9a

 * Draw all the saucers
 lbsr DrawSaucers
 
 * Update location of targeting reticule
 ldd xcurs ; update cursor location
 adda joyx
 addb joyy
 cmpa #1 ; clip x, from 1 to 119
 bhs >
 lda #1
! cmpa #119
 bls >
 lda #119
! cmpb #9 ; clip y, from 9 to 87
 bhs >
 ldb #9
! cmpb #87
 bls >
 ldb #87
! std xcurs

 * Draw scheduled sprites
 lbsr DrawSprites

 * Draw targeting reticule
 leau reticule,pcr
 ldb xcurs
 lda ycurs
 lbsr DrawSprite

 * END SCREEN DRAWING
 ;lbsr WaitForKey ; DEBUG

 rts
