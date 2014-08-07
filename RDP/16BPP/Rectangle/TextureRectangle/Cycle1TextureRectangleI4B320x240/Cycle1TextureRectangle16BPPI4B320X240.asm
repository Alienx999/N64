; N64 'Bare Metal' 16BPP 320x240 Cycle1 Texture Rectangle I4B RDP Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros

  ScreenNTSC 320,240, BPP16|AA_MODE_2, $A0100000 ; Screen NTSC: 320x240, 16BPP, Resample Only, DRAM Origin $A0100000

  DMA Texture,TextureEnd, $00200000 ; DMA Data Copy Cart->DRAM: Start Cart Address, End Cart Address, Destination DRAM Address

  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank

  DPC RDPBuffer,RDPBufferEnd ; Run DPC Command Buffer: Start Address, End Address

Loop:
  j Loop
  nop ; Delay Slot

  align 8 ; Align 64-bit
RDPBuffer:
  Set_Scissor 0<<2,0<<2, 320<<2,240<<2, 0 ; Set Scissor: XH 0.0, YH 0.0, XL 320.0, YL 240.0, Scissor Field Enable Off
  Set_Other_Modes CYCLE_TYPE_FILL, 0 ; Set Other Modes
  Set_Color_Image SIZE_OF_PIXEL_16B|(320-1), $00100000 ; Set Color Image: SIZE 16B, WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FF01FF01 ; Set Fill Color: PACKED COLOR 16B R5G5B5A1 Pixels
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 ; Fill Rectangle: XL 319.0, YL 239.0, XH 0.0, YH 0.0

  Set_Other_Modes SAMPLE_TYPE|BI_LERP_0|ALPHA_DITHER_SEL_NO_DITHER, B_M2A_0_1|FORCE_BLEND|IMAGE_READ_EN ; Set Other Modes
  Set_Combine_Mode $0, $00, 0, 0, $1, $01, $0, $F, 1, 0, $1, $0, 0, 7, 7, 7 ; Set Combine Mode: SubA RGB0, MulRGB0, SubA Alpha0, MulAlpha0, SubA RGB1, MulRGB1, SubB RGB0, SubB RGB1, SubA Alpha1, MulAlpha1, AddRGB0, SubB Alpha0, AddAlpha0, AddRGB1, SubB Alpha1, AddAlpha1
  Set_Prim_Color 0,0, $FFFFFFFF ; Set Prim Color: Prim Min Level 0, Prim Level Frac 0, R 255, G 255, B 255, A 255


  Set_Texture_Image SIZE_OF_PIXEL_16B|(4-1), $00200000 ; Set Texture Image: SIZE 16B, WIDTH 4, DRAM ADDRESS $00200000
  Set_Tile SIZE_OF_PIXEL_16B|(1<<9)|$000, 0<<24 ; Set Tile: SIZE 16B, Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 15<<2,15<<2 ; Load Tile: SL 0.0, TL 0.0, Tile 0, SH 15.0, TH 15.0
  Sync_Tile ; Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I|SIZE_OF_PIXEL_4B|(1<<9)|$000, (0<<24) ; Set Tile: I, SIZE 4B, Tile Line Size 1 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 84<<2,76<<2, 0, 52<<2,44<<2, 0<<5,0<<5, $200,$200 ; Texture Rectangle: XL 84.0, YL 76.0, Tile 0, XH 52.0, YH 44.0, S 0.0, T 0.0, DSDX 0.5, DTDY 0.5

  Sync_Tile ; Sync Tile
  Texture_Rectangle 84<<2,130<<2, 0, 68<<2,114<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle: XL 84.0, YL 130.0, Tile 0, XH 68.0, YH 114.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0

  Sync_Tile ; Sync Tile
  Texture_Rectangle_Flip 84<<2,200<<2, 0, 68<<2,184<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle Flip: XL 84.0, YL 200.0, Tile 0, XH 68.0, YH 184.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0


  Sync_Tile ; Sync Tile
  Set_Texture_Image SIZE_OF_PIXEL_16B|(8-1), $00200080 ; Set Texture Image: SIZE 16B, WIDTH 8, DRAM ADDRESS $00200080
  Set_Tile SIZE_OF_PIXEL_16B|(2<<9)|$000, 0<<24 ; Set Tile: SIZE 16B, Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 31<<2,31<<2 ; Load Tile: SL 0.0, TL 0.0, Tile 0, SH 31.0, TH 31.0
  Sync_Tile ; Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I|SIZE_OF_PIXEL_4B|(2<<9)|$000, (0<<24)|MIRROR_S|MIRROR_T|MASK_S_4|MASK_T_4 ; Set Tile: I, SIZE 4B, Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0, MIRROR S, MIRROR T, MASK S 4, MASK T 4
  Texture_Rectangle 176<<2,92<<2, 0, 112<<2,28<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle: XL 176.0, YL 92.0, Tile 0, XH 112.0, YH 28.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0

  Sync_Tile ; Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I|SIZE_OF_PIXEL_4B|(2<<9)|$000, (0<<24) ; Set Tile: I, SIZE 4B, Tile Line Size 2 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 176<<2,130<<2, 0, 144<<2,98<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle: XL 176.0, YL 130.0, Tile 0, XH 144.0, YH 98.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0

  Sync_Tile ; Sync Tile
  Texture_Rectangle_Flip 176<<2,200<<2, 0, 144<<2,168<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle Flip: XL 176.0, YL 200.0, Tile 0, XH 144.0, YH 168.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0


  Sync_Tile ; Sync Tile
  Set_Texture_Image SIZE_OF_PIXEL_16B|(16-1), $00200280 ; Set Texture Image: SIZE 16B, WIDTH 16, DRAM ADDRESS $00200280
  Set_Tile SIZE_OF_PIXEL_16B|(4<<9)|$000, 0<<24 ; Set Tile: SIZE 16B, Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0
  Load_Tile 0<<2,0<<2, 0, 63<<2,63<<2 ; Load Tile: SL 0.0, TL 0.0, Tile 0, SH 63.0, TH 63.0
  Sync_Tile ; Sync Tile
  Set_Tile IMAGE_DATA_FORMAT_I|SIZE_OF_PIXEL_4B|(4<<9)|$000, (0<<24) ; Set Tile: I, SIZE 4B, Tile Line Size 4 (64bit Words), TMEM Address $000, Tile 0
  Texture_Rectangle 292<<2,130<<2, 0, 228<<2,66<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle: XL 292.0, YL 130.0, Tile 0, XH 228.0, YH 66.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0

  Sync_Tile ; Sync Tile
  Texture_Rectangle_Flip 292<<2,200<<2, 0, 228<<2,136<<2, 0<<5,0<<5, 1<<10,1<<10 ; Texture Rectangle Flip: XL 292.0, YL 200.0, Tile 0, XH 228.0, YH 136.0, S 0.0, T 0.0, DSDX 1.0, DTDY 1.0

  Sync_Full ; Ensure Entire Scene Is Fully Drawn
