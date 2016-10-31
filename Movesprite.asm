BasicUpstart2(begin)			// <- This creates a basic sys line that can start your program
//*************************************************
//* Create and move a simple sprite x,y           *
//*************************************************

// Animation vars
fcount:  .byte 0 // Frame counter
pos0:    .byte 0 // Array animation position pointer 0
xposl0:  .byte 0 // Least significant byte Xpos sprite 0
xposm0:  .byte 0 // Most significant byte Xpes sprite 0
pos1:    .byte 4 // Array animation position pointer 0
xposl1:  .byte 34 // Least significant byte Xpos sprite 0
xposm1:  .byte 0 // Most significant byte Xpes sprite 0
pos2:    .byte 8 // Array animation position pointer 0
xposl2:  .byte 70 // Least significant byte Xpos sprite 0
xposm2:  .byte 0 // Most significant byte Xpes sprite 0
pos3:    .byte 12 // Array animation position pointer 0
xposl3:  .byte 104 // Least significant byte Xpos sprite 0
xposm3:  .byte 0 // Most significant byte Xpes sprite 0
pos4:    .byte 16 // Array animation position pointer 0
xposl4:  .byte 140 // Least significant byte Xpos sprite 0
xposm4:  .byte 0 // Most significant byte Xpes sprite 0
pos5:    .byte 20 // Array animation position pointer 0
xposl5:  .byte 174 // Least significant byte Xpos sprite 0
xposm5:  .byte 0 // Most significant byte Xpes sprite 0
pos6:    .byte 24 // Array animation position pointer 0
xposl6:  .byte 180 // Least significant byte Xpos sprite 0
xposm6:  .byte 30 // Most significant byte Xpes sprite 0
pos7:    .byte 28 // Array animation position pointer 0
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
.const SP0VAL	= $3000
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

// Include macro's
#import "Macro.asm"

// Start of the main program
* = $4000 "Main Program"		// <- The name 'Main program' will appear in the memory map when assembling		jsr clear
  begin:  SetBorderColor(BLACK)
  SetBackgroundColor(BLACK) // Basic setup 
  ClearScreen(00)
  StretchSpriteX(%11111111)
  StretchSpriteY(%11111111)
SpriteMultiColor(%11111111)

  // Point the Spriter pointers to the correct memory locations $2000/$40=$80
lda #(SP0VAL/$40)	//using block 13 for sprite0
  sta SPRITE0
  lda #(SP0VAL/$40)+1	//using block 13 for sprite0
  sta SPRITE1
  lda #(SP0VAL/$40)+2	//using block 13 for sprite0
  sta SPRITE2
  lda #(SP0VAL/$40)+1	//using block 13 for sprite0
  sta SPRITE3
  lda #(SP0VAL/$40)+1	//using block 13 for sprite0
  sta SPRITE4
  lda #(SP0VAL/$40)+3	//using block 13 for sprite0
  sta SPRITE5
  lda #(SP0VAL/$40)+4	//using block 13 for sprite0
  sta SPRITE6

  // Enable sprites	0-6
  lda #%01111111		//enable sprites
  sta ENABLE

  // Color to the sprites	
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

  // Setup the SID
  jsr music_init

  // Init the raster interrupt that does the animation	
  jsr rastinit // Setup the raster interrupt

main:     ldy #$36         //load $7a into Y. this is the line where our rasterbar will start.
  ldx #00         //;load $00 into X
!loop:     lda colors,x     //;load value at label 'colors' plus x into a. if we don't add x, only the first 
  //;value from our color-table will be read.

  cpy $d012        //;ComPare current value in Y with the current rasterposition.
  bne *-3          //;is the value of Y not equal to current rasterposition? then jump back 3 bytes (to cpy).

  sta $d025        //;if it IS equal, store the current value of A (a color of our rasterbar)
  //;into the sprite extra colour 1

  cpx #153         // ;compare X to #51 (decimal). have we had all lines of our bar yet?
  beq main        // ;Branch if EQual. if yes, jump to main.

  inx              //;increase X. so now we're gonna read the next color out of the table.
  iny              //;increase Y. go to the next rasterline.

  jmp !loop-         //;jump to loop.

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

  // Music loader
  *=$1000 "Music"
  .label music_init =*			// <- You can define label with any value (not just at the current pc position as in 'music_init:') 
  .label music_play =*+3			// <- and that is useful here
  .import binary "ode to 64.bin"	// <- import is used for importing files (binary, source, c64 or text)	

// Interrupt handling routines
#import "Irq.asm"
// Import object data
#import "Data.asm"
