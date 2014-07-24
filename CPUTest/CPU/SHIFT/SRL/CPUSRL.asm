; N64 'Bare Metal' CPU Word Shift Right Logical (0..31) Test Demo by krom (Peter Lemon):

PrintString: macro vram,xpos,ypos,fontfile,string,length ; Print Text String To VRAM Using Font At X,Y Position
  lui t0,vram ; T0 = Frame Buffer Pointer
  addi t0,((xpos*4)+((640*ypos)*4)) ; Place text at XY Position
  la t1,fontfile ; T1 = Characters
  la t2,string ; T2 = Text Offset
  li t3,length ; T3 = Number of Text Characters to Print
  DrawChars\@:
    li t4,7 ; T4 = Character X Pixel Counter
    li t5,7 ; T5 = Character Y Pixel Counter

    lb t6,0(t2) ; T6 = Next Text Character
    addi t2,1

    sll t6,8 ; Add Shift to Correct Position in Font (* 256)
    add t6,t1

    DrawCharX\@:
      lw t7,0(t6) ; Load Font Text Character Pixel
      addi t6,4
      sw t7,0(t0) ; Store Font Text Character Pixel into Frame Buffer
      addi t0,4

      bnez t4,DrawCharX\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t4,1 ; Decrement Character X Pixel Counter

      addi t0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t4,7 ; Reset Character X Pixel Counter
      bnez t5,DrawCharX\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t5,1 ; Decrement Character Y Pixel Counter

    subi t0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4
    bnez t3,DrawChars\@ ; Continue to Print Characters
    subi t3,1 ; Subtract Number of Text Characters to Print
    endm

PrintValue: macro vram,xpos,ypos,fontfile,value,length ; Print HEX Chars To VRAM Using Font At X,Y Position
  lui t0,vram ; T0 = Frame Buffer Pointer
  addi t0,((xpos*4)+((640*ypos)*4)) ; Place text at XY Position
  la t1,fontfile ; T1 = Characters
  la t2,value ; T2 = Value Offset
  li t3,length ; T3 = Number of HEX Chars to Print
  DrawHEXChars\@:
    li t4,7 ; T4 = Character X Pixel Counter
    li t5,7 ; T5 = Character Y Pixel Counter

    lb t6,0(t2) ; T6 = Next 2 HEX Chars
    addi t2,1

    srl t7,t6,4 ; T7 = 2nd Nibble
    andi t7,$F
    subi t8,t7,9
    bgtz t8,HEXLetters\@
    addi t7,$30 ; Delay Slot
    j HEXEnd\@
    nop ; Delay Slot

    HEXLetters\@:
    addi t7,7
    HEXEnd\@:

    sll t7,8 ; Add Shift to Correct Position in Font (* 256)
    add t7,t1

    DrawHEXCharX\@:
      lw t8,0(t7) ; Load Font Text Character Pixel
      addi t7,4
      sw t8,0(t0) ; Store Font Text Character Pixel into Frame Buffer
      addi t0,4

      bnez t4,DrawHEXCharX\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t4,1 ; Decrement Character X Pixel Counter

      addi t0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t4,7 ; Reset Character X Pixel Counter
      bnez t5,DrawHEXCharX\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t5,1 ; Decrement Character Y Pixel Counter

    subi t0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4

    li t5,7 ; Reset Character Y Pixel Counter

    andi t7,t6,$F ; T7 = 1st Nibble
    subi t8,t7,9
    bgtz t8,HEXLettersB\@
    addi t7,$30 ; Delay Slot
    j HEXEndB\@
    nop ; Delay Slot

    HEXLettersB\@:
    addi t7,7
    HEXEndB\@:

    sll t7,8 ; Add Shift to Correct Position in Font (* 256)
    add t7,t1

    DrawHEXCharXB\@:
      lw t8,0(t7) ; Load Font Text Character Pixel
      addi t7,4
      sw t8,0(t0) ; Store Font Text Character Pixel into Frame Buffer
      addi t0,4

      bnez t4,DrawHEXCharXB\@ ; IF Character X Pixel Counter != 0 GOTO DrawCharX
      subi t4,1 ; Decrement Character X Pixel Counter

      addi t0,$9E0 ; Jump down 1 Scanline, Jump back 1 Char ((SCREEN_X * 4) - (CHAR_X * 4))
      li t4,7 ; Reset Character X Pixel Counter
      bnez t5,DrawHEXCharXB\@ ; IF Character Y Pixel Counter != 0 GOTO DrawCharX
      subi t5,1 ; Decrement Character Y Pixel Counter

    subi t0,$4FE0 ; ((SCREEN_X * 4) * CHAR_Y) - CHAR_X * 4

    bnez t3,DrawHEXChars\@ ; Continue to Print Characters
    subi t3,1 ; Subtract Number of Text Characters to Print
    endm

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros

  ScreenNTSC 640,480, BPP32|INTERLACE|AA_MODE_2, $A0100000 ; Screen NTSC: 640x480, 32BPP, Interlace, Reample Only, DRAM Origin = $A0100000

  lui t0,$A010 ; T0 = VRAM Start Offset
  addi t1,t0,((640*480*4)-4) ; T1 = VRAM End Offset
  li t2,$000000FF ; T2 = Black
ClearScreen:
  sw t2,0(t0)
  bne t0,t1,ClearScreen
  addi t0,4 ; Delay Slot




  PrintString $A010,88,8,FontRed,RTHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,232,8,FontRed,SADEC,11 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,384,8,FontRed,RDHEX,7 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,528,8,FontRed,TEST,10 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,0,16,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  PrintString $A010,8,24,FontRed,SRL,2 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,0 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,24,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,24,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,24,FontBlack,TEXTWORD0,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,24,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,24,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SRLCHECK0 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SRLPASS0 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,24,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND0
  nop ; Delay Slot
  SRLPASS0:
  PrintString $A010,528,24,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND0:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,1 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,32,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,32,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,32,FontBlack,TEXTWORD1,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,32,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,32,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SRLCHECK1 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SRLPASS1 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,32,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND1
  nop ; Delay Slot
  SRLPASS1:
  PrintString $A010,528,32,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND1:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,2 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,40,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,40,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,40,FontBlack,TEXTWORD2,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,40,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,40,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SRLCHECK2 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SRLPASS2 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,40,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND2
  nop ; Delay Slot
  SRLPASS2:
  PrintString $A010,528,40,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND2:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,3 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,48,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,48,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,48,FontBlack,TEXTWORD3,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,48,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,48,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SRLCHECK3 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SRLPASS3 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,48,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND3
  nop ; Delay Slot
  SRLPASS3:
  PrintString $A010,528,48,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND3:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,4 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,56,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,56,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,56,FontBlack,TEXTWORD4,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,56,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,56,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SRLCHECK4 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SRLPASS4 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,56,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND4
  nop ; Delay Slot
  SRLPASS4:
  PrintString $A010,528,56,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND4:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,5 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,64,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,64,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,64,FontBlack,TEXTWORD5,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,64,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,64,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SRLCHECK5 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SRLPASS5 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,64,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND5
  nop ; Delay Slot
  SRLPASS5:
  PrintString $A010,528,64,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND5:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,6 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,72,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,72,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,72,FontBlack,TEXTWORD6,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,72,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,72,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SRLCHECK6 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SRLPASS6 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,72,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND6
  nop ; Delay Slot
  SRLPASS6:
  PrintString $A010,528,72,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND6:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,7 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,80,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,80,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,80,FontBlack,TEXTWORD7,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,80,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,80,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SRLCHECK7 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SRLPASS7 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,80,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND7
  nop ; Delay Slot
  SRLPASS7:
  PrintString $A010,528,80,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND7:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,8 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,88,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,88,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,88,FontBlack,TEXTWORD8,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,88,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,88,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SRLCHECK8 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SRLPASS8 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,88,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND8
  nop ; Delay Slot
  SRLPASS8:
  PrintString $A010,528,88,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND8:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,9 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,96,FontBlack,DOLLAR,0     ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,96,FontBlack,VALUEWORD,3  ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,360,96,FontBlack,TEXTWORD9,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,96,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,96,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD    ; T0 = Word Data Offset
  lw t1,0(t0)     ; T1 = Word Data
  la t0,SRLCHECK9 ; T0 = Word Check Data Offset
  lw t2,0(t0)     ; T2 = Word Check Data
  beq t1,t2,SRLPASS9 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,96,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND9
  nop ; Delay Slot
  SRLPASS9:
  PrintString $A010,528,96,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND9:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,10 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,104,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,104,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,104,FontBlack,TEXTWORD10,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,104,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,104,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK10 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS10 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,104,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND10
  nop ; Delay Slot
  SRLPASS10:
  PrintString $A010,528,104,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND10:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,11 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,112,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,112,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,112,FontBlack,TEXTWORD11,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,112,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,112,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK11 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS11 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,112,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND11
  nop ; Delay Slot
  SRLPASS11:
  PrintString $A010,528,112,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND11:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,12 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,120,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,120,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,120,FontBlack,TEXTWORD12,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,120,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,120,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK12 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS12 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,120,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND12
  nop ; Delay Slot
  SRLPASS12:
  PrintString $A010,528,120,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND12:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,13 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,128,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,128,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,128,FontBlack,TEXTWORD13,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,128,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,128,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK13 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS13 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,128,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND13
  nop ; Delay Slot
  SRLPASS13:
  PrintString $A010,528,128,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND13:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,14 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,136,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,136,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,136,FontBlack,TEXTWORD14,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,136,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,136,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK14 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS14 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,136,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND14
  nop ; Delay Slot
  SRLPASS14:
  PrintString $A010,528,136,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND14:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,15 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,144,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,144,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,144,FontBlack,TEXTWORD15,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,144,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,144,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK15 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS15 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,144,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND15
  nop ; Delay Slot
  SRLPASS15:
  PrintString $A010,528,144,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND15:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,16 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,152,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,152,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,152,FontBlack,TEXTWORD16,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,152,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,152,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK16 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS16 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,152,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND16
  nop ; Delay Slot
  SRLPASS16:
  PrintString $A010,528,152,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND16:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,17 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,160,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,160,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,160,FontBlack,TEXTWORD17,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,160,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,160,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK17 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS17 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,160,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND17
  nop ; Delay Slot
  SRLPASS17:
  PrintString $A010,528,160,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND17:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,18 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,168,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,168,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,168,FontBlack,TEXTWORD18,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,168,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,168,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK18 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS18 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,168,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND18
  nop ; Delay Slot
  SRLPASS18:
  PrintString $A010,528,168,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND18:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,19 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,176,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,176,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,176,FontBlack,TEXTWORD19,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,176,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,176,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK19 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS19 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,176,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND19
  nop ; Delay Slot
  SRLPASS19:
  PrintString $A010,528,176,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND19:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,20 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,184,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,184,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,184,FontBlack,TEXTWORD20,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,184,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,184,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK20 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS20 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,184,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND20
  nop ; Delay Slot
  SRLPASS20:
  PrintString $A010,528,184,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND20:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,21 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,192,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,192,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,192,FontBlack,TEXTWORD21,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,192,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,192,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK21 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS21 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,192,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND21
  nop ; Delay Slot
  SRLPASS21:
  PrintString $A010,528,192,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND21:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,22 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,200,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,200,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,200,FontBlack,TEXTWORD22,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,200,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,200,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK22 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS22 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,200,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND22
  nop ; Delay Slot
  SRLPASS22:
  PrintString $A010,528,200,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND22:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,23 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,208,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,208,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,208,FontBlack,TEXTWORD23,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,208,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,208,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK23 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS23 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,208,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND23
  nop ; Delay Slot
  SRLPASS23:
  PrintString $A010,528,208,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND23:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,24 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,216,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,216,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,216,FontBlack,TEXTWORD24,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,216,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,216,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK24 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS24 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,216,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND24
  nop ; Delay Slot
  SRLPASS24:
  PrintString $A010,528,216,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND24:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,25 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,224,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,224,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,224,FontBlack,TEXTWORD25,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,224,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,224,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK25 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS25 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,224,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND25
  nop ; Delay Slot
  SRLPASS25:
  PrintString $A010,528,224,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND25:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,26 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,232,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,232,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,232,FontBlack,TEXTWORD26,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,232,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,232,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK26 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS26 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,232,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND26
  nop ; Delay Slot
  SRLPASS26:
  PrintString $A010,528,232,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND26:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,27 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,240,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,240,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,240,FontBlack,TEXTWORD27,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,240,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,240,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK27 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS27 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,240,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND27
  nop ; Delay Slot
  SRLPASS27:
  PrintString $A010,528,240,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND27:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,28 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,248,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,248,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,248,FontBlack,TEXTWORD28,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,248,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,248,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK28 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS28 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,248,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND28
  nop ; Delay Slot
  SRLPASS28:
  PrintString $A010,528,248,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND28:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,29 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,256,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,256,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,256,FontBlack,TEXTWORD29,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,256,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,256,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK29 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS29 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,256,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND29
  nop ; Delay Slot
  SRLPASS29:
  PrintString $A010,528,256,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND29:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,30 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,264,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,264,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,264,FontBlack,TEXTWORD30,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,264,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,264,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK30 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS30 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,264,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND30
  nop ; Delay Slot
  SRLPASS30:
  PrintString $A010,528,264,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND30:

  la t0,VALUEWORD ; T0 = Word Data Offset
  lw t0,0(t0)     ; T0 = Word Data
  srl t0,31 ; T0 = Test Word Data
  la t1,RDWORD ; T1 = RDWORD Offset
  sw t0,0(t1)  ; RDWORD = Word Data
  PrintString $A010,80,272,FontBlack,DOLLAR,0      ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,88,272,FontBlack,VALUEWORD,3   ; Print HEX Chars To VRAM Using Font At X,Y Position
  PrintString $A010,352,272,FontBlack,TEXTWORD31,1 ; Print Text String To VRAM Using Font At X,Y Position
  PrintString $A010,376,272,FontBlack,DOLLAR,0 ; Print Text String To VRAM Using Font At X,Y Position
  PrintValue  $A010,384,272,FontBlack,RDWORD,3 ; Print Text String To VRAM Using Font At X,Y Position
  la t0,RDWORD     ; T0 = Word Data Offset
  lw t1,0(t0)      ; T1 = Word Data
  la t0,SRLCHECK31 ; T0 = Word Check Data Offset
  lw t2,0(t0)      ; T2 = Word Check Data
  beq t1,t2,SRLPASS31 ; Compare Result Equality With Check Data
  nop ; Delay Slot
  PrintString $A010,528,272,FontRed,FAIL,3 ; Print Text String To VRAM Using Font At X,Y Position
  j SRLEND31
  nop ; Delay Slot
  SRLPASS31:
  PrintString $A010,528,272,FontGreen,PASS,3 ; Print Text String To VRAM Using Font At X,Y Position
  SRLEND31:


  PrintString $A010,0,280,FontBlack,PAGEBREAK,79 ; Print Text String To VRAM Using Font At X,Y Position


  lui t0,VI_BASE ; Load VI Base Register
