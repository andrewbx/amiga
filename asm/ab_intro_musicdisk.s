*---------------------------------------------------------------------------*
	INCLUDE	"custom/ab_custom.i"
*---------------------------------------------------------------------------*
_GFXVERSION   = 33
SCREENWIDTH   = 46
PAGEHEIGHT    = 130
STARSNO       = 26
FADERDELAY    = 1
*****************************************************************************
	SECTION	ProgramCode,CODE
*****************************************************************************
Begin_Program:	MoveM.l	D0-A6,-(SP)		  ; Push All Regs Onto Stack
		MoveM.l	_WipeAllRegs(PC),D0-A6	  ; Flush All Registers

		Move.l	(_AbsExecBase).w,_SYSBase ; Save ExecBase
		Move.l	_HardWareBase(PC),A5	  ; Pointer to Chip Base

		Bsr.w	Op_GFX_Library		  ; Open Graphix Library
		Beq.s	End_Program		  ; Exit if Library Failed

		Bsr.w	SystemTakeOver		  ; Kill the OS!
		Bsr.w	Mt_Init
*---------------------------------------------------------------------------*
* Wait For User to Hit the Left Mouse Button
*---------------------------------------------------------------------------*
		MoveM.l	D0-D7/A0-A4,-(SP)
*---------------------------------------------------------------------------*
FadeON_LOGO:	Lea	LOGO_Cols+6,A1
		MoveQ	#(15-1),D7
		Lea	WHITEColours(PC),A2
		Bsr.w	FadeColours

		Lea	LOGOColours(PC),A2
		Bsr.w	FadeColours
*---------------------------------------------------------------------------*
End_Fading:	MoveM.l	(SP)+,D0-D7/A0-A4
*---------------------------------------------------------------------------*
Mouse_Handler:	WAITVBLANK
		Btst.b	#(_LeftMouse),CIAA	  ; Hit Left Mouse?
		Bne.b	Mouse_Handler		  ; If Not Then Loop-^
*---------------------------------------------------------------------------*
		Bsr.w	Mt_End
		Bsr.w	SystemRestore		  ; Free the OS!

End_Program:	MoveM.l	(SP)+,D0-A6		  ; Pull All Regs From Stack
		RTS				  ; End Program
*****************************************************************************
* Level 3 Interrupt Routine
*****************************************************************************
NewLevel3:	MoveM.l	D0-A6,-(SP)		; Push All Regs Onto Stack

		Bsr.w	Mt_Music		; Play My Music
		Bsr.w	Move_STARS		; Scroll Stars 
		Bsr.w	Scroll_TEXT		; Scroll Da Text
		Bsr.w	Bounce_TEXT		; Bounce Scroll Text
		Bsr.w	Print_TEXT		; Print Da Text
									
EndLevel3:	Move.w	#$0020,INTREQ(A5)	; Clear VBlank Request
		MoveM.l	(SP)+,D0-A6		; Pull All Regs From Stack
		RTE				; Return From Exception
*****************************************************************************
* Open Graphix Library
*****************************************************************************
Op_GFX_Library:	Lea	_GFXName(PC),A1		; Pointer To Library Name
		MoveQ	#(_GFXVERSION),D0	; Specified Version
		MoveA.l	_SYSBase(PC),A6		; Get ExecBase
		CALL	OpenLibrary		; OpenLibrary()
		Move.l	D0,_GFXBase		; Saved Returned Pointer
		RTS
*****************************************************************************
* Kill the Operating System!
*****************************************************************************
SystemTakeOver:	Move.l	D0,A1			; GFXBase into A1 to Close
		MoveA.l	A1,A2			; Store GFXBase into A2
		CALL	CloseLibrary		; GFXBase Saved so Close GFX
		CALL	Forbid			; Forbid Multitasking!
		
		MoveA.l	A2,A6		     	     ; GFXBase into A6
		Move.l	gb_Actiview(A6),_SavedWBView ; Save Prev WBench View
		Move.l	gb_Copinit(A6),_SavedCopper  ; Save Previous Copper

		SubA.l	A0,A0			; Load NULL View - Flush
		CALL	LoadView		; Hardware Regs
		CALL	WaitTOF			; Wait

		CALL	OwnBlitter		; OWN the Blitter

		Move.w	DMACONR(A5),_SavedDMACon ; DMACONR - Read Only
		Move.w	INTENAR(A5),_SavedINTena ; INTENAR - Read Only
		Move.w	ADKCONR(A5),_SavedADKCon ; ADKCONR - Read Only
		Move.w	#CLRBITS,D4		 ; Clear Value for H/Regs
				
		Move.w	D4,DMACON(A5)		; Clear DMA Control
		Move.w	D4,INTENA(A5)		; Clear Interrupts
		Move.w	D4,INTREQ(A5)		; Clear Interrupt Requests
		Move.w	D4,ADKCON(A5)		; Clear Audio/Disk Control
		
		Bsr.w	Insert_BitMaps		; Put in My Text Screen
		Bsr.w	Setup_STARS		; Setup Stars

		Bsr.w	Get_VBaseR		; Check Current State of VBR
		Move.l	D0,_VectorBaseR		; Save VBR
		Move.l	_VectorBaseR(PC),A0	; Get Saved Vector Base Reg

		Move.l	Int3_Vector(A0),_SavedLevel3 ; Save Old Level 3 Int
		Move.l	#NewLevel3,Int3_Vector(A0)   ; Insert New Level 3

		Move.l	#NewCopper,COP1LCH(A5)  ; Insert My Copperlist

		Move.w	#$83C0,DMACON(A5)	; Enable Required DMA bits
		Move.w	#$C020,INTENA(A5)	; Start Interrupts
		RTS
*****************************************************************************
* Restore the Operating System - Recover HardWare Registers Used!
*****************************************************************************
SystemRestore:	Move.w	#CLRBITS,D4		; Clear Value
		
		Move.w	D4,DMACON(A5)		; Clear DMA
		Move.w	D4,INTENA(A5)		; Clear Interrupts
		Move.w	D4,INTREQ(A5)		; Clear Interrupt Requests
		Move.w	D4,ADKCON(A5)		; Clear Audio/Disk Control
		
		Move.w	_SavedDMACon(PC),D1	; Old DMACon
		Move.w	_SavedINTena(PC),D2	; Old INTena
		Move.w	_SavedADKCon(PC),D3	; Old ADKCon
		
		Ori.w	#$8000,D1		; Set/Clr
		Ori.w	#$8000,D2		; Set/Clr
		Ori.w	#$8000,D3		; Set/Clr
		
		Move.w	D1,DMACON(A5)		; Restore DMACon
		Move.w	D2,INTENA(A5)		; Restore INTena
		Move.w	D3,ADKCON(A5)		; Restore ADKCon
				
		Move.l	_SavedCopper(PC),COP1LCH(A5)     ; Restore Old Copper
		
		Move.l	_VectorBaseR(PC),A0	         ; Vector Base Reg
		Move.l	_SavedLevel3(PC),Int3_Vector(A0) ; Restore Old Lvl 3

		Move.l	_SavedWBView(PC),A1	 ; Restore Old WBench View
		Move.l	_GFXBase(PC),A6		 ; GFXBase into A6
		CALL	LoadView		 ;
		CALL	DisOwnBlitter		 ; DisOwn the Blitter

		MoveA.l	_SYSBase(PC),A6		;
		CALL	Permit			; Permit Multitasking!
		RTS
*****************************************************************************
* Get the VBR (Private Instruction - Need to be in SuperVisor Mode)
*****************************************************************************
Get_VBaseR:	Move.l	A5,-(SP)		; Save A5 on Stack
		MoveQ.l	#0,D0			; Clear D0
		MoveA.l	_SYSBase(PC),A6		; Get ExecBase
		Move.w	AttnFlags(A6),D0	; Get State Of AttnFlags
		And.w	#$F,D0			; Is it A 68010 or higher?
		Beq.s	.Not68010		; If Not, it's a 68000
		
		Lea	Get_VBR(PC),A5		; Locate Instruction - (A5)
		CALL	SuperVisor		; Call Private Instruction
		
.Not68010	Move.l	(SP)+,A5		; Restore A5
		RTS				; Exit from Sub!
*---------------------------------------------------------------------------*
Get_VBR:	Dc.l	$4E7A0801		; MoveC	VBR,D0
		RTE				; Return from Exception!
*****************************************************************************
Insert_BitMaps:	MoveM.l	D0-D5/D7/A1,-(SP)	     ; Save D0-D1/A1
		PEA	_TextBMAP+(SCREENWIDTH-2)    ; Page Text+44
		PEA	_TextBMAP		     ; Page Text
		PEA	_Logo_BMAP		     ; My LOGO Pic
		PEA	_StarBITMAP		     ; My Stars
		PEA	_TextBITMAP+(SCREENWIDTH-2)  ; Scroll Text Addr+44
		PEA	_TextBITMAP		     ; Scroll Text Addr
		MoveM.l	(SP)+,D0-D5		     ; Pull Pic Addr D0-D1
*---------------------------------------------------------------------------*
		Lea	TextCBMAP_Ptr,A1
		Move.w	D0,6(A1)
		Swap	D0
		Move.w	D0,2(A1)
		Move.w	D1,14(A1)
		Swap	D1
		Move.w	D1,10(A1)
*---------------------------------------------------------------------------*
		Lea	Sprite_Ptrs,A1
		Move.w	D2,6(A1)
		Swap	D2
		Move.w	D2,2(A1)		
*---------------------------------------------------------------------------*
		Lea	LOGO_Ptrs,A1
		Add.l	#38,D3
		MoveQ	#(4-1),D7
NextPlane:	Move.w	D3,6(A1)
		Swap	D3
		Move.w	D3,2(A1)
		Swap	D3
		Addi.l	#(40*100),D3
		AddQ.w	#8,A1
		DBF	D7,NextPlane
*---------------------------------------------------------------------------*
		Lea	PageBMAP_Ptrs,A1
		Move.w	D4,6(A1)
		Swap	D4
		Move.w	D4,2(A1)
		Move.w	D5,14(A1)
		Swap	D5
		Move.w	D5,10(A1)
*---------------------------------------------------------------------------*
		MoveM.l	(SP)+,D0-D5/D7/A1	     ; Restore D0-D1/A1
		RTS
*****************************************************************************
Setup_STARS:	MoveM.l	D3-D7/A1,-(SP)

		Lea	_StarBITMAP,A1
		Lea	SpriteCols,A2
		MoveQ	#(STARSNO)-1,D7
		MoveQ	#$2C,D6
		MoveQ	#0,D4
		MoveQ	#0,D5
								
Begin_SBMAP:	MoveQ	#(4-1),D3
.Make_SBMAP	Bsr.s	Make_RANDOM
		Move.b	D6,(A1)+
		Move.b	D5,(A1)+
		Andi.w	#$33,D4
		Andi.w	#$33,D5
		AddQ.b	#1,D6
		Move.b	D6,(A1)+
		Move.b	#0,(A1)+
		Move.w	D4,(A1)+
		Move.w	D5,(A1)+
		AddQ.b	#1,D6
		DBF	D3,.Make_SBMAP
		DBF	D7,Begin_SBMAP

		MoveM.l	(SP)+,D3-D7/A1
		RTS
*---------------------------------------------------------------------------*
Make_RANDOM:	Move.b	$07(A5),D5
		Move.b	$06(A5),D4
		Mulu.w	D4,D5
		Move.b	$BFD800,D4
		Eor.b	D4,D5
		RTS
*****************************************************************************
Move_STARS:	MoveQ	#(STARSNO)-1,D7
		Lea	_StarBITMAP,A1
				
Start_Moving:	SubQ.b	#2,1(A1)
		AddQ.w	#8,A1
		SubQ.b	#4,1(A1)
		AddQ.w	#8,A1
		SubQ.b	#5,1(A1)
		AddQ.w	#8,A1
		SubQ.b	#3,1(A1)
		AddQ.w	#8,A1
		DBF	D7,Start_Moving
		RTS
*****************************************************************************
FadeColours:	MoveQ	#$00F,D0	    ; Start with Blue
		MoveQ	#$001,D1	    ; Blue Increment Value

		MoveQ	#(16*3)-4,D4	    ; Colour shades 1-16 for R-G-B

ContinueFade:	Move.w	D7,D6		    ; Number of Colours
		MoveA.l	A1,A3		    ; Reset Copper Colour Regs
		MoveA.l	A2,A4		    ; and the Cols to fade from

		Cmpi.w	#$F000,D0	    ; Finished checking RGB?
		Bne.s	InitColours	    ; If so then reset the BLUE
		MoveQ	#$00F,D0	    ; colour and increment for
		MoveQ	#$001,D1	    ; the next time round!

InitColours:	Bsr.s	CheckColsRGB	    ; This does the most work

		AddQ	#4,A3		    ; Next copper colour reg
		AddQ	#2,A4		    ; Next colour in list
		DBF	D6,InitColours	    ; Repeat for xx colours
		Lsl.w	#4,D0		    ; Next Colour 
		Lsl.w	#4,D1		    ; Next Colour Increment

		MoveQ	#FADERDELAY,D5	    ; Increase for a slower fade
		Bsr.s	CheckDelay	    ; Delay Fade

		DBF	D4,ContinueFade	    ; Loop until done man!
EndColourFade:	RTS			    ; Could this mean the END?
*---------------------------------------------------------------------------*
CheckColsRGB:	Move.w	(A3),D2		    ; This is a subroutine which
		Move.w	(A4),D3		    ; takes seperate values from
		And.w	D0,D2		    ; the copperlist and the 
		And.w	D0,D3		    ; colourlist, compares the
		Cmp.w	D3,D2		    ; two, then adds or subtracts
					    ; one to the copperlist
		Beq.s	EndCheckRGB	    ; palette until it reaches
		Bhi.s	SubColourRGB	    ; the colours you specified
					    ; in your colourlist palette
		Add.w	D1,(A3)		    ; If both values are equal - the
		Bra.s	EndCheckRGB	    ; add/subtract part is skipped!
		
SubColourRGB:	Sub.w	D1,(A3)
EndCheckRGB:	RTS
*---------------------------------------------------------------------------*
CheckDelay:	Tst.w	D5		    ; little delay routine
		Beq.s	EndDelay	    ; to delay the fade
		SubQ.w	#1,D5		    ; in 1/50th of a second!

		WAITVBLANK		
		Bra.s	CheckDelay
EndDelay:	RTS
*****************************************************************************
Print_TEXT:	Tst.b	CheckTMark
		Beq.s	Check_X_Pos
		
		Tst.w	PauseCOUNT
		Beq.s	Clear_Screen
		SubQ.w	#1,PauseCOUNT
		Bra.w	End_TEXT
		
Clear_Screen:	Lea	_TextBMAP,A0
		Move.l	A0,TextBMAP_PTR
		Bsr.w	Clear_BMAP

		Clr.b	Y_Position
		Clr.b	CheckTMark

Check_X_Pos:	Cmpi.b	#36,X_Position
		Bne.s	Not_End_Line
		AddI.l	#(SCREENWIDTH-1)*8,TextBMAP_PTR
		Clr.b	X_Position
		
		AddQ.b	#1,Y_Position
		Cmpi.b	#12,Y_Position
		Bne.s	Not_End_Line

		Clr.b	Y_Position
		Move.w	#300,PauseCOUNT
		Move.b	#1,CheckTMark
		Bra.s	End_TEXT

Not_End_Line:	MoveA.l	Text_Pointer(PC),A2
		MoveQ	#0,D0	
		Move.b	(A2)+,D0
		Bne.s	Update_PTR
		Move.l	#Intro_TEXT,Text_Pointer
		Bra.s	End_TEXT
		
Update_PTR:	Move.l	A2,Text_Pointer
		Sub.b	#32,D0
		Lsl.w	#3,D0
		Lea	Font8_DATA,A0
		Lea	(A0,D0.w),A0

		MoveA.l	TextBMAP_PTR(PC),A1
		AddA.l	#4,A1
		
		MoveQ	#(8-1),D7
Copy_Char:	Move.b	(A0)+,(A1)
		AddA.l	#44,A1
		DBF	D7,Copy_Char

		AddQ.l	#1,TextBMAP_PTR
		AddQ.b	#1,X_Position
End_TEXT:	RTS
*---------------------------------------------------------------------------*
Clear_BMAP:	WaitForBlitter
		Move.l	A0,$054(A5)
		Move.l	#$01000000,$040(A5)
		Move.l	#-1,$044(A5)
		Move.l	#0,$066(A5)
		Move.w	#(PAGEHEIGHT*64)+(SCREENWIDTH/2)-3,$058(A5)
		RTS
*****************************************************************************
Scroll_TEXT:	MoveM.l	D0-D3/A0-A2,-(SP)
		
		Tst.w	ScrollPause
		Beq.s	Continue
		SubQ.w	#1,ScrollPause
		Bra.w	End_Scroller
		
Continue:	SubQ.w	#2,ScrollWait
		Bhi.w	Shift_TEXT
		
		Move.w	Text_PTR(PC),D1
		Lea	Scroll_TXT(PC),A0
		Move.w	#16,ScrollWait
		
		MoveQ	#0,D0
		Move.b	(A0,D1.w),D0
		Cmpi.b	#"s",D0
		Bne.s	DontStopTEXT

		Move.w	#200,ScrollPause
		AddQ.w	#1,Text_PTR
		Bra.w	End_Scroller
		
DontStopTEXT:	Cmpi.b	#"@",D0
		Bne.s	NotEndOfTEXT
		Clr.w	Text_PTR
		Move.b	Scroll_TXT,D0

NotEndOfTEXT:	Lea	Font16_DATA,A0
		Sub.b	#32,D0
		Lsl.w	#5,D0
		Lea	(A0,D0.w),A0
		AddQ.w	#1,Text_PTR
		Lea	_TextBUFFER+SCREENWIDTH,A1
		
Place_Font:	WaitForBlitter
		MoveM.l	A0/A1,$050(A5)
		Move.l	#$09F00000,$040(A5)
		Move.l	#$FFFFFFFF,$044(A5)
		Move.l	#SCREENWIDTH,$064(A5)
		Move.w	#(16*64)+1,$058(A5)

Shift_TEXT:	Lea	_TextBUFFER,A1
		Lea	2(A1),A0

		Move.l	#$E9F00000,D2
		MoveQ.l	#-1,D3
						
		WaitForBlitter
		MoveM.l	A0/A1,$050(A5)
		MoveM.l	D2/D3,$040(A5)
		Move.l	#0,$064(A5)
		Move.w	#(16*64)+(SCREENWIDTH/2),$058(A5)
		
		Lea	_TextBITMAP,A2

		Swap	D2
		Andi.w	#$0FF0,D2

		WaitForBlitter
		MoveM.l	A0/A2,$050(A5)
		Move.w	D2,$040(A5)
		Move.w	#4,$064(A5)
		Move.w	#(16*64)+(SCREENWIDTH/2)-1,$058(A5)

End_Scroller:	MoveM.l	(SP)+,D0-D3/A0-A2
		RTS
*****************************************************************************
Bounce_TEXT:	Move.l	#_TextBITMAP,D0
		Lea	TextCBMAP_Ptr,A1
		Lea	Bounce_TABLE(PC),A2

		Move.w	Scroll_PTR(PC),D1
		Add.w	D1,D1
		Move.w	(A2,D1.w),D2
					
		Cmpi.b	#-1,D2
		Bne.s	Update_BMAP
		Clr.w	Scroll_PTR
		Move.w	Bounce_TABLE(PC),D2
*---------------------------------------------------------------------------*
Update_BMAP:	Mulu.w	#(SCREENWIDTH-2),D2
		Sub.l	D2,D0
		Move.w	D0,6(A1)
		Swap	D0
		Move.w	D0,2(A1)
		Swap	D0
		Addi.l	#(SCREENWIDTH-2),D0
		Move.w	D0,14(A1)
		Swap	D0
		Move.w	D0,10(A1)
		AddQ.w	#1,Scroll_PTR
EndScroll:	RTS
*---------------------------------------------------------------------------*
PT_Player:	INCLUDE	"players/ptplay.s"
*---------------------------------------------------------------------------*
*****************************************************************************
* SYSTEM Variables
*****************************************************************************
_GFXName:	Dc.b	"graphics.library",0
_GFXBase:	Ds.l	1
_SYSBase:	Ds.l	1
*---------------------------------------------------------------------------*
_HardWareBase:	Dc.l	$DFF000
*---------------------------------------------------------------------------*
_SavedCopper:	Dc.l	0
_SavedWBView:	Dc.l	0
_VectorBaseR:	Ds.l	1
_SavedLevel3:	Ds.l	1
_SavedDMACon:	Ds.w	1
_SavedINTena:	Ds.w	1
_SavedADKCon:	Ds.w	1
_WipeAllRegs:	Dcb.l	15,0
		EVEN
*---------------------------------------------------------------------------*
ScrollWait:	Dc.w	0
ScrollPause:	Dc.w	0
PauseCOUNT:	Dc.w	0
Scroll_PTR:	Dc.w	0
Text_PTR:	Dc.w	0
Scroll_END:	Dc.b	0
X_Position:	Dc.b	0
Y_Position:	Dc.b	0
CheckTMark:	Dc.b	0
*---------------------------------------------------------------------------*
TextBMAP_PTR:	Dc.l	_TextBMAP
Text_Pointer:	Dc.l	Intro_TEXT
		EVEN
*---------------------------------------------------------------------------*
Bounce_TABLE:	Dc.w	$0001,$0001,$0001,$0002,$0003,$0004,$0005,$0006
		Dc.w	$0007,$0008,$0009,$000A,$000C,$000E,$0010,$0012
		Dc.w	$0014,$0016,$0018,$001A,$001D,$001D,$001A,$0018
		Dc.w	$0016,$0014,$0012,$0010,$000E,$000C,$000A,$0009
		Dc.w	$0008,$0007,$0006,$0005,$0004,$0003,$0002,$0001
		Dc.w	$0001,$0001,-1
*---------------------------------------------------------------------------*
LOGOColours:	Dc.w	$06B,$048,$059,$059,$26A,$47A,$58B
		Dc.w	$69B,$79C,$8AC,$9BD,$ACD,$BDE,$B00,$D00
*---------------------------------------------------------------------------*
WHITEColours:	Dc.w	$FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF
		Dc.w	$FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF,$FFF
*---------------------------------------------------------------------------*
Scroll_TXT:	Dc.b	"    This volume contains a   "
		Dc.b	"collection of several modules"
		Dc.b	"created using OctaMED Tracker"
		Dc.b	"                             "
		Dc.b	" Review the README file for  "
		Dc.b	"    further instructions     "
		EVEN
*---------------------------------------------------------------------------*
Intro_TEXT:	Dc.b	"                                    "
		Dc.b	"                                    "
		Dc.b	"    THE OCTAMED MIX - VOLUME ONE    "
		Dc.b	"                                    "
		Dc.b	"                                    "
		Dc.b	"     WELCOME TO MY MUSIC INTRO.     "
		Dc.b	" GREETS TO ALL FELLOW AMIGA CODERS !"
		Dc.b	"                                    "
		Dc.b	"                                    "
		Dc.b	"   HIT LEFT MOUSE BUTTON TO QUIT!   "
		Dc.b	"                                    ",0
		EVEN
*****************************************************************************
	SECTION	Copperlist,DATA_C
*****************************************************************************
NewCopper:	Dc.w	BPLCON0,$4200,BPLCON1,$0000,BPLCON2,$0000
		Dc.w	BPL1MOD,$0000,BPL2MOD,$0000
		Dc.w	DIWSTRT,$2C71,DIWSTOP,$2CD1
		Dc.w	DDFSTRT,$0030,DDFSTOP,$00D8
*---------------------------------------------------------------------------*
		Dc.w	DMACON,$8020
*---------------------------------------------------------------------------*
Sprite_Ptrs:	Dc.w	SPR0PTH,$0,SPR0PTL,$0
		Dc.w	SPR1PTH,$0,SPR1PTL,$0
		Dc.w	SPR2PTH,$0,SPR2PTL,$0
		Dc.w	SPR3PTH,$0,SPR3PTL,$0
		Dc.w	SPR4PTH,$0,SPR4PTL,$0
		Dc.w	SPR5PTH,$0,SPR5PTL,$0
		Dc.w	SPR6PTH,$0,SPR6PTL,$0
		Dc.w	SPR7PTH,$0,SPR7PTL,$0		
*---------------------------------------------------------------------------*
LOGO_Cols:	Dc.w	COLOR00,$0222,COLOR01,$0222
		Dc.w	COLOR02,$0222,COLOR03,$0222
		Dc.w	COLOR04,$0222,COLOR05,$0222
		Dc.w	COLOR06,$0222,COLOR07,$0222
		Dc.w	COLOR08,$0222,COLOR09,$0222
		Dc.w	COLOR10,$0222,COLOR11,$0222
		Dc.w	COLOR12,$0222,COLOR13,$0222
		Dc.w	COLOR14,$0222,COLOR15,$0222
*---------------------------------------------------------------------------*
		Dc.w	BPL1MOD,-4,BPL2MOD,-4
LOGO_Ptrs:	Dc.w	BPL1PTH,$0,BPL1PTL,$0
		Dc.w	BPL2PTH,$0,BPL2PTL,$0
		Dc.w	BPL3PTH,$0,BPL3PTL,$0
		Dc.w	BPL4PTH,$0,BPL4PTL,$0
*---------------------------------------------------------------------------*
SpriteCols:	Dc.w	COLOR17,$0555
		Dc.w	COLOR18,$0FFF
		Dc.w	COLOR19,$0888
*---------------------------------------------------------------------------*
		Dc.w	$7A0F,$FFFE
		Dc.w	BPLCON0,$2200
		Dc.w	BPL1MOD,$0000
		Dc.w	BPL2MOD,$0000
*---------------------------------------------------------------------------*
PageBMAP_Ptrs:	Dc.w	BPL1PTH,$0,BPL1PTL,$0
		Dc.w	BPL2PTH,$0,BPL2PTL,$0
*---------------------------------------------------------------------------*
		Dc.w	COLOR01,$00F0
		Dc.w	COLOR02,$0003
		Dc.w	COLOR03,$00C0
*---------------------------------------------------------------------------*
		Dc.w	$FD0F,$FFFE,COLOR00,$0400
		Dc.w	$FE0F,$FFFE,COLOR00,$0A00
		Dc.w	$FF0F,$FFFE,COLOR00,$0400
		Dc.w	$FFDF,$FFFE,COLOR01,$0000,COLOR02,$0000
*---------------------------------------------------------------------------*
		Dc.w	DMACON,$0020
*---------------------------------------------------------------------------*
TextCBMAP_Ptr:	Dc.w	BPL1PTH,$0,BPL1PTL,$0
		Dc.w	BPL2PTH,$0,BPL2PTL,$0
*---------------------------------------------------------------------------*
	Dc.w	$000F,$FFFE,COLOR00,$000E,COLOR02,$0FF0,COLOR03,$0220
	Dc.w	$020F,$FFFE,COLOR00,$000D,COLOR02,$0EE0,COLOR03,$0330
	Dc.w	$040F,$FFFE,COLOR00,$000C,COLOR02,$0DD0,COLOR03,$0440
	Dc.w	$060F,$FFFE,COLOR00,$000B,COLOR02,$0CC0,COLOR03,$0550
	Dc.w	$080F,$FFFE,COLOR00,$000A,COLOR02,$0BB0,COLOR03,$0660
	Dc.w	$0A0F,$FFFE,COLOR00,$0009,COLOR02,$0AA0,COLOR03,$0770
	Dc.w	$0C0F,$FFFE,COLOR00,$0008,COLOR02,$0990,COLOR03,$0880
	Dc.w	$0E0F,$FFFE,COLOR00,$0007,COLOR02,$0880,COLOR03,$0AA0
	Dc.w	$100F,$FFFE,COLOR00,$0006,COLOR02,$0770,COLOR03,$0CC0
	Dc.w	$120F,$FFFE,COLOR00,$0005,COLOR02,$00EE,COLOR03,$0EE0
	Dc.w	$140F,$FFFE,COLOR00,$0004,COLOR02,$00FF,COLOR03,$00EE
	Dc.w	$160F,$FFFE,COLOR00,$0003,COLOR02,$00EE,COLOR03,$00CC
	Dc.w	$180F,$FFFE,COLOR00,$0002,COLOR02,$00DD,COLOR03,$00AA
	Dc.w	$1A0F,$FFFE,COLOR00,$0001,COLOR02,$00CC,COLOR03,$0088
	Dc.w	$1C0F,$FFFE,COLOR00,$0000,COLOR02,$00BB,COLOR03,$0077
*---------------------------------------------------------------------------*
		Dc.w	$1E0F,$FFFE,COLOR02,$00AA,COLOR03,$0066
		Dc.w	$200F,$FFFE,COLOR02,$0099,COLOR03,$0055
		Dc.w	$220F,$FFFE,COLOR02,$0088,COLOR03,$0044
		Dc.w	$240F,$FFFE,COLOR02,$0077,COLOR03,$0033	
		Dc.w	$260F,$FFFE,COLOR02,$0066,COLOR03,$0022
		Dc.w	$2B0F,$FFFE,COLOR02,$0055,COLOR03,$0011
*---------------------------------------------------------------------------*
		Dc.w	BPLCON0,$0200
*---------------------------------------------------------------------------*
		Dc.w	$2C0F,$FFFE,COLOR00,$0400
		Dc.w	$2D0F,$FFFE,COLOR00,$0A00
		Dc.w	$2E0F,$FFFE,COLOR00,$0400
		Dc.w	$2F0F,$FFFE,COLOR00,$0222
*---------------------------------------------------------------------------*
		Dc.l	-2,-2			; End Of CopperList
*****************************************************************************
	SECTION	DiskData,DATA_C
*****************************************************************************
_Logo_BMAP:	INCBIN	"images/ab_myname.raw"
Mt_DATA:	INCBIN	"music/ab_cool(pt).mod"
Font8_DATA:	INCBIN	"fonts/ab_font8"
Font16_DATA:	INCBIN	"fonts/ab_font16"
*****************************************************************************
	SECTION	BSSData,BSS_C
*****************************************************************************
_StarBITMAP:	Ds.b	STARSNO*32
*---------------------------------------------------------------------------*
_TextBUFFER:	Ds.b	SCREENWIDTH*20
*---------------------------------------------------------------------------*
_TextBMAP:	Ds.b	(SCREENWIDTH*PAGEHEIGHT)*2
*---------------------------------------------------------------------------*
		Ds.b	SCREENWIDTH*32
_TextBITMAP:	Ds.b	((SCREENWIDTH)*40)*2
*---------------------------------------------------------------------------*
