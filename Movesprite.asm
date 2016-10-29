BasicUpstart2(begin)			// <- This creates a basic sys line that can start your program
//*************************************************
//* Create and move a simple sprite x,y           *
//*************************************************

// Animation vars
//.const pos0 = $02
//.const fcount = $03
pos0:    .byte 0 // Array animation position pointer 0
fcount:  .byte 0 // Frame counter
xposl0:  .byte 0 // Least significant byte Xpos sprite 0
xposm0:  .byte 0 // Most significant byte Xpes sprite 0
		
//helpful labels
.const CLEAR = $E544
.const GETIN  =  $FFE4
.const SCNKEY =  $FF9F

//sprite 0 setup
.const SPRITE0 = $7F8
.const SP0VAL	= $0340
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
.const XEXPAND	= $D01D
.const FRAMCOL = $D020
.const COLOR0  = $D027
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

.macro MoveSpriteX(num) {
  ldy xposl0 // least significant position byte first
  ldx xposm0 // most significant position byte
  cpy #180
  beq spritehigh
  iny
  sty xposl0
  jmp spritexpos
spritehigh:  inx // Add least significant byte to most significant
  stx xposm0
  cpx #180
  bne spritexpos // When the msb reaches 160 start back at zero for both
  ldx #0
  stx xposl0
  stx xposm0
spritexpos: lda xposl0
  clc
  adc xposm0
  sta SP0X+num*2
  lda MSBX
  ldx #num
  and bitmaskinv, x // carry not set
  bcc spritemost
  ora bitmask, x // carry set
spritemost: sta MSBX
}

.macro MoveSpriteY(num) {
  ldy SP0Y+num*2
  iny
  sty SP0Y+num*2
}

.macro AnimSprite(sprnum, animp, countp) {
  ldy countp // Get value
  ldx fcount // Frame count
  inx
  cpx #03 // number of frames to wait
  bne over
  ldx #0
  lda animp, y
  sta SP0Y+sprnum*2
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

		* = $4000 "Main Program"		// <- The name 'Main program' will appear in the memory map when assembling		jsr clear
begin:  SetBorderColor(00)
		SetBackgroundColor(00)
		ClearScreen(00)
    StretchSpriteX(01)
    StretchSpriteY(01)

		lda #$0D	//using block 13 for sprite0
		sta SPRITE0
		
		lda #01		//enable sprite0
		sta ENABLE
		
		lda #07		//use red for sprite0
		sta COLOR0
		
    jsr rastinit // Setup the raster interrupt
    
		ldx #0
		lda #0
		
		//reset the spriteval data
cleanup:	sta SP0VAL,X
		inx
		cpx #63
		bne cleanup
		
		//build the sprite
		ldx #0
build:	lda data,X
		sta SP0VAL,X
		inx
		cpx #63
		bne build
		
		//position
		lda #0		//stick with x0-255
		sta MSBX
		
		//starting sprite location
		ldx #100
		ldy #70
		stx SP0X
		sty SP0Y
		
scan:	jsr SCNKEY	//get key
		jsr GETIN	//put key in A

start:	cmp #87		//W - up
		beq up
		
		cmp #83		//S - down
		beq down
		
		cmp #65		//A - left
		beq left
		
		cmp #68		//D - right
		beq right
		
		cmp #13	//end if enter clicked
		beq end
		
		jmp scan

up:		ldy SP0Y
		dey
		sty SP0Y
		jmp scan

down:	ldy SP0Y
		iny
		sty SP0Y
		jmp scan

left:	ldx SP0X
		dex
		stx SP0X
		cpx #255
		bne scan
		lda #0
		sta MSBX
		jmp scan

right:	ldx SP0X
		inx
		stx SP0X
		cpx #255
		bne scan
		lda #1
		sta MSBX
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

    MoveSpriteX(0)
    //MoveSpriteY(0)
    AnimSprite(0, bounce, pos0)

    ldx #90 // Wait loop
pauze1: dex
    bne pauze1
    
    lda #0 // Frame back to black (tm)
    sta FRAMCOL

    asl INTSTATREG
    jmp $EA31
		 	
// Bouncing animation
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

// Sprite bitmask
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
data: 	 .byte 0,0,0
 .byte 0,0,0
 .byte 0,0,0
 .byte 0,0,0
 .byte 0,0,0
 .byte 0,0,0
 .byte 0,0,0
 .byte 0,0,0
 .byte 0,0,0
 .byte 0,0,0
 .byte 0,0,0
 .byte 0,0,0
 .byte 16,0,0
 .byte 16,96,0
 .byte 16,64,0
 .byte 114,253,223
 .byte 149,81,18
 .byte 151,89,154
 .byte 148,81,10
 .byte 115,93,218
 .byte 0,0,0