Loop:
  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $202

  li t1,$00000800 ; Even Field
  sw t1,VI_Y_SCALE(t0)

  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank
  WaitScanline $202

  li t1,$02000800 ; Odd Field
  sw t1,VI_Y_SCALE(t0)

  j Loop
  nop ; Delay Slot

SRL: db "SRL"

RDHEX: db "RD (Hex)"
RTHEX: db "RT (Hex)"
SADEC: db "SA (Decimal)"
TEST: db "Test Result"
FAIL: db "FAIL"
PASS: db "PASS"

DOLLAR: db "$"

TEXTWORD0: db "0"
TEXTWORD1: db "1"
TEXTWORD2: db "2"
TEXTWORD3: db "3"
TEXTWORD4: db "4"
TEXTWORD5: db "5"
TEXTWORD6: db "6"
TEXTWORD7: db "7"
TEXTWORD8: db "8"
TEXTWORD9: db "9"
TEXTWORD10: db "10"
TEXTWORD11: db "11"
TEXTWORD12: db "12"
TEXTWORD13: db "13"
TEXTWORD14: db "14"
TEXTWORD15: db "15"
TEXTWORD16: db "16"
TEXTWORD17: db "17"
TEXTWORD18: db "18"
TEXTWORD19: db "19"
TEXTWORD20: db "20"
TEXTWORD21: db "21"
TEXTWORD22: db "22"
TEXTWORD23: db "23"
TEXTWORD24: db "24"
TEXTWORD25: db "25"
TEXTWORD26: db "26"
TEXTWORD27: db "27"
TEXTWORD28: db "28"
TEXTWORD29: db "29"
TEXTWORD30: db "30"
TEXTWORD31: db "31"

