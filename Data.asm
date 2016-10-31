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

// Raster bar colors
colors:
         .byte $06,$06,$06,$0e,$06,$0e
         .byte $0e,$06,$0e,$0e,$0e,$03
         .byte $0e,$03,$03,$0e,$03,$03
         .byte $03,$01,$03,$01,$01,$03
         .byte $01,$01,$01,$03,$01,$01
         .byte $03,$01,$03,$03,$03,$0e
         .byte $03,$03,$0e,$03,$0e,$0e
         .byte $0e,$06,$0e,$0e,$06,$0e
         .byte $06,$06,$06,$00,$00,$00

         .byte $06,$06,$06,$0e,$06,$0e
         .byte $0e,$06,$0e,$0e,$0e,$03
         .byte $0e,$03,$03,$0e,$03,$03
         .byte $03,$01,$03,$01,$01,$03
         .byte $01,$01,$01,$03,$01,$01
         .byte $03,$01,$03,$03,$03,$0e
         .byte $03,$03,$0e,$03,$0e,$0e
         .byte $0e,$06,$0e,$0e,$06,$0e
         .byte $06,$06,$06,$00,$00,$00

         .byte $06,$06,$06,$0e,$06,$0e
         .byte $0e,$06,$0e,$0e,$0e,$03
         .byte $0e,$03,$03,$0e,$03,$03
         .byte $03,$01,$03,$01,$01,$03
         .byte $01,$01,$01,$03,$01,$01
         .byte $03,$01,$03,$03,$03,$0e
         .byte $03,$03,$0e,$03,$0e,$0e
         .byte $0e,$06,$0e,$0e,$06,$0e
         .byte $06,$06,$06,$00,$00,$00

         .byte $ff

// Bouncing animation data generation
.var i=0;
.var len=32
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