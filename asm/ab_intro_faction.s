*---------------------------------------------------------------------------*
* exec.i
*---------------------------------------------------------------------------*
supervisor    = -$1E
forbid	      = -$84
permit	      = -$8A
openlibrary   = -$228
closelibrary  = -$19E
findtask      = -294
settaskpri    =	-300
*---------------------------------------------------------------------------*
* graphics.i
*---------------------------------------------------------------------------*
loadview      = -$DE
waitblit      = -$E4
ownblitter    = -$1C8
disownblitter = -$1CE
waittof	      = -$10E
*---------------------------------------------------------------------------*
* pointers
*---------------------------------------------------------------------------*
gb_actiview   = $22
gb_copinit    = $26
int3_vector   = $06C
attnflags     = $128
*---------------------------------------------------------------------------*
leftmouse     = 6
rightmouse    = 2
gfxversion    = 33
screenwidth   = 46
pageheight    = 160
faderdelay    = 1
*---------------------------------------------------------------------------*
ciaa	      = $BFE001
execbase      = $4
cop1lch	      = $080
potgor	      = $016
clrbits	      = $7FFF
*****************************************************************************
* macro definitions
*****************************************************************************
waitforblitter	macro
		move.l	_gfxbase(pc),a6
		jsr	waitblit(a6)
		endm
*---------------------------------------------------------------------------*
waitvblank	macro
\@1		btst.b	#0,$dff005
		bne.b	\@1
		nop
\@2		btst.b	#0,$dff005
		beq.b	\@2
		endm
*---------------------------------------------------------------------------*
dorand		macro
		move.b	$dff007,\2
		move.b	$dff006,\1
		mulu.w	\1,\2
		move.b	$bfd800,\1
		eor.b	\1,\2
		endm
*****************************************************************************
	section	programcode,code
*****************************************************************************
begin_program:	movem.l	d0-a6,-(sp)		  ; store previous contents
		move.l	(execbase).w,_sysbase     ; store execbase

		lea	_gfxname(pc),a1		  ; pointer to library name
		moveq	#gfxversion,d0		  ; specified version
		move.l	_sysbase(pc),a6		  ; get execbase
		jsr	openlibrary(a6)
		move.l	d0,_gfxbase		  ; saved returned pointer
		beq.s	quit_program		  ; exit if library failed

		move.l	d0,a1			  ; got gfxbase pointer
		jsr	closelibrary(a6)	  ; so close gfx library
		
		bsr.w	takeoversystem		  ; kill the o/s!
		bsr.w	mt_init

		movem.l	d0-d7/a0-a4,-(sp)
fadeon_logo:	lea	logo_cols+6,a1
		moveq	#(15-1),d7
		Lea	white_pal(pc),a2
		bsr.w	fadecolours
		Lea	logo_pal(pc),a2
		bsr.w	fadecolours
		movem.l	(sp)+,d0-d7/a0-a4

mouse_handler:	waitvblank
		btst.b	#(leftmouse),ciaa	  ; hit left mouse?
		bne.b	mouse_handler		  ; if not then loop-^

		bsr.w	mt_end			  ; stop music
		bsr.w	restoresystem		  ; bring back the o/s!

quit_program:	movem.l	(sp)+,d0-a6		  ; restore old contents
		rts
*****************************************************************************
* Level 3 Interrupt Routine
*****************************************************************************
newlevel3:	movem.l	d0-a6,-(sp)		; backup all reg contents

		bsr.w	mt_music		; play music
		bsr.w	print_text		; print message
									
endlevel3:	move.w	#$0020,$09C(a5)		; clear request
		movem.l	(sp)+,d0-a6		; restore all reg contents
		rte				; return from exception
*****************************************************************************
* Kill the Operating System!
*****************************************************************************
takeoversystem: sub.l   a1,a1                   ; lookup current task
		jsr     findtask(a6)

		move.l  d0,a1
		moveq   #127,d0                 ; high task priority
		jsr     settaskpri(a6)

		move.l	_gfxbase(pc),a6
		move.l	gb_Copinit(a6),pr_copinit   ; save current copper
		move.l	gb_Actiview(a6),pr_actiview ; save current wb view

		sub.l	a1,a1			; null view - flush registers
		jsr	loadview(a6)
		jsr	waittof(a6)		; wait
		jsr	waittof(a6)		; wait again
		jsr	ownblitter(a6)
		
		move.l	_hardwarebase(pc),a5	; pointer to chip base

		move.w	$002(a5),pr_dmacon	; save current dma
		move.w	#clrbits,$096(a5)	; clear dma control

		move.w	$01C(a5),pr_intena	; save current interrupts
		move.w	#clrbits,$09A(a5)	; clear interrupts
		move.w	#clrbits,$09C(a5)	; clear interrupt requests

		move.w	$010(a5),pr_adkcon	; save current adkcon
		move.w	#clrbits,$09E(a5)	; clear audio/disk control

		bsr.w	insert_bitmaps		; initialise gfx/text

		move.l	#new_copper,cop1lch(a5)  ; insert new copperlist

		bsr.w	get_vbaser		   ; check state of vbr
		move.l	d0,_vectorbase		   ; save vbr
		move.l	d0,a0
		move.l	int3_vector(a0),pr_level3  ; save current level 3
		move.l	#newlevel3,int3_vector(a0) ; insert new level 3

		waitvblank
		move.w	#$83e0,$096(a5)		; enable required dma bits
		move.w	#$c020,$09a(a5)		; start interrupts
		rts
*****************************************************************************
* Restore the Operating System - Recover HardWare Registers Used!
*****************************************************************************
restoresystem:	move.w	#clrbits,$096(a5)	; clear dma control
		ori.w	#$8000,pr_dmacon	; set/clr
		move.w	pr_dmacon,$096(a5)	; restore dmacon
		
		move.w	#clrbits,$09A(a5)	; clear interrupts
		ori.w	#$8000,pr_intena	; set/clr
		move.w	pr_intena,$09A(a5)	; restore intena
		move.w	#clrbits,$09C(a5)	; clear interrupt requests

		move.w	#clrbits,$09E(a5)	; clear audio/disk control
		ori.w	#$8000,pr_adkcon	; set/clr
		move.w	pr_adkcon,$09e(a5)	; restore adkcon
				
		move.l	pr_copinit(pc),cop1lch(a5)    ; restore old copper
		
		move.l	_vectorbase(pc),a0	      ; vbr
		move.l	pr_level3(pc),int3_vector(a0) ; restore old level 3

		move.l	_gfxbase(pc),a6
		jsr	disownblitter(a6)	 ; disown the blitter
		move.l	pr_actiview(pc),a1	 ; restore previous wb view
		jsr	loadview(a6)
		jsr	waittof(a6)		; wait
		jsr	waittof(a6)		; wait again
		rts
*****************************************************************************
* Get the VBR (Private Instruction - Need to be in SuperVisor Mode)
*****************************************************************************
get_vbaser:	move.l	a5,-(SP)		; backup a5 contents
		moveq.l	#0,d0
		move.l	_sysbase(pc),a6
		move.w	attnflags(a6),d0	; Get state of attnflags
		andi.w	#$f,d0			; is it a 68010 or higher?
		beq.s	.not68010		; if not, it's a 68000
		
		lea	get_vbr(pc),a5		; locate Instruction - (a5)
		jsr	supervisor(a6)		; call private instruction
		
.not68010	move.l	(sp)+,a5		; restore a5
		rts
*---------------------------------------------------------------------------*
get_vbr:	dc.l	$4e7a0801		; Movec	vbr,d0
		rte				; return from exception
*****************************************************************************
insert_bitmaps:	pea	textbmap		     ; page Text  d1
		pea	logo_bmap		     ; logo Pic   d0
		movem.l	(sp)+,d0-d1		     ; copy to data registers
*---------------------------------------------------------------------------*
		lea	logo_ptrs,a1
		add.l	#38,d0
		moveq	#(2-1),d7
nextplane:	move.w	d0,6(a1)
		swap	d0
		move.w	d0,2(a1)
		swap	d0
		addi.l	#(40*60),d0
		addQ.w	#8,a1
		dbf	d7,nextplane
*---------------------------------------------------------------------------*
		lea	pagebmap_ptrs,a1
		move.w	d1,6(a1)
		swap	d1
		move.w	d1,2(a1)
*---------------------------------------------------------------------------*
		rts
*****************************************************************************
fadecolours:	moveq	#$00F,d0	    ; start with blue
		moveq	#$001,d1	    ; blue increment value

		moveq	#(16*3)-4,d4	    ; colour shades 1-16 for r-g-b
continuefade:	move.w	d7,d6		    ; number of colours
		movea.l	a1,a3		    ; reset copper colour regs
		movea.l	a2,a4		    ; and the Cols to fade from

		cmpi.w	#$f000,d0	    ; finished checking rgb?
		bne.s	initcolours	    ; if so then reset the blue
		moveq	#$00f,d0	    ; colour and increment for
		moveq	#$001,d1	    ; the next time round!

initcolours:	bsr.s	checkcolsrgb	    ; this does the most work
		addq	#4,a3		    ; next copper colour reg
		addq	#2,a4		    ; next colour in list
		dbf	d6,initcolours	    ; repeat for xx colours
		lsl.w	#4,d0		    ; next colour 
		lsl.w	#4,d1		    ; next colour increment
		moveq	#faderdelay,d5	    ; increase for a slower fade
		bsr.s	checkdelay	    ; delay fade
		dbf	d4,continuefade	    ; loop until complete
endcolourfade:	rts			    ; could this mean the end?
*---------------------------------------------------------------------------*
checkcolsrgb:	move.w	(a3),d2		    ; This is a subroutine which
		and.w	d0,d2		    ; takes seperate values from
		move.w	(a4),d3		    ; the copperlist and the 
		and.w	d0,d3		    ; colourlist, compares the
		cmp.w	d3,d2		    ; two, then adds or subtracts
					    ; one to the copperlist
		beq.s	endcheckrgb	    ; palette until it reaches
		bhi.s	subcolourrgb	    ; the colours you specified
					    ; in your colourlist palette
		add.w	d1,(a3)		    ; If both values are equal - the
		bra.s	endcheckrgb	    ; add/subtract part is skipped!
		
subcolourrgb:	sub.w	d1,(a3)
endcheckrgb:	rts
*---------------------------------------------------------------------------*
checkdelay:	tst.w	d5		    ; little delay routine
		beq.s	enddelay	    ; to delay the fade
		subq.w	#1,d5		    ; in 1/50th of a second!

		waitvblank
		bra.s	checkdelay
enddelay:	rts
*****************************************************************************
Print_TEXT:	Tst.b	CheckTMark
		Beq.s	Check_X_Pos
		
		Tst.w	PauseCOUNT
		Beq.s	Clear_Screen
		SubQ.w	#1,PauseCOUNT
		Bra.w	End_TEXT
		
Clear_Screen:	Lea	textbmap,A0
		Move.l	A0,TextBMAP_PTR
		Bsr.w	Clear_BMAP

		Clr.b	Y_Position
		Clr.b	CheckTMark

Check_X_Pos:	Cmpi.b	#36,X_Position
		Bne.s	Not_End_Line
		AddI.l	#(46-1)*8,TextBMAP_PTR
		Clr.b	X_Position
		
		AddQ.b	#1,Y_Position
		Cmpi.b	#15,Y_Position
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
		AddQ.w	#4,A1
		
		MoveQ	#(8-1),D7
Copy_Char:	Move.b	(A0)+,(A1)
		AddA.w	#44,A1
		DBF	D7,Copy_Char

		AddQ.l	#1,TextBMAP_PTR
		AddQ.b	#1,X_Position
End_TEXT:	rts
*---------------------------------------------------------------------------*
Clear_BMAP:	WaitForBlitter
		Move.l	A0,$054(A5)
		Move.l	#$01000000,$040(A5)
		Move.l	#-1,$044(A5)
		Move.l	#0,$066(A5)
		Move.w	#(PAGEHEIGHT*64)+(SCREENWIDTH/2)-3,$058(A5)
		rts