RDPBufferEnd:

Texture:
  db $EE,$00,$00,$08,$80,$00,$00,$00 // 16x16x4B = 128 Bytes
  db $EE,$00,$00,$8F,$F8,$00,$00,$00
  db $00,$00,$08,$FF,$FF,$80,$00,$00
  db $00,$00,$8F,$FF,$FF,$F8,$00,$00
  db $00,$08,$FF,$FF,$FF,$FF,$80,$00
  db $00,$8F,$FF,$FF,$FF,$FF,$F8,$00
  db $08,$FF,$FF,$FF,$FF,$FF,$FF,$80
  db $8F,$FF,$FF,$FF,$FF,$FF,$FF,$F8
  db $8F,$FF,$FF,$FF,$FF,$FF,$FF,$F8
  db $88,$88,$88,$FF,$FF,$88,$88,$88
  db $00,$00,$08,$FF,$FF,$80,$00,$00
  db $00,$00,$08,$FF,$FF,$80,$00,$00
  db $00,$00,$08,$FF,$FF,$80,$00,$00
  db $00,$00,$08,$FF,$FF,$80,$00,$00
  db $00,$00,$08,$FF,$FF,$80,$00,$00
  db $00,$00,$08,$88,$88,$80,$00,$00

  db $EE,$EE,$00,$00,$00,$00,$00,$08,$80,$00,$00,$00,$00,$00,$00,$00 // 32x32x4B = 512 Bytes
  db $EE,$EE,$00,$00,$00,$00,$00,$8F,$F8,$00,$00,$00,$00,$00,$00,$00
  db $EE,$EE,$00,$00,$00,$00,$08,$FF,$FF,$80,$00,$00,$00,$00,$00,$00
  db $EE,$EE,$00,$00,$00,$00,$8F,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00
  db $00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00
  db $00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00
  db $00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00
  db $00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00
  db $00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00
  db $00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00
  db $00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00
  db $08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80
  db $8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8
  db $8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8
  db $88,$88,$88,$88,$88,$88,$FF,$FF,$FF,$FF,$88,$88,$88,$88,$88,$88
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$88,$88,$88,$88,$80,$00,$00,$00,$00,$00

  db $EE,$EE,$EE,$EE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 // 64x64x4B = 2048 Bytes
  db $EE,$EE,$EE,$EE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$8F,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
  db $EE,$EE,$EE,$EE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
  db $EE,$EE,$EE,$EE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$8F,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
  db $EE,$EE,$EE,$EE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $EE,$EE,$EE,$EE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $EE,$EE,$EE,$EE,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $EE,$EE,$EE,$EE,$00,$00,$00,$00,$00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00
  db $00,$00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00,$00
  db $00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00
  db $00,$00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00,$00
  db $00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00
  db $00,$00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00,$00
  db $00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00
  db $00,$8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8,$00
  db $08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80
  db $8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8
  db $8F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F8
  db $88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$88,$88,$88,$88,$88,$88,$88,$88,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
TextureEnd: