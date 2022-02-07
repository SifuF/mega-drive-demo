;Mega Drive project by SifuF 17/07/21

;-----------------------------------------------------------------------------------------------
;	68k Memory map
;-----------------------------------------------------------------------------------------------

;$000000 	$3FFFFF 	Cartridge ROM/RAM
;$400000 	$7FFFFF 	Reserved (used by the Sega CD and 32x)
;$800000 	$9FFFFF 	Reserved (used by the 32x?)
;$A00000 	$A0FFFF 	Z80 addressing space
	;$A00000 	$A01FFF 	Sound Ram				;Halt Z80 before 68k access A00000 to A0FFFF
	;$A02000 	$A03FFF 	Reserved				;
	;$A04000 				YM2612 A0				;
	;$A04001 				YM2612 D0				;
	;$A04002 				YM2612 A1				;
	;$A04003 				YM2612 D1				;
	;$A04000 	$A05FFF 	Sound Chip				;
	;$A06000 				Bank Register			;
	;$A06000 	$A07F10 	Misc					;
	;$A07F11 				PSG 76489				;
	;$A07F12 	$A07FFF 	Misc					;	
	;$A08000 	$A0FFFF 	68000 Bank				;
;$A10000 	$A10001 	Version register (read-only word-long)
;$A10002 	$A10003 	Controller 1 data
;$A10004 	$A10005 	Controller 2 data
;$A10006 	$A10007 	Expansion port data
;$A10008 	$A10009 	Controller 1 control
;$A1000A 	$A1000B 	Controller 2 control
;$A1000C 	$A1000D 	Expansion port control
;$A1000E 	$A1000F 	Controller 1 serial transmit
;$A10010 	$A10011 	Controller 1 serial receive
;$A10012 	$A10013 	Controller 1 serial control
;$A10014 	$A10015 	Controller 2 serial transmit
;$A10016 	$A10017 	Controller 2 serial receive
;$A10018 	$A10019 	Controller 2 serial control
;$A1001A 	$A1001B 	Expansion port serial transmit
;$A1001C 	$A1001D 	Expansion port serial receive
;$A1001E 	$A1001F 	Expansion port serial control
;$A10020 	$A10FFF 	Reserved
;$A11000 				Memory mode register
;$A11002 	$A110FF 	Reserved
;$A11100 	$A11101 	Z80 bus request
;$A11102 	$A111FF 	Reserved
;$A11200 	$A11201 	Z80 reset
;$A11202 	$A13FFF 	Reserved
;$A14000 	$A14003 	TMSS register
;$A14004 	$BFFFFF 	Reserved
;$C00000 				VDP Data Port
;$C00002 				VDP Data Port (Mirror)
;$C00004 				VDP Control Port
;$C00006 				VDP Control Port (Mirror)
;$C00008 				H/V Counter
;$C0000A 				H/V Counter (Mirror)
;$C0000C 				H/V Counter (Mirror)
;$C0000E 				H/V Counter (Mirror)
;$C00011 				SN76489 PSG
;$C00013 				SN76489 PSG (Mirror)
;$C00015 				SN76489 PSG (Mirror)
;$C00017 				SN76489 PSG (Mirror)
;$C0001C 				Disable/Debug register
;$C0001E 				Disable/Debug register (Mirror)
;$C0001E 	$FEFFFF 	Reserved
;$FF0000 	$FFFFFF 	68000 RAM 

;------------------------------------------------------------------------------
;	z80 Memory map
;------------------------------------------------------------------------------

;$0000 	$1FFF 	Sound Ram
;$2000 	$3FFF 	Reserved
;$4000 			YM2612 A0
;$4001 			YM2612 D0
;$4002 			YM2612 A1
;$4003 			YM2612 D1
;$4000 	$5FFF 	Sound Chip
;$6000 			Bank Register
;$6000 	$7F10 	Misc
;$7F11 			PSG 76489
;$7F12 	$7FFF 	Misc
;$8000 	$FFFF 	68000 Bank

;------------------------------------------------------------------------------
;	Equates
;------------------------------------------------------------------------------

VDPData equ $C00000
VDPCtrl equ $C00004
VRAMWCtrl equ $40000000

;------------------------------------------------------------------------------
;	68k Vector table	$000000 - $0000FF
;------------------------------------------------------------------------------

	org		$00000000
	dc.l	$00FFFE00	;0 Reset SP										$000000 
	dc.l	START		;1 Reset PC										$000004 
	dc.l	INTR		;2 Bus error									$000008 
	dc.l	INTR		;3 Address error								$00000C 
	dc.l	INTR		;4 Illegal instruction							$000010 
	dc.l	INTR		;5 Division by zero								$000014 
	dc.l	INTR		;6 CHK instruction								$000018 
	dc.l	INTR		;7 TRAPV instruction							$00001C 
	dc.l	INTR		;8 Privilege violation							$000020 
	dc.l	INTR		;9 Trace										$000024 
	dc.l	INTR		;10 											$000028
	dc.l	INTR		;11 											$00002C
	dc.l	INTR		;12 											$000030 
	dc.l	INTR		;13 											$000034 
	dc.l	INTR		;14 Reserved									$000038 
	dc.l	INTR		;15 Uninitialised interrupt						$00003C 
	dc.l	INTR		;16 Reserved									$000040 
	dc.l	INTR		;17 Reserved									$000044 
	dc.l	INTR		;18 Reserved									$000048 
	dc.l	INTR		;19 Reserved									$00004C 
	dc.l	INTR		;20 Reserved									$000050 
	dc.l	INTR		;21 Reserved									$000054 
	dc.l	INTR		;22 Reserved									$000058 
	dc.l	INTR		;23 Reserved									$00005C 
	dc.l	INTR		;24 Spurious interrupt 							$000060 
	dc.l	INTR		;25 IRQ Level 1									$000064 
	dc.l	INTR		;26 IRQ Level 2 EXT interrupt 					$000068 
	dc.l	INTR		;27 IRQ Level 3									$00006C 
	dc.l	HSYNC		;28 IRQ Level 4 Horizontal VDP interrupt		$000070 
	dc.l	INTR		;29 IRQ Level 5									$000074 
	dc.l	VSYNC		;30 IRQ Level 6 Vertical VDP interrupt			$000078 
	dc.l	INTR		;31 IRQ Level 7									$00007C 
	dc.l	INTR		;32 TRAP #00									$000080
	dc.l	INTR		;33 TRAP #01									$000084
	dc.l	INTR		;34 TRAP #02									$000088
	dc.l	INTR		;35 TRAP #03									$00008C
	dc.l	INTR		;36 TRAP #04									$000090
	dc.l	INTR		;37 TRAP #05									$000094
	dc.l	INTR		;38 TRAP #06									$000098
	dc.l	INTR		;39 TRAP #07									$00009C
	dc.l	INTR		;40 TRAP #08									$0000A0
	dc.l	INTR		;41 TRAP #09									$0000A4
	dc.l	INTR		;42 TRAP #10									$0000A8
	dc.l	INTR		;43 TRAP #11									$0000AC
	dc.l	INTR		;44 TRAP #12									$0000B0
	dc.l	INTR		;45 TRAP #13									$0000B4
	dc.l	INTR		;46 TRAP #14									$0000B8
	dc.l	INTR		;47 TRAP #15									$0000BC
	dc.l	INTR		;48 (FP) Branch or set on unordered condition	$0000C0
	dc.l	INTR		;49 (FP) Inexact result							$0000C4
	dc.l	INTR		;50 (FP) Divide by zero							$0000C8
	dc.l	INTR		;51 (FP) Underflow								$0000CC
	dc.l	INTR		;52 (FP) Operand error							$0000D0
	dc.l	INTR		;53 (FP) Overflow								$0000D4
	dc.l	INTR		;54 (FP) Signaling NAN							$0000D8
	dc.l	INTR		;55 (FP) Unimplimented data type				$0000DC
	dc.l	INTR		;56 MMU Configuration error						$0000E0
	dc.l	INTR		;57 MMU Illegal operation error					$0000E4
	dc.l	INTR		;58 MMU Access violation error					$0000E8
	dc.l 	INTR		;59 Reserved									$0000EC
	dc.l 	INTR		;60 Reserved									$0000F0
	dc.l 	INTR		;61 Reserved									$0000F4
	dc.l 	INTR		;62 Reserved									$0000F8
	dc.l 	INTR		;63 Reserved									$0000FC
	
;--------------------------------------------------------------------------------------------------
;	ROM Cartridge header	$0000FF - $0001FF
;--------------------------------------------------------------------------------------------------

	dc.b	"SEGA MEGA DRIVE "									;Console name (16)			$000100
	dc.b	"(C)SIFU 2021.JUL"									;Copyright information (16)	$000110
	dc.b	"MY PROG                                         "	;Domestic name (48)			$000120
	dc.b	"MY PROG                                         "	;Overseas name (48)			$000150
	dc.b	"GM 00000000-00"									;Serial number (14)			$000180
	dc.w	$0000												;Checksum (2)				$00018E
	dc.b	"JD              "									;I/O Support (16)			$000190
	dc.l	$00000000											;ROM start address (4)		$0001A0
	dc.l	$003FFFFF											;ROM end address (4)		$0001A4
	dc.l	$00FF0000											;Backup RAM start (4)		$0001A8
	dc.l	$00FFFFFF											;Backup RAM end (4)			$0001AC
	dc.b	"            "										;Backup RAM support (12)	$0001B0
	dc.b	"            "										;Modem support (12)			$0001BC
	dc.b	"                                        "			;Memo (40)		`			$0001C8
	dc.b	"JUE             "									;Country support (16)		$0001F0

;--------------------------------------------------------------------------------------------------
;	Exception handlers	$000200
;--------------------------------------------------------------------------------------------------
	
INTR
	rte

HSYNC
	rte
	
VSYNC
	
	
	;move.l #$C0020000,d0					;Color 1
	;move.l d0,VDPCtrl
	;move.w #%0000000011101110,VDPData	
	
	move.w	%0000011100000000,sr	;Enable interrupts on 68k
	
	jmp MAINLOOP
	rte
	
;------------------------------------------------------------------------------------------------------------------------------------------------------------
;	VDP registers
;------------------------------------------------------------------------------------------------------------------------------------------------------------

VDPREG	
	dc.b	%00010100	;0 Mode set reg.1 									0 		0 		0 		IE1 	0		1 		M3		0			
	dc.b	%01100100	;1 Mode ser reg.2									0 		DISP	IE0 	M1 		M2		1 		0		0
	dc.b	%00110000	;2 Pattern name table base address for Scroll A		0 		0 		SA15 	SA14 	SA13 	0 		0		0					$C000
	dc.b	%00111100	;3 Pattern name table base address for Window		0 		0		WD15 	WD14 	WD13 	WD12	WD11	0					$F000
	dc.b	%00000111	;4 Pattern name table base address for Scroll B		0		0		0		0		0		SB15	SB14	SB13				$E000
	dc.b	%01101100	;5 Sprite attribute table base address				0 		AT15	AT14	AT13	AT12	AT11	AT10	AT9					$D800 
	dc.b	%00000000	;6 Unused											0		0		0		0		0		0		0		0	
	dc.b	%00000000	;7 Background colour								0		0		CP1		CP0		COL3	COL2	COL1	COL0
	dc.b	%00000000	;8 Unused											0		0		0		0		0		0		0		0
	dc.b	%00000000	;9 Unused											0		0		0		0		0		0		0		0	
	dc.b	%00000000	;10 H Interrupt register							BIT7	BIT6	BIT5	BIT4	BIT3	BIT2	BIT1	BIT0	
	dc.b	%00001000	;11 Mode set reg.3									0		0		0		0		IE2		VSCR	HSCR	LSCR
	dc.b	%10000001	;12 Mode set reg.4									RS0		0		0		0		S/TE	LSM1	LSM0	RS1
	dc.b	%00110111	;13 H Scroll data table base address				0		0		HS15	HS14	HS13	HS12	HS11	HS10				$FC00
	dc.b	%00000000	;14 Unused											0		0		0		0		0		0		0		0	
	dc.b	%00000010	;15 Auto increment data								INC7	INC6	INC5	INC4	INC3	INC2	INC1	INC0
	dc.b	%00000001	;16 Scroll size										0		0		VSZ1	VSZ0	0		0		HSZ1	HSZ0
	dc.b	%00000000	;17 Window H position								RIGT	0		0		WHP5	WHP4	WHP3	WHP2	WHP1
	dc.b	%00000000	;18 Window V position								DOWN	0		0		WVP4	WVP3	WVP2	WVP1	WVP0
	dc.b	%00000000	;19 DMA length counter low							LG7		LG6		LG5		LG4		LG3		LG2		LG1		LG0
	dc.b	%00000000	;20 DMA length counter high							LG15	LG14	LG13	LG12	LG11	LG10	LG9		LG8
	dc.b	%00000000	;21 DMA source address low							SA8 	SA7	 	SA6 	SA5 	SA4 	SA3 	SA2 	SA1
	dc.b	%00000000	;22 DMA source address mid							SA16 	SA15	SA14 	SA13 	SA12 	SA11 	SA10 	SA9
	dc.b	%00000000	;23 DMA source address high							DMD1 	DMD0 	SA22 	SA21 	SA20 	SA19 	SA18 	SA17 

;------------------------------------------------------------------------------------------------------------------------------------------------------------
;	Graphics
;------------------------------------------------------------------------------------------------------------------------------------------------------------

TESTLETTER	
	dc.l	$10000010
	dc.l	$01000100
	dc.l	$00101000
	dc.l	$00010000
	dc.l	$00101000
	dc.l	$01000100
	dc.l	$10000010
	dc.l	$00000000		

	INCLUDE	Fonts.asm
	INCLUDE	Patterns.asm		
	
SPRITEY
	incbin "Han.RAW"
SPRITEY_END
	
;--------------------------------------------------------------------------------------------------
;	Main entry point
;--------------------------------------------------------------------------------------------------	
	
START

	
	
	move.b	($A10001),d0			;TMSS
	andi.b	#$0F,d0
	beq		NOTMSS
	move.l	#"SEGA",($A14000)

NOTMSS
	
	lea VDPREG,a0
	move.w (VDPCtrl),d0		;Read $C00004 = Status register
	move.l #$00008000,d1
	moveq.l #24-1,d2		;Loop counter for 24 registers
NextVDPSetting	
	move.b (a0)+,d1			;000080aa 	000081bb	000082cc
	move.w d1,(VDPCtrl)		
	add.l #$00000100,d1		;000081aa 	000082bb	000083cc
	dbra d2,NextVDPSetting
	
	;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	;	VRAM addressing (64k: $0000 - $FFFF)
	;----------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	;Layout is configurable. Using:
	;$0000 	Pattern definitions
	;$C000 	Scroll A Tilemap (8kb)
	;$D800 	Sprite Attrib table			0	1	0	1	1	0	0	0	0	0	0	0	0	0	0	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1
	;$E000 	Scroll B Tilemap (8kb)
	;$F000 	Window Map
	;$FC00 	Hscroll Table (1kb)
	;									VRAM Write	CD1=0, CD0=1, CD2=CD3=CD4=CD5=0		(for VRAM Read	CD0=CD1=CD2=CD3=CD4=CD5=0)
	;Access via VDP						First Word															Second Word
	;address	;VDP command			CD1	CD0	A13	A12	A11	A10	A9	A8	A7	A6	A5	A4	A3	A2	A1	A0		0	0	0	0	0	0	0	0	CD5	CD4	CD3	CD2	0	0	A15	A14 
	;$0000 		$40000000				0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	;$1000 		$50000000				0	1	0	1	0	0	0	0	0	0	0	0	0	0	0	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
	;$2000 		$60000000			
	;$3000 		$70000000
	;$4000 		$40000001
	;$5000 		$50000001
	;$6000 		$60000001
	;$7000 		$70000001
	;$8000 		$40000002
	;$9000 		$50000002
	;$A000 		$60000002
	;$B000 		$70000002
	;$C000 		$40000003
	;$D000 		$50000003
	;$E000 		$60000003
	;$F000 		$70000003
	;...		...
	;$FFFF 		$7FFF0003				0	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1		0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	
	;----------------------------------------------------------------------------------------------------------------------------------------------------------------------

	;Clear VRAM
	move.w	#($FFFF/2)-1,d0		;Iterating in words
	move.l	#$40000000,d1						
	move.l	d1,VDPCtrl
VRAMClrLoop
	move.w	#$0000,VDPData		;Fill with zeros (VDP reg15 auto-increment is on)
	dbra	d0,VRAMClrLoop
	
	;--------------------------------------------------------------------
	;	Color RAM addresses for palettes (special addresses, not in VRAM)
	;	64 x 9bit words		----BBB-GGG-RRR-
	;--------------------------------------------------------------------	
	;-----------Palette 0		Palette 1		Palette 2		Palette 3								CRAM Write	CD1=1, CD0=1, CD2=CD3=CD4=CD5=0		(for CRAM Read	CD3=1, CD0=CD1=CD2=CD4=CD5=0)
	;Color 0	$C0000000		$C0200000		$C0400000		$C0600000								First Word															Second Word
	;Color 1	$C0020000		$C0220000		$C0420000		$C0620000								CD1	CD0	A13	A12	A11	A10	A9	A8	A7	A6	A5	A4	A3	A2	A1	A0		0	0	0	0	0	0	0	0	CD5	CD4	CD3	CD2	0	0	A15	A14
	;Color 2	$C0040000		$C0240000		$C0440000		$C0640000			Pallet0,Color0		1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
	;Color 3	$C0060000		$C0260000		$C0460000		$C0660000			Pallet0,Color1		1	1	0	0	0	0	0	0	0	0	0	0	0	0	1	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	;Color 4	$C0080000		$C0280000		$C0480000		$C0680000			Pallet0,Color2		1	1	0	0	0	0	0	0	0	0	0	0	0	1	0	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	;Color 5	$C00A0000		$C02A0000		$C04A0000		$C06A0000			Pallet0,Color3		1	1	0	0	0	0	0	0	0	0	0	0	0	1	1	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	;Color 6	$C00C0000		$C02C0000		$C04C0000		$C06C0000					   ...
	;Color 7	$C00E0000		$C02E0000		$C04E0000		$C06E0000			Pallet3,Color15		1	1	0	0	0	0	0	0	0	1	1	1	1	1	1	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
	;Color 8	$C0100000		$C0300000		$C0500000		$C0700000
	;Color 9	$C0120000		$C0320000		$C0520000		$C0720000
	;Color 10	$C0140000		$C0340000		$C0540000		$C0740000
	;Color 11	$C0160000		$C0360000		$C0560000		$C0760000
	;Color 12	$C0180000		$C0380000		$C0580000		$C0780000
	;Color 13	$C01A0000		$C03A0000		$C05A0000		$C07A0000
	;Color 14	$C01C0000		$C03C0000		$C05C0000		$C07C0000
	;Color 15	$C01E0000		$C03E0000		$C05E0000		$C07E0000	
	;--------------------------------------------------------------------		
		
	;Define Palette 0
	move.l #$C0000000,d0					;Color 0			
	move.l d0,VDPCtrl
	move.w #%0000000000000000,VDPData		;----BBB-GGG-RRR-
	
	move.l #$C0020000,d0					;Color 1
	move.l d0,VDPCtrl
	move.w #%0000000000001110,VDPData		
	
	move.l #$C0040000,d0					;Color 2
	move.l d0,VDPCtrl
	move.w #%0000000011100000,VDPData		
	
	move.l #$C0060000,d0					;Color 3
	move.l d0,VDPCtrl
	move.w #%0000111000000000,VDPdata		
	
	move.l #$C0080000,d0					;Color 4
	move.l d0,VDPCtrl
	move.w #%0000111000001110,VDPdata		
	
	move.l #$C00A0000,d0					;Color 5
	move.l d0,VDPCtrl
	move.w #%0000111011100000,VDPdata		
	
	move.l #$C01E0000,d0					;Color 15
	move.l d0,VDPCtrl
	move.w #%0000111011101110,VDPdata		
	
	
	;---------------------------------------------------------------------------------------------
	;	VSRAM addresses for vertical scrolling (special addresses, not in VRAM)
	;	40 x 10bit words
	;
	;	To select a VSRAM address put the desired address in #$4xxx0010 and write to VDP_Ctrl port
	
	;										VSRAM Write	CD0=CD2=1, CD1=CD3=CD4=CD5=0		(for VSRAM Read	CD2=1,	CD0=CD1=CD3=CD4=CD5=0)
	;										First Word															Second Word
	;										CD1 CD0	A13	A12	A11	A10	A9	A8	A7	A6	A5	A4	A3	A2	A1	A0		0	0	0	0	0	0	0	0	CD5	CD4	CD3	CD2	0	0	A15	A14
	;	VSRAM0	ScrollA0	$40000010		0	1	0	0	0	0	0	0	0	0	0	0 	0	0	0	0 		0	0	0	0 	0	0	0	0 	0	0	0	1	0	0	0	0
	;	VSRAM1	ScrollB0	$40020010		0	1	0	0	0	0	0	0	0	0	0	0 	0	0	1	0 		0	0	0	0 	0	0	0	0 	0	0	0	1	0	0	0	0
	;	VSRAM2	ScrollA1	$40040010		0	1	0	0	0	0	0	0	0	0	0	0 	0	1	0	0 		0	0	0	0 	0	0	0	0 	0	0	0	1	0	0	0	0
	;	VSRAM3	ScrollB1	$40060010		0	1	0	0	0	0	0	0	0	0	0	0 	0	1	1	0 		0	0	0	0 	0	0	0	0 	0	0	0	1	0	0	0	0
	;		  		      		  ...
	;	VSRAM39	ScrollA19	$404C0010		0	1	0	0	0	0	0	0	0	1	0	0 	1	1	0	0 		0	0	0	0 	0	0	0	0 	0	0	0	1	0	0	0	0
	;	VSRAM39	ScrollB19	$404E0010		0	1	0	0	0	0	0	0	0	1	0	0 	1	1	1	0 		0	0	0	0 	0	0	0	0 	0	0	0	1	0	0	0	0
	;---------------------------------------------------------------------------------------------

	;VSRAM code here
	
	
	;-----------------------------------------------------------------------
	;	Load Patterns
	;	8x8 Tiles starting at $0000 in VRAM. 4 Bits per pixel
	;
	;	TILE	
	;		dc.l	$10000010	;Tile ID = $0000	Address in VRAM = $0000
	;		dc.l	$01000100										  $0004
	;		dc.l	$00101000										  $0008
	;		dc.l	$00010000										  $001C
	;		dc.l	$00101000										  $0010
	;		dc.l	$01000100										  $0014
	;		dc.l	$10000010										  $0018
	;		dc.l	$00000000										  $001C	
	;
	;		dc.l	$10000010	;Tile ID = $0001	Address in VRAM = $0020
	;		dc.l	$01000100										  $0024
	;		dc.l	$00101000										  $0028
	;		dc.l	$00010000										  $002C
	;		dc.l	$00101000										  $0030
	;		dc.l	$01000100										  $0034
	;		dc.l	$10000010										  $0038
	;		dc.l	$00000000										  $003C
	;
	;-----------------------------------------------------------------------	
	
	move.l	#((TILE_FONT1_END-TILE_FONT1)/4)-1,d0
	move.l #$40000000,d1			
	move.l d1,VDPCtrl
	lea TILE_FONT1,a0
TileLoop
	move.l (a0)+,VDPData
	dbra d0,TileLoop
	
	move.l	#((TILE_BG1_END-TILE_BG1)/4)-1,d0
	lea TILE_BG1,a0
TileLoop2
	move.l (a0)+,VDPData
	dbra d0,TileLoop2
	
	move.l	#((TILE_SPRITE1_END-TILE_SPRITE1)/4)-1,d0
	lea TILE_SPRITE1,a0
TileLoop3
	move.l (a0)+,VDPData
	dbra d0,TileLoop3
	
	move.l	#((SPRITEY_END-SPRITEY)/4)-1,d0
	lea SPRITEY,a0
TileLoop4
	move.l (a0)+,VDPData
	dbra d0,TileLoop4
	
	
	
	;-------------------------------------------------------------------------------
	;	Scroll A. 
	;	Defined (in VDP Reg#2) from $C000 Onwards. 64 tiles length x 32 tiles height
	;	8kb
	;
	;	b15 b14 b13 b12 b11 b10 b9  b8      b7  b6  b5  b4  b3  b2  b1  b0
	;	L	P	P	V	H	T  	T	T  		T   T   T   T   T   T   T   T  
	;
	;	T = Tile number				P = Pallet number
	;	H = Horizontal flip			L = Layer (in front of /behind sprites)
	;	V = Vertical flip
	;	
	;-------------------------------------------------------------------------------	
	
	move.l #$40000003,d0			
	move.l d0,VDPCtrl				;b15 b14 b13 b12 b11 b10 b9  b8      b7  b6  b5  b4  b3  b2  b1  b0
	move.w #$0001,VDPdata			;0	 0	 0	 0	 0	 0	 0	 0		 0	 0	 0	 0	 0	 0	 0	 1		
	move.w #$0002,VDPdata			;0	 0	 0	 0	 0	 0	 0	 0		 0	 0	 0	 0	 0	 0	 1	 0
	move.w #$0003,VDPdata			;0	 0	 0	 0	 0	 0	 0	 0		 0	 0	 0	 0	 0	 0	 1	 1
	move.w #$0004,VDPdata			
	move.w #$0005,VDPdata
	move.w #$0006,VDPdata			
	move.w #$0007,VDPdata			
	move.w #$0008,VDPdata			
	move.w #$0009,VDPdata			
	move.w #$000A,VDPdata			
	move.w #$000B,VDPdata
	move.w #$000C,VDPdata
	move.w #$000D,VDPdata
	move.w #$000E,VDPdata
	move.w #$000F,VDPdata
	move.w #$0010,VDPdata
	move.w #$0011,VDPdata
	move.w #$0012,VDPdata
	move.w #$0013,VDPdata
	move.w #$0014,VDPdata
	move.w #$0015,VDPdata
	move.w #$0016,VDPdata
	move.w #$0017,VDPdata
	move.w #$0018,VDPdata
	move.w #$0019,VDPdata
	move.w #$001A,VDPdata
	
	move.w #$0000,VDPdata
	
	move.w #$001B,VDPdata
	move.w #$001C,VDPdata
	move.w #$001D,VDPdata
	move.w #$001E,VDPdata
	move.w #$001F,VDPdata
	move.w #$0020,VDPdata
	move.w #$0021,VDPdata
	move.w #$0022,VDPdata
	move.w #$0023,VDPdata
	move.w #$0024,VDPdata
	
	move.w #$0000,VDPdata
	
	move.w #$0005,VDPdata
	move.w #$0005,VDPdata
	
	move.l #$40800003,d0					
	move.l d0,VDPCtrl
	
	move.w #$0025,VDPdata
	move.w #$0026,VDPdata
	move.w #$0027,VDPdata
	move.w #$0028,VDPdata
	move.w #$0029,VDPdata
	move.w #$002A,VDPdata
	move.w #$002B,VDPdata
	
	
	move.l #$4D000003,d0					
	move.l d0,VDPCtrl
	
	move.w #$0005,VDPdata
	move.w #$0005,VDPdata
	
	
	move.l #$4DA00003,d0					
	move.l d0,VDPCtrl
	
	move.w #$0005,VDPdata
	move.w #$0005,VDPdata
	
	move.l #$40820003,d0					
	move.l d0,VDPCtrl
	
	move.w #$0006,VDPdata
	move.w #$0006,VDPdata
	
	
	;-------------------------------------------------------------------------------
	;	Scroll B. 
	;	Defined (in VDP Reg#4) from $E000 Onwards. 64 tiles length x 32 tiles height
	;	8kb
	;
	;	b15 b14 b13 b12 b11 b10 b9  b8      b7  b6  b5  b4  b3  b2  b1  b0
	;	L	P	P	V	H	T  	T	T  		T   T   T   T   T   T   T   T  
	;
	;	T = Tile number				P = Pallet number
	;	H = Horizontal flip			L = Layer (in front of /behind sprites)
	;	V = Vertical flip
	;
	;-------------------------------------------------------------------------------

	move.w	#($1000/2)-1,d0			
	move.l	#$60000003,d1			
	move.l	d1,VDPCtrl
ScrollBLoop							
	move.w	#$002C,VDPData			
	dbra	d0,ScrollBLoop	
	
	
	;--------------------------------------------------------------------
	;	Window. 
	;	Defined (in VDP reg#3) from $F000 Onwards. 
	;	4kb in H40, 2kb in H32.
	;--------------------------------------------------------------------	
	
	;Window code here
	
	
	;--------------------------------------------------------------------------------------------------------------------------------------------------------
	;	Sprites. 
	;	Defined (in VDP reg#5) from $D800 Onwards. 1kb in H40, 512b in H32.
	;	4 words per sprite. 
	;
	;	Address	Sprite																	b15 b14 b13 b12 b11 b10 b9  b8      b7  b6  b5  b4  b3  b2  b1  b0
	;	$D800 	1 		Ypos															- 	- 	- 	- 	- 	- 	Y 	Y 		Y 	Y 	Y 	Y 	Y 	Y 	Y 	Y
	;	$D802 	1 		Width(8,16,24,32), Height(8,16,24,32), Link to next sprite		- 	- 	- 	- 	W 	W 	H 	H 		- 	L 	L 	L 	L 	L 	L 	L
	;	$D804 	1 		Priority, Color pallet, V flip, H flip, tile Number				P 	C 	C 	V 	H 	N 	N 	N 		N 	N 	N 	N 	N 	N 	N 	N
	;	$D806 	1 		Xpos															- 	- 	- 	- 	- 	- 	- 	X 		X 	X 	X 	X 	X 	X 	X 	X
	;	$D808 	2 		Ypos
	;	$D80A 	2 		Width(8,16,24,32), Height(8,16,24,32), Link to next sprite		(L = draw order of sprites (not tileID). Last sprite should have L=0)
	;	$D80C 	2 		Priority, Color pallet, V flip, H flip, tile Number
	;	$D80E 	2 		Xpos
	;	$D810 	3 		Ypos
	;		...
	;	$D9FF 	64 		Xpos Last Sprite of H32
	;		...
	;	$DA7F 	80 		Xpos Last Sprite of H80
	;
	;	e.g...
	;	
	;SpriteDesc1;
	;	dc.w 0x0080        	; Y coord (+ 128)											This positions the sprite in the top left of the screen
	;	dc.b %00001111     	; Width (bits 0-1) and height (bits 2-3)
	;	dc.b 0x00          	; Index of next sprite (linked list)
	;	dc.b 0x00          	; H/V flipping (bits 3/4), palette index (bits 5-6), priority (bit 7)	
	;	dc.b $002E 			; Index of first tile
	;	dc.w 0x0080        	; X coord (+ 128)
	;
	;--------------------------------------------------------------------------------------------------------------------------------------------------------
	
	;Sprite1
	move.l	#$58000003,d1						
	move.l	d1,VDPCtrl
	move.w	#$0080,VDPData
	
	move.l	#$58020003,d1						
	move.l	d1,VDPCtrl
	move.w	#$0001,VDPData
	
	move.l	#$58040003,d1						
	move.l	d1,VDPCtrl
	move.w	#$002E,VDPData
	
	move.l	#$58060003,d1						
	move.l	d1,VDPCtrl
	;move.w	#$0080,VDPData
	move.w	#$00A0,VDPData	

	;Sprite2
	move.l	#$58080003,d1						
	move.l	d1,VDPCtrl
	move.w	#$0090,VDPData
	
	move.l	#$580A0003,d1						
	move.l	d1,VDPCtrl
	move.w	#$0000,VDPData
	
	move.l	#$580C0003,d1						
	move.l	d1,VDPCtrl
	move.w	#$002E,VDPData
	
	move.l	#$580E0003,d1						
	move.l	d1,VDPCtrl
	move.w	#$0090,VDPData	
	
	;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	;	HScroll. 
	;	Defined (in VDP reg#13) from $FC00 Onwards. 
	;
	;											VRAM Write	CD1=0, CD0=1, CD2=CD3=CD4=CD5=0		(for VRAM Read	CD0=CD1=CD2=CD3=CD4=CD5=0)
	;Access via VDP								First Word															Second Word
	;address				;VDP command		CD1	CD0	A13	A12	A11	A10	A9	A8	A7	A6	A5	A4	A3	A2	A1	A0		0	0	0	0	0	0	0	0	CD5	CD4	CD3	CD2	0	0	A15	A14 
	;$FC00		ScrollA0	$7C000003			0	1	1	1	1	1	0	0	0	0	0	0	0	0	0	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1
	;$FC02 		ScrollB0	$7C020003			0	1	1	1	1	1	0	0	0	0	0	0	0	0	1	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	
	;$FC04 		ScrollA1	$7C040003			0	1	1	1	1	1	0	0	0	0	0	0	0	1	0	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1
	;$FC06 		ScrollB1	$7C060003			0	1	1	1	1	1	0	0	0	0	0	0	0	1	1	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1
	;							  ...
	;$FFFC 		ScrollB19	$7FFC0003			0	1	1	1	1	1	0	0	0	0	0	0	0	1	1	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1
	;$FFFE 		ScrollB19	$7FFE0003			0	1	1	1	1	1	1	1	1	1	1	1	1	1	1	0		0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1
	;
	;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	;HScroll code here
	
	
	;--------------------------------------------------------------------
	;	Init game logic 
	;
	;--------------------------------------------------------------------	
	
	move.l #$00000080,d0		;Counters		
	move.l #$00000080,d3
	move.l #1000,d2

	
	;move.w	#$8144,(VDPCtrl)	;C00004 reg 1 = 0x44 unblank display
	
	move.w  #$100,$A11100    	;Z80 Bus REQ on (#$0 = off)
	move.w  #$100,$A11200    	;Z80 Reset off (#$0 = on)
	
	move.l	#$00A04000,a0

FMCheck
	move.b	(a0),d0
	andi.l	#$00000080,d0
	bne FMCheck	

	
	
;	move.l #10000000000,d1
;WWWWW
;	dbra d1,WWWWW
	
;	move.b	#$28,$A04000
;	move.b	#$00,$A04001


	move.w	%0000011100000000,sr	;Enable interrupts on 68k
	;--------------------------------------------------------------------
	;	Main rendering loop
	;
	;--------------------------------------------------------------------
	
	

	
	
MAINLOOP
	move.l	#$58000003,d1						
	move.l	d1,VDPCtrl
	add.w	#1,d0
	move.w	d0,VDPData
	
	move.l	#$58080003,d4						
	move.l	d4,VDPCtrl
	add.w	#1,d3
	move.w	d3,VDPData

STUCK
	jmp STUCK
	
	
;WAITY
;	dbra d2,WAITY
;	move.l #10000,d2
	
;	jmp MAINLOOP
	
	;--------------------------------------------------------------------
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	