*---------------------------------------------------------------------------*
pt_player:	include	"devpac:asmsource/players/pt_player.s"
*****************************************************************************
* system variables
*****************************************************************************
_gfxname:	dc.b	"graphics.library",0
_gfxbase:	ds.l	1
_sysbase:	ds.l	1
_vectorbase:	ds.l	1
_hardwarebase:	dc.l	$dff000
pr_copinit:	dc.l	0
pr_actiview:	dc.l	0
pr_level3:	ds.l	1
pr_dmacon:	ds.w	1
pr_intena:	ds.w	1
pr_adkcon:	ds.w	1
pausecount:	dc.w	0
x_position:	dc.b	0
y_position:	dc.b	0
checktmark:	dc.b	0
*---------------------------------------------------------------------------*
textbmap_ptr:	dc.l	textbmap
text_pointer:	dc.l	intro_text
		even
*---------------------------------------------------------------------------*
logo_pal:	dc.w	$9b9,$bdb,$696,$575,$353,$464,$574
		dc.w	$585,$797,$8a8,$aca,$ded,$efe,$9ad,$abd
*---------------------------------------------------------------------------*
white_pal:	dcb.w	15,$fff
*--------------------------------------------------------------------------*
intro_text:	dc.b	"                                    "
		dc.b	"    ----------------------------    "
		dc.b	"    sPACED oUT BBS - thE nO. ONE    "
		dc.b	"    ----------------------------    "
		dc.b	"                                    "
		dc.b	"                                    "
		dc.b	"                                    "
		dc.b	"                                    "
		dc.b	"                                    "
		dc.b	"                                    "
		dc.b	"                                    "
		dc.b	"                                    "
		dc.b	"                                    "
		dc.b	"                                    "
		dc.b	"   HIT LEFT MOUSE BUTTON TO QUIT!   "

		dc.b	"                                    "
		dc.b	"                                    "
		dc.b	"           .      .                 " 
		dc.b	"  _________.______._______/\___     "
		dc.b	"  \  ______:/\____:__/\_      / .   "
		dc.b	"   \/\   __   \   :    /     /  .   "
		dc.b	"     /  .  ' _/   :   /     /   :   "
		dc.b	"    /   __    \      /     /___/\   "
		dc.b	"  _/   .  '    \    /            \_ "
		dc.b	"  \  ________  /\__/\  _________  / "
		dc.b	"  :\/::::::::\/::::::\/:::::::::\/: "
		dc.b	"   : : : : : : : : : : : : : : : :  "
		dc.b	"     . . . . . . . . . . . . . .    "
		dc.b	"                                    "
		dc.b	"                                    ",0
		even
*****************************************************************************
	section	copperlist,data_c
*****************************************************************************
new_copper:	dc.l	$01002200,$01020000,$01040000,$01060000
		dc.l	$008e2781,$00902Cd1,$00920030,$009400d8
		dc.l	$0108fffc,$010afffc
*---------------------------------------------------------------------------*
logo_ptrs:	dc.l	$00e00000,$00e20000,$00e40000,$00e60000
		dc.l	$00e80000,$00eA0000,$00eC0000,$00ee0000
*---------------------------------------------------------------------------*
sprite_ptrs:	dc.l	$01200000,$01220000,$01240000,$01260000	; Sprite
		dc.l	$01280000,$012a0000,$012c0000,$012e0000	; Pointers
		dc.l	$01300000,$01320000,$01340000,$01360000 ; 1-8
		dc.l	$01380000,$013a0000,$013c0000,$013e0000
*---------------------------------------------------------------------------*
logo_cols:	dc.l	$01800000,$01820004,$01840000,$01860000
		dc.l	$01880000,$018a0000,$018c0000,$018e0000
		dc.l	$01900000,$01920000,$01940000,$01960000
		dc.l	$01980000,$019a0000,$019c0000,$019e0000
*---------------------------------------------------------------------------*
		dc.l	$280ffffe,$0186000e,$01840200
		dc.l	$290ffffe,$0186000c,$01840300
		dc.l	$2a0ffffe,$0186000a,$01840400
		dc.l	$2b0ffffe,$01860008,$01840500
		dc.l	$2c0ffffe,$01860006,$01840600
		dc.l	$2d0ffffe,$01860004,$01840700
		dc.l	$2e0ffffe,$01860002,$01840800
		dc.l	$2f0ffffe,$01860001,$01840900
		dc.l	$320ffffe,$01840a00
		dc.l	$360ffffe,$01840b00
		dc.l	$3a0ffffe,$01840c00
		dc.l	$430ffffe,$01840b00		
		dc.l	$470ffffe,$01840a00
		dc.l	$4b0ffffe,$01840900
		dc.l	$4d0ffffe,$01860001,$01840900
		dc.l	$4e0ffffe,$01860002,$01840800
		dc.l	$4f0ffffe,$01860004,$01840700
		dc.l	$500ffffe,$01860006,$01840600
		dc.l	$510ffffe,$01860008,$01840500
		dc.l	$520ffffe,$0186000a,$01840400
		dc.l	$530ffffe,$0186000c,$01840300
		dc.l	$540ffffe,$0186000e,$01840200
		dc.l	$550ffffe,$01860000,$01840234
		dc.l	$600ffffe,$01840007,$01000200
		dc.l	$6d0ffffe,$01000200
		dc.l	$750ffffe,$01080000,$010A0000,$01820ee0,$01001200
*---------------------------------------------------------------------------*
PageBMAP_Ptrs:	dc.l	$00e00000,$00e20000
*---------------------------------------------------------------------------*
		dc.l	$7e0ffffe,$01820cc0,$7f0ffffe,$018200ee
		dc.l	$820ffffe,$01820ee0,$8e0ffffe,$01820ee0
		dc.l	$900ffffe,$01820cc0,$910ffffe,$018200ee
		dc.l	$940ffffe,$01820ee0,$990ffffe,$01820cc0
		dc.l	$9a0ffffe,$018200ee,$9b0ffffe,$018200aa
		dc.l	$9e0ffffe,$01820ee0,$a20ffffe,$01820cc0
		dc.l	$a30ffffe,$018200ee,$a40ffffe,$018200aa
		dc.l	$a70ffffe,$01820ee0,$ab0ffffe,$01820cc0
		dc.l	$ac0ffffe,$018200ee,$ad0ffffe,$018200aa
		dc.l	$b00ffffe,$01820ee0,$b40ffffe,$01820cc0
		dc.l	$b50ffffe,$018200ee,$b60ffffe,$018200aa
		dc.l	$b90ffffe,$01820ee0,$bd0ffffe,$01820cc0
		dc.l	$be0ffffe,$018200ee,$bf0ffffe,$018200aa
		dc.l	$c20ffffe,$01820ee0,$c60ffffe,$01820cc0
		dc.l	$c70ffffe,$018200ee,$c80ffffe,$018200aa
		dc.l	$cb0ffffe,$01820ee0,$cf0ffffe,$01820cc0
		dc.l	$d00ffffe,$018200ee,$d10ffffe,$018200aa
		dc.l	$d40ffffe,$01820ee0,$d80ffffe,$01820cc0
		dc.l	$d90ffffe,$018200ee,$da0ffffe,$018200aa
		dc.l	$dd0ffffe,$01820ee0,$e10ffffe,$01820cc0
		dc.l	$e20ffffe,$018200ee,$e30ffffe,$018200aa
		dc.l	$e60ffffe,$01820ee0,$ea0ffffe,$01820cc0
		dc.l	$eb0ffffe,$018200ee,$ec0ffffe,$018200aa
		dc.l	$ef0ffffe,$01820ee0,$f30ffffe,$01820cc0
		dc.l	$f40ffffe,$018200ee,$f50ffffe,$018200aa
		dc.l	$f80ffffe,$01820ee0,$fc0ffffe,$01820cc0
		dc.l	$fd0ffffe,$018200ee,$fe0ffffe,$018200aa
*---------------------------------------------------------------------------*
		dc.l	$ffdffffe,$01000200
		dc.l	$050ffffe,$0180082a
		dc.l	$060ffffe,$01800000
*---------------------------------------------------------------------------*
		dc.l	-2,-2			; end of copperlist
*****************************************************************************
	section	diskdata,data_c
*****************************************************************************
logo_bmap:	incbin	"images/ab_faction.raw"
mt_data:	incbin	"music/ab_cool(pt).mod"
font8_data:	incbin	"fonts/ab_font8"
*****************************************************************************
	section	bssdata,bss_c
*****************************************************************************
textbuffer:	ds.b	(screenwidth-6)*20
textbmap:	ds.b	screenwidth*pageheight