PAGEBREAK: db "--------------------------------------------------------------------------------"

  align 8 ; Align 64-bit
VALUEWORD: dw -123456789

SRLCHECK0:  dw $F8A432EB
SRLCHECK1:  dw $7C521975
SRLCHECK2:  dw $3E290CBA
SRLCHECK3:  dw $1F14865D
SRLCHECK4:  dw $0F8A432E
SRLCHECK5:  dw $07C52197
SRLCHECK6:  dw $03E290CB
SRLCHECK7:  dw $01F14865
SRLCHECK8:  dw $00F8A432
SRLCHECK9:  dw $007C5219
SRLCHECK10: dw $003E290C
SRLCHECK11: dw $001F1486
SRLCHECK12: dw $000F8A43
SRLCHECK13: dw $0007C521
SRLCHECK14: dw $0003E290
SRLCHECK15: dw $0001F148
SRLCHECK16: dw $0000F8A4
SRLCHECK17: dw $00007C52
SRLCHECK18: dw $00003E29
SRLCHECK19: dw $00001F14
SRLCHECK20: dw $00000F8A
SRLCHECK21: dw $000007C5
SRLCHECK22: dw $000003E2
SRLCHECK23: dw $000001F1
SRLCHECK24: dw $000000F8
SRLCHECK25: dw $0000007C
SRLCHECK26: dw $0000003E
SRLCHECK27: dw $0000001F
SRLCHECK28: dw $0000000F
SRLCHECK29: dw $00000007
SRLCHECK30: dw $00000003
SRLCHECK31: dw $00000001

RDWORD: dw 0

FontBlack: incbin FontBlack8x8.bin
FontGreen: incbin FontGreen8x8.bin
FontRed: incbin FontRed8x8.bin