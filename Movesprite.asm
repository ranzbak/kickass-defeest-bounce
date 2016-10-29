BasicUpstart2(begin)			// <- This creates a basic sys line that can start your program
//*************************************************
//* Create and move a simple sprite x,y           *
//*************************************************

// Animation vars
fcount:  .byte 0 // Frame counter
pos0:    .byte 0 // Array animation position pointer 0
xposl0:  .byte 0 // Least significant byte Xpos sprite 0
xposm0:  .byte 0 // Most significant byte Xpes sprite 0
pos1:    .byte 2 // Array animation position pointer 0
xposl1:  .byte 34 // Least significant byte Xpos sprite 0
xposm1:  .byte 0 // Most significant byte Xpes sprite 0
pos2:    .byte 4 // Array animation position pointer 0
xposl2:  .byte 70 // Least significant byte Xpos sprite 0
xposm2:  .byte 0 // Most significant byte Xpes sprite 0
pos3:    .byte 6 // Array animation position pointer 0
xposl3:  .byte 104 // Least significant byte Xpos sprite 0
xposm3:  .byte 0 // Most significant byte Xpes sprite 0
pos4:    .byte 8 // Array animation position pointer 0
xposl4:  .byte 140 // Least significant byte Xpos sprite 0
xposm4:  .byte 0 // Most significant byte Xpes sprite 0
pos5:    .byte 10 // Array animation position pointer 0
xposl5:  .byte 174 // Least significant byte Xpos sprite 0
xposm5:  .byte 0 // Most significant byte Xpes sprite 0
pos6:    .byte 12 // Array animation position pointer 0
xposl6:  .byte 180 // Least significant byte Xpos sprite 0
xposm6:  .byte 30 // Most significant byte Xpes sprite 0
pos7:    .byte 14 // Array animation position pointer 0
xposl7:  .byte 180 // Least significant byte Xpos sprite 0
xposm7:  .byte 64 // Most significant byte Xpes sprite 0
		
//helpful labels
.const CLEAR = $E544
.const GETIN  =  $FFE4
.const SCNKEY =  $FF9F

//sprite 0 setup
.const SPRITE0 = $7F8
.const SPRITE1 = $7F9
.const SPRITE2 = $7FA
.const SPRITE3 = $7FB
.const SPRITE4 = $7FC
.const SPRITE5 = $7FD
.const SPRITE6 = $7FE
.const SPRITE7 = $7FF
.const SP0VAL	= $2000
.const SP0X	= $D000
.const SP0Y	= $D001
.const SP1X = $D002
.const SP1Y = $D003
.const MSBX	= $D010
.const SCRCONTREG = $D011
.const CURRASTLN = $D012
.const ENABLE  = $D015
.const YEXPAND	= $D017
.const INTSTATREG = $D019
.const INTVICCONTREG = $D01A
.const SPRMULTI = $D01C
.const XEXPAND	= $D01D
.const FRAMCOL  = $D020
.const EXCOLOR1 = $D025
.const EXCOLOR2 = $D026
.const COLOR0   = $D027
.const COLOR1   = $D028
.const COLOR2   = $D029
.const COLOR3   = $D02A
.const COLOR4   = $D02B
.const COLOR5   = $D02C
.const COLOR6   = $D02D
.const COLOR7   = $D02E
.const INTCONTREG = $DC0D

.macro ClearScreen(clearByte) {
         ldx #$00
!clear:  lda #$20     // #$20 is the spacebar Screen Code
         sta $0400,x  // fill four areas with 256 spacebar characters
         sta $0500,x
         sta $0600,x 
         sta $06e8,x 
         lda #$00     // set foreground to black in Color Ram 
         sta $d800,x  
         sta $d900,x
         sta $da00,x
         sta $dae8,x
         inx           // increment X
         bne !clear-     // did X turn to zero yet?
}

.macro MoveSpriteX(num, xposl, xposm) {
  ldy xposl // least significant position byte first
  ldx xposm // most significant position byte
  cpy #180
  beq spritehigh
  iny
  iny
  sty xposl
  jmp spritexpos
spritehigh:  inx // Add least significant byte to most significant
  inx
  stx xposm
  cpx #180
  bne spritexpos // When the msb reaches 160 start back at zero for both
  ldx #0
  stx xposl
  stx xposm
spritexpos: lda xposl
  clc
  adc xposm
  sta SP0X+num*2
  lda MSBX
  ldx #num
  and bitmaskinv, x // carry not set
  bcc spritemost
  ora bitmask, x // carry set
spritemost: sta MSBX
}

.macro AnimSprite(num, animp, countp) {
  ldy countp // Get value
  ldx fcount // Frame count
  inx
  cpx #03 // number of frames to wait
  bne over
  ldx #0
  lda animp, y
  sta SP0Y+num*2
  iny // Cycle through animation
  cpy #16
  bne over
  ldy #0
over:  sty countp
  stx fcount
}

.macro SetBorderColor(color) {
	lda #color
	sta $d020
}

.macro SetBackgroundColor(color) {
	lda #color
	sta $d021
}

.macro StretchSpriteX(bits) {
		lda #bits	// Sprite 0 double size X
		sta $D01D
}

.macro StretchSpriteY(bits) {
		lda #bits	// Sprite 0 double size Y
		sta $D017
}

.macro SpriteMultiColor(bits) {
		lda #bits	// Sprite 0 double size Y
		sta SPRMULTI // Multicolor
}

		* = $4000 "Main Program"		// <- The name 'Main program' will appear in the memory map when assembling		jsr clear
begin:  SetBorderColor(00)
		SetBackgroundColor(00)
		ClearScreen(00)
    StretchSpriteX(%11111111)
    StretchSpriteY(%11111111)
    SpriteMultiColor(%11111111)

		lda #$80	//using block 13 for sprite0
		sta SPRITE0
		lda #$81	//using block 13 for sprite0
		sta SPRITE1
		lda #$82	//using block 13 for sprite0
		sta SPRITE2
		lda #$81	//using block 13 for sprite0
		sta SPRITE3
		lda #$81	//using block 13 for sprite0
		sta SPRITE4
		lda #$83	//using block 13 for sprite0
		sta SPRITE5
		lda #$84	//using block 13 for sprite0
		sta SPRITE6
		
		lda #%11111111		//enable sprites
		sta ENABLE
		
		lda #05		//use red for sprite0
		sta COLOR0
		sta COLOR1
		sta COLOR2
		sta COLOR3
		sta COLOR4
		sta COLOR5
		sta COLOR6
    lda #09
    sta EXCOLOR1
    lda #07
    sta EXCOLOR2   // 3rd sprite color
		
    jsr rastinit // Setup the raster interrupt
    
		ldx #0
		lda #0
		
// Main loop
scan:	jsr SCNKEY	//get key
		jsr GETIN	//put key in A

start:	
    cmp #13	//end if enter clicked
		beq end
		jmp scan

		//clean up at the end
end:	jsr CLEAR
		lda #0
		sta ENABLE
		rts

    // Setup Raster interrupt
rastinit: lda #%01111111  // Switch of interrupt signals fram CIA-1
    sta INTCONTREG

    and SCRCONTREG
    sta SCRCONTREG

    lda #$F9
    sta CURRASTLN

    lda #<irq1
    sta $0314
    lda #>irq1
    sta $0315
    lda #%00000001
    sta INTVICCONTREG
    rts

irq1: lda #7 // Turn screen border yellow
    sta FRAMCOL

    MoveSpriteX(0, xposl0, xposm0)
    MoveSpriteX(1, xposl1, xposm1)
    MoveSpriteX(2, xposl2, xposm2)
    MoveSpriteX(3, xposl3, xposm3)
    MoveSpriteX(4, xposl4, xposm4)
    MoveSpriteX(5, xposl5, xposm5)
    MoveSpriteX(6, xposl6, xposm6)
    MoveSpriteX(7, xposl7, xposm7)
    //MoveSpriteY(0)
    AnimSprite(0, bounce, pos0)
    AnimSprite(1, bounce, pos1)
    AnimSprite(2, bounce, pos2)
    AnimSprite(3, bounce, pos3)
    AnimSprite(4, bounce, pos4)
    AnimSprite(5, bounce, pos5)
    AnimSprite(6, bounce, pos6)
    AnimSprite(7, bounce, pos7)

    ldx #90 // Wait loop
pauze1: dex
    bne pauze1
    
    lda #0 // Frame back to black (tm)
    sta FRAMCOL

    asl INTSTATREG
    jmp $EA31
		 	
// Bouncing animation data generation
.var i=0;
.var len=16
bounce:
.while (i++<len/2) {
  .var x = round(255-(60+140*cos(i/(PI/4*(len/2)))))
  .print x
  .byte x 
}
.var j=len/2
.while (j-->0) {
  .var x = round(255-(60+140*cos(j/(PI/4*(len/2)))))
  .print x
  .byte x
}

// Lazy man bitmask
bitmask: 
  .byte %00000001
  .byte %00000010
  .byte %00000100
  .byte %00001000
  .byte %00010000
  .byte %00100000
  .byte %01000000
  .byte %10000000
bitmaskinv: 
  .byte %11111110
  .byte %11111101
  .byte %11111011
  .byte %11110111
  .byte %11101111
  .byte %11011111
  .byte %10111111
  .byte %01111111

//define the sprite
.pc = SP0VAL
.align $40
data_d: 
    // d 0 
    .byte $55, $55, $40, $6a, $aa, $90, $6f, $ff, $a4, $6e, $aa, $e4, $6e, $55, $b9, $6e
    .byte $41, $b9, $6e, $41, $b9, $6e, $41, $b9, $6e, $41, $b9, $6e, $41, $b9, $6e, $41
    .byte $b9, $6e, $41, $b9, $6e, $41, $b9, $6e, $41, $b9, $6e, $41, $b9, $6e, $41, $b9
    .byte $6e, $55, $b9, $6e, $aa, $e4, $6f, $ff, $a4, $6a, $aa, $90, $55, $55, $40, $00
data_e:
    // e 1
    .byte $55, $55, $55, $6a, $aa, $a9, $6f, $ff, $f9, $6e, $aa, $a9, $6e, $55, $55, $6e
    .byte $40, $00, $6e, $40, $00, $6e, $40, $00, $6e, $55, $50, $6e, $aa, $90, $6f, $ff
    .byte $90, $6e, $aa, $90, $6e, $55, $50, $6e, $40, $00, $6e, $40, $00, $6e, $40, $00
    .byte $6e, $55, $55, $6e, $aa, $a9, $6f, $ff, $f9, $6a, $aa, $a9, $55, $55, $55, $00
data_f:
    // f 2
    .byte $55, $55, $55, $6a, $aa, $a9, $6f, $ff, $f9, $6e, $aa, $a9, $6e, $55, $55, $6e
    .byte $40, $00, $6e, $40, $00, $6e, $40, $00, $6e, $55, $50, $6e, $aa, $90, $6f, $ff
    .byte $90, $6e, $aa, $90, $6e, $55, $50, $6e, $40, $00, $6e, $40, $00, $6e, $40, $00
    .byte $6e, $40, $00, $6e, $40, $00, $6e, $40, $00, $6a, $40, $00, $55, $40, $00, $00 
    // s 3
data_s:
    .byte $00, $55, $00, $05, $aa, $50, $1a, $ff, $a4, $1b, $aa, $e4, $6e, $55, $b9, $6e
    .byte $41, $b9, $6e, $40, $64, $6e, $55, $10, $6b, $aa, $40, $1a, $fe, $90, $06, $ab
    .byte $a4, $01, $56, $e9, $00, $01, $b9, $04, $01, $b9, $19, $01, $b9, $6e, $41, $b9
    .byte $6e, $56, $b9, $1b, $aa, $e4, $1a, $ff, $a4, $05, $aa, $50, $00, $55, $00, $00
    // t 4
data_t:
    .byte $55, $55, $54, $6a, $aa, $a4, $6f, $ff, $e4, $6a, $ba, $a4, $55, $b9, $54, $01
    .byte $b9, $00, $01, $b9, $00, $01, $b9, $00, $01, $b9, $00, $01, $b9, $00, $01, $b9
    .byte $00, $01, $b9, $00, $01, $b9, $00, $01, $b9, $00, $01, $b9, $00, $01, $b9, $00
    .byte $01, $b9, $00, $01, $b9, $00, $01, $b9, $00, $01, $a9, $00, $01, $55, $00, $00   
