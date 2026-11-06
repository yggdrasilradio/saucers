DrawFrame

 inc frame

 * BEGIN SCREEN DRAWING
 lbsr gfxcls

* Turn on border (DEBUG)
; lda #55
; sta $ff9a

 * Draw animated saucer 1
 leau saucer1,pcr
 lda frame
 anda #4	; animation speed
 beq >
 leau saucer2,pcr
! lda ysa1 ; y
 ldb xsa1 ; x
 lbsr DrawSprite

 * Move saucer 1
 lda xsa1
 adda xsa1d
 sta xsa1
 cmpa #127-8-1
 blo >
 ldb #$ff
 stb xsa1d
! cmpa #2
 bhi >
 ldb #1
 stb xsa1d
!
 
 * Draw animated saucer 2
 leau saucer1,pcr
 lda frame
 anda #4	; animation speed
 beq >
 leau saucer2,pcr
! lda ysa2 ; y
 ldb xsa2 ; x
 lbsr DrawSprite

 * Move saucer
 lda xsa2
 adda xsa2d
 sta xsa2
 cmpa #127-8-1
 blo >
 ldb #$ff
 stb xsa2d
! cmpa #2
 bhi >
 ldb #1
 stb xsa2d
!
 
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
 lbsr WaitForKey ; DEBUG

 rts
