*********************************************************************
** Hardware Registers
*********************************************************************
bltddat		equ	$0000	; Blitter Destination Data (DMA only)
dmaconr		equ	$0002	; DMA Enable Read
vposr		equ	$0004	; Vertical Beam Position Read
vhposr		equ	$0006	; Vert/Horiz Beam Position Read
dskdatr		equ	$0008	; Disk Data Read (DMA only)
joy0dat		equ	$000a	; Joystick/Mouse Port 0 Data (read)
joy1dat		equ	$000c	; Joystick/Mouse Port 1 Data (read)
clxdat		equ	$000e	; Collision Data (read)
adkconr		equ	$0010	; Audio/Disk Control Read
pot0dat		equ	$0012	; Pot Port 0 Data Read
pot1dat		equ	$0012	; Pot Port 1 Data Read
potgor		equ	$0016	; Pot Port Data Read
serdatr		equ	$0018	; Serial Data Input and Status Read
dskbytr		equ	$001a	; Disk Data Byte and Disk Status Read
intenar		equ	$001c	; Interrupt Enable (read)
intreqr		equ	$001e	; Interrupt Request (read)
dskpt		equ	$0020	; Disk Pointer (write)
dskpth		equ	dskpt
dskptl		equ	dskpt+2
dsklen		equ	$0024	; Disk Data Length
dskdat		equ	$0026	; Disk DMA Write
refptr		equ	$0028	; Refresh Pointer (write) DON'T USE!
vposw		equ	$002a	; Vert Beam Position Write DON'T USE!
vhposw		equ	$002c	; Vert/Horiz Beam Pos Write DON'T USE!
copcon		equ	$002e	; Coprocessor Control
serdat		equ	$0030	; Serial Data Output (write)
serper		equ	$0032	; Serial Period & Data Bit Control (write)
potgo		equ	$0034	; Pot Port Data (write)
joytest		equ	$0036	; JOY0DAT and JOY1DAT Write
strequ		equ	$0038	; Short Frame Vertical Strobe
strvbl		equ	$003a	; Normal Vertical Blank Stobe
strhor		equ	$003c	; Horizontal Sync Strobe
strlong		equ	$003e	; Long Raster Strobe
bltcon0		equ	$0040	; Blitter Control Register 0 (write)
bltcon1		equ	$0042	; Blitter Control Register 1 (write)
bltafwm		equ	$0044	; Source A First Word Mask (write)
bltalwm		equ	$0046	; Source A Last Word Mask (write)
bltcpt		equ	$0048	; Blitter Source C Pointer (write)
bltcpth		equ	bltcpt
bltcptl		equ	bltcpt+2
bltbpt		equ	$004c	; Blitter Source B Pointer (write)
bltbpth		equ	bltbpt
bltbptl		equ	bltbpt+2
bltapt		equ	$0050	; Blitter Source A Pointer (write)
bltapth		equ	bltapt
bltaptl		equ	bltapt+2
bltdpt		equ	$0054	; Blitter Destination Pointer (write)
bltdpth		equ	bltdpt
bltdptl		equ	bltdpt+2
bltsize		equ	$0058	; Blitter Start and Size (write)

bltcmod		equ	$0060	; Blitter Source C Modulo (write)
bltbmod		equ	$0062	; Blitter Source B Modulo (write)
bltamod		equ	$0064	; Blitter Source A Modulo (write)
bltdmod		equ	$0066	; Blitter Destination Modulo (write)

bltcdat		equ	$0070	; Blitter Source C Data (write)
bltbdat		equ	$0072	; Blitter Source B Data (write)
bltadat		equ	$0074	; Blitter Source A Data (write)

dsksync		equ	$007e	; Disk Sync Pattern (write)
cop1lc		equ	$0080	; Copper Program Counter 1 (write)
cop1lch		equ	cop1lc
cop1lcl		equ	cop1lc+2
cop2lc		equ	$0084	; Copper Program Counter 2 (write)
cop2lch		equ	cop2lc
cop2lcl		equ	cop2lc+2
copjmp1		equ	$0088	; Copper Jump Strobe 1
copjmp2		equ	$0088	; Copper Jump Strobe 2
copins		equ	$008c	; Copper Instruction Identity (write)
diwstrt		equ	$008e	; Display Window Start (write)
diwstop		equ	$0090	; Display Window Stop (write)
ddfstrt		equ	$0092	; Display Data Fetch Start (write)
ddfstop		equ	$0094	; Display Data Fetch Stop (write)
dmacon		equ	$0096	; DMA Control (write)
clxcon		equ	$0098	; Collision Control (write)
intena		equ	$009a	; Interrupt Enable (write)
intreq		equ	$009c	; Interrupt Request (write)
adkcon		equ	$009e	; Audio/Disk Control (write)
aud0lc		equ	$00a0	; Channel 0 Waveform Address (write)
aud0lch		equ	aud0lc
aud0lcl		equ	aud0lc+2
aud0len		equ	$00a4	; Channel 0 Waveform Length (write)
aud0per		equ	$00a6	; Channel 0 Period (write)
aud0vol		equ	$00a8	; Channel 0 Volume (write)
aud0dat		equ	$00aa	; Channel 0 Data (write)

aud1lc		equ	$00b0	; Channel 1 Waveform Address (write)
aud1lch		equ	aud1lc
aud1lcl		equ	aud1lc+2
aud1len		equ	$00b4	; Channel 1 Waveform Length (write)
aud1per		equ	$00b6	; Channel 1 Period (write)
aud1vol		equ	$00b8	; Channel 1 Volume (write)
aud1dat		equ	$00ba	; Channel 1 Data (write)

aud2lc		equ	$00c0	; Channel 2 Waveform Address (write)
aud2lch		equ	aud2lc
aud2lcl		equ	aud2lc+2
aud2len		equ	$00c4	; Channel 2 Waveform Length (write)
aud2per		equ	$00c6	; Channel 2 Period (write)
aud2vol		equ	$00c8	; Channel 2 Volume (write)
aud2dat		equ	$00ca	; Channel 2 Data (write)

aud3lc		equ	$00d0	; Channel 3 Waveform Address (write)
aud3lch		equ	aud3lc
aud3lcl		equ	aud3lc+2
aud3len		equ	$00d4	; Channel 3 Waveform Length (write)
aud3per		equ	$00d6	; Channel 3 Period (write)
aud3vol		equ	$00d8	; Channel 3 Volume (write)
aud3dat		equ	$00da	; Channel 3 Data (write)

bpl1pt		equ	$00e0	; Bitplane 1 Pointer (write)
bpl1pth		equ	bpl1pt
bpl1ptl		equ	bpl1pt+2
bpl2pt		equ	$00e4	; Bitplane 2 Pointer (write)
bpl2pth		equ	bpl2pt
bpl2ptl		equ	bpl2pt+2
bpl3pt		equ	$00e8	; Bitplane 3 Pointer (write)
bpl3pth		equ	bpl3pt
bpl3ptl		equ	bpl3pt+2
bpl4pt		equ	$00ec	; Bitplane 4 Pointer (write)
bpl4pth		equ	bpl4pt
bpl4ptl		equ	bpl4pt+2
bpl5pt		equ	$00f0	; Bitplane 5 Pointer (write)
bpl5pth		equ	bpl5pt
bpl5ptl		equ	bpl5pt+2
bpl6pt		equ	$00f4	; Bitplane 6 Pointer (write)
bpl6pth		equ	bpl6pt
bpl6ptl		equ	bpl6pt+2

bplcon0		equ	$0100	; Bitplane Control Register 0 (write)
bplcon1		equ	$0102	; Bitplane Control Register 1 (write)
bplcon2		equ	$0104	; Bitplane Control Register 2 (write)

bpl1mod		equ	$0108	; Bitplane Modulo 1 (write)
bpl2mod		equ	$010a	; Bitplane Modulo 2 (write)

bpl1dat		equ	$0110	; Bitplane Data Register 1 (write)
bpl2dat		equ	$0112	; Bitplane Data Register 2 (write)
bpl3dat		equ	$0114	; Bitplane Data Register 3 (write)
bpl4dat		equ	$0116	; Bitplane Data Register 4 (write)
bpl5dat		equ	$0118	; Bitplane Data Register 5 (write)
bpl6dat		equ	$011a	; Bitplane Data Register 6 (write)

spr0pt		equ	$0120	; Sprite Pointer 0 (write)
spr0pth		equ	spr0pt
spr0ptl		equ	spr0pt+2
spr1pt		equ	$0124	; Sprite Pointer 1 (write)
spr1pth		equ	spr1pt
spr1ptl		equ	spr1pt+2
spr2pt		equ	$0128	; Sprite Pointer 2 (write)
spr2pth		equ	spr2pt
spr2ptl		equ	spr2pt+2
spr3pt		equ	$012c	; Sprite Pointer 3 (write)
spr3pth		equ	spr3pt
spr3ptl		equ	spr3pt+2
spr4pt		equ	$0130	; Sprite Pointer 4 (write)
spr4pth		equ	spr4pt
spr4ptl		equ	spr4pt+2
spr5pt		equ	$0134	; Sprite Pointer 5 (write)
spr5pth		equ	spr5pt
spr5ptl		equ	spr5pt+2
spr6pt		equ	$0138	; Sprite Pointer 6 (write)
spr6pth		equ	spr6pt
spr6ptl		equ	spr6pt+2
spr7pt		equ	$013c	; Sprite Pointer 7 (write)
spr7pth		equ	spr7pt
spr7ptl		equ	spr7pt+2

spr0pos		equ	$0140	; Sprite Position 0 (write)
spr0ctl		equ	$0142	; Sprite Control 0 (write)
spr0data	equ	$0144	; Sprite Data A Register 0 (write)
spr0datb	equ	$0146	; Sprite Data B Register 0 (write)
spr1pos		equ	$0148	; Sprite Position 1 (write)
spr1ctl		equ	$014a	; Sprite Control 1 (write)
spr1data	equ	$014c	; Sprite Data A Register 1 (write)
spr1datb	equ	$014e	; Sprite Data B Register 1 (write)
spr2pos		equ	$0150	; Sprite Position 2 (write)
spr2ctl		equ	$0152	; Sprite Control 2 (write)
spr2data	equ	$0154	; Sprite Data A Register 2 (write)
spr2datb	equ	$0156	; Sprite Data B Register 2 (write)
spr3pos		equ	$0158	; Sprite Position 3 (write)
spr3ctl		equ	$015a	; Sprite Control 3 (write)
spr3data	equ	$015c	; Sprite Data A Register 3 (write)
spr3datb	equ	$015e	; Sprite Data B Register 3 (write)
spr4pos		equ	$0160	; Sprite Position 4 (write)
spr4ctl		equ	$0162	; Sprite Control 4 (write)
spr4data	equ	$0164	; Sprite Data A Register 4 (write)
spr4datb	equ	$0166	; Sprite Data B Register 4 (write)
spr5pos		equ	$0168	; Sprite Position 5 (write)
spr5ctl		equ	$016a	; Sprite Control 5 (write)
spr5data	equ	$016c	; Sprite Data A Register 5 (write)
spr5datb	equ	$016e	; Sprite Data B Register 5 (write)
spr6pos		equ	$0170	; Sprite Position 6 (write)
spr6ctl		equ	$0172	; Sprite Control 6 (write)
spr6data	equ	$0174	; Sprite Data A Register 6 (write)
spr6datb	equ	$0176	; Sprite Data B Register 6 (write)
spr7pos		equ	$0178	; Sprite Position 7 (write)
spr7ctl		equ	$017a	; Sprite Control 7 (write)
spr7data	equ	$017c	; Sprite Data A Register 7 (write)
spr7datb	equ	$017e	; Sprite Data B Register 7 (write)

color00		equ	$0180	; Color Register 0 (write)
color01		equ	$0182	; Color Register 1 (write)
color02		equ	$0184	; Color Register 2 (write)
color03		equ	$0186	; Color Register 3 (write)
color04		equ	$0188	; Color Register 4 (write)
color05		equ	$018a	; Color Register 5 (write)
color06		equ	$018c	; Color Register 6 (write)
color07		equ	$018e	; Color Register 7 (write)
color08		equ	$0190	; Color Register 8 (write)
color09		equ	$0192	; Color Register 9 (write)
color10		equ	$0194	; Color Register 10 (write)
color11		equ	$0196	; Color Register 11 (write)
color12		equ	$0198	; Color Register 12 (write)
color13		equ	$019a	; Color Register 13 (write)
color14		equ	$019c	; Color Register 14 (write)
color15		equ	$019e	; Color Register 15 (write)
color16		equ	$01a0	; Color Register 16 (write)
color17		equ	$01a2	; Color Register 17 (write)
color18		equ	$01a4	; Color Register 18 (write)
color19		equ	$01a6	; Color Register 19 (write)
color20		equ	$01a8	; Color Register 20 (write)
color21		equ	$01aa	; Color Register 21 (write)
color22		equ	$01ac	; Color Register 22 (write)
color23		equ	$01ae	; Color Register 23 (write)
color24		equ	$01b0	; Color Register 24 (write)
color25		equ	$01b2	; Color Register 25 (write)
color26		equ	$01b4	; Color Register 26 (write)
color27		equ	$01b6	; Color Register 27 (write)
color28		equ	$01b8	; Color Register 28 (write)
color29		equ	$01ba	; Color Register 29 (write)
color30		equ	$01bc	; Color Register 30 (write)
color31		equ	$01be	; Color Register 31 (write)
beamcon0	equ	$01dc	; Video Beam Control 0 (write)

*********************************************************************
** CIA addresses
*********************************************************************

CIAA		equ	$bfe001	; CIAA base address
CIAB		equ	$bfd000	; CIAB base address
PRA		equ	$000	; Peripheral Data Register for port A
PRB		equ	$100	; Peripheral Data Register for port B
DDRA		equ	$200	; Data Direction Register A
DDRB		equ	$300	; Data Direction Register B
TALO		equ	$400	; Timer A Low Byte
TAHI		equ	$500	; Timer A High Byte
TBLO		equ	$600	; Timer B Low Byte
TBHI		equ	$700	; Timer B High Byte
TODLO		equ	$800	; TOD Counter Low Byte
TODMID		equ	$900	; TOD Counter Mid Byte
TODHI		equ	$a00	; TOD Counter High Byte
TODHR		equ	$b00	; Unused
SDR		equ	$c00	; Serial Data Register
ICR		equ	$d00	; Interrupt Control Register
CRA		equ	$e00	; Control Register A
CRB		equ	$f00	; Control Register B

****************************************************
**	Macro:	   INSBMAP
**	Author:    Andrew
**	Version:   V1
**	Date:	   20/07/95
**-------------------------------------------------
**	Registers affected D0/D7 - A0/A1
**
**	SCREENWIDTH  = Width of your screen
**	SCREENHEIGHT = Height of your screen
**
**	Usage:-
**	
**	INSBMAP	   (PicAddress,NoOfPlanes,BMAP_Ptrs)
**
****************************************************

INSBMAP		MACRO
		MoveM.l	D0/D7/A0-A1,-(SP)
		PEA	\3
		PEA	\1
		MoveM.l	(SP)+,A0/A1
		Move.l	A0,D0
		MoveQ	#\2,D7
.NextPlane	Tst.w	D7
		Beq.s	.NoMorePlanes
		Move.w	D0,6(A1)
		Swap	D0
		Move.w	D0,2(A1)
		Swap	D0
		Addi.l	#(SCREENWIDTH*SCREENHEIGHT),D0
		AddQ.w	#8,A1
		SubQ.w	#1,D7
		Bra.s	.NextPlane
.NoMorePlanes	MoveM.l	(SP)+,D0/D7/A0-A1
		ENDM

****************************************************
** Wait Vertical Blank - Needs $DFF000 in A5
****************************************************

WAITVBLANK	MACRO
\@1		Btst.b	#0,$05(A5)
		Bne.b	\@1
		NOP
\@2		Btst.b	#0,$05(A5)
		Beq.b	\@2
		ENDM
		
****************************************************
** Wait for Blitter - Needs Valid GFXBase Pointer
**		      Defined as _GFXBase
****************************************************

WaitForBlitter	MACRO
		Move.l	_GFXBase(PC),A6
		CALL	WaitBlit
		ENDM

****************************************************
** Exec_Lib.i
****************************************************

_LVOSupervisor		EQU	-30
_LVOInitCode		EQU	-72
_LVOInitStruct		EQU	-78
_LVOMakeLibrary		EQU	-84
_LVOMakeFunctions	EQU	-90
_LVOFindResident	EQU	-96
_LVOInitResident	EQU	-102
_LVOAlert		EQU	-108
_LVODebug		EQU	-114
_LVODisable		EQU	-120
_LVOEnable		EQU	-126
_LVOForbid		EQU	-132
_LVOPermit		EQU	-138
_LVOSetSR		EQU	-144
_LVOSuperState		EQU	-150
_LVOUserState		EQU	-156
_LVOSetIntVector	EQU	-162
_LVOAddIntServer	EQU	-168
_LVORemIntServer	EQU	-174
_LVOCause		EQU	-180
_LVOAllocate		EQU	-186
_LVODeallocate		EQU	-192
_LVOAllocMem		EQU	-198
_LVOAllocAbs		EQU	-204
_LVOFreeMem		EQU	-210
_LVOAvailMem		EQU	-216
_LVOAllocEntry		EQU	-222
_LVOFreeEntry		EQU	-228
_LVOInsert		EQU	-234
_LVOAddHead		EQU	-240
_LVOAddTail		EQU	-246
_LVORemove		EQU	-252
_LVORemHead		EQU	-258
_LVORemTail		EQU	-264
_LVOEnqueue		EQU	-270
_LVOFindName		EQU	-276
_LVOAddTask		EQU	-282
_LVORemTask		EQU	-288
_LVOFindTask		EQU	-294
_LVOSetTaskPri		EQU	-300
_LVOSetSignal		EQU	-306
_LVOSetExcept		EQU	-312
_LVOWait		EQU	-318
_LVOSignal		EQU	-324
_LVOAllocSignal		EQU	-330
_LVOFreeSignal		EQU	-336
_LVOAllocTrap		EQU	-342
_LVOFreeTrap		EQU	-348
_LVOAddPort		EQU	-354
_LVORemPort		EQU	-360
_LVOPutMsg		EQU	-366
_LVOGetMsg		EQU	-372
_LVOReplyMsg		EQU	-378
_LVOWaitPort		EQU	-384
_LVOFindPort		EQU	-390
_LVOAddLibrary		EQU	-396
_LVORemLibrary		EQU	-402
_LVOOldOpenLibrary	EQU	-408
_LVOCloseLibrary	EQU	-414
_LVOSetFunction		EQU	-420
_LVOSumLibrary		EQU	-426
_LVOAddDevice		EQU	-432
_LVORemDevice		EQU	-438
_LVOOpenDevice		EQU	-444
_LVOCloseDevice		EQU	-450
_LVODoIO		EQU	-456
_LVOSendIO		EQU	-462
_LVOCheckIO		EQU	-468
_LVOWaitIO		EQU	-474
_LVOAbortIO		EQU	-480
_LVOAddResource		EQU	-486
_LVORemResource		EQU	-492
_LVOOpenResource	EQU	-498
_LVORawDoFmt		EQU	-522
_LVOGetCC		EQU	-528
_LVOTypeOfMem		EQU	-534
_LVOProcure		EQU	-540
_LVOVacate		EQU	-546
_LVOOpenLibrary		EQU	-552
_LVOInitSemaphore	EQU	-558
_LVOObtainSemaphore	EQU	-564
_LVOReleaseSemaphore	EQU	-570
_LVOAttemptSemaphore	EQU	-576
_LVOObtainSemaphoreList	EQU	-582
_LVOReleaseSemaphoreList	EQU	-588
_LVOFindSemaphore	EQU	-594
_LVOAddSemaphore	EQU	-600
_LVORemSemaphore	EQU	-606
_LVOSumKickData		EQU	-612
_LVOAddMemList		EQU	-618
_LVOCopyMem		EQU	-624
_LVOCopyMemQuick	EQU	-630
_LVOCacheClearU		EQU	-636
_LVOCacheClearE		EQU	-642
_LVOCacheControl	EQU	-648
_LVOCreateIORequest	EQU	-654
_LVODeleteIORequest	EQU	-660
_LVOCreateMsgPort	EQU	-666
_LVODeleteMsgPort	EQU	-672
_LVOObtainSemaphoreShared	EQU	-678
_LVOAllocVec		EQU	-684
_LVOFreeVec		EQU	-690
_LVOCreatePrivatePool	EQU	-696
_LVODeletePrivatePool	EQU	-702
_LVOAllocPooled		EQU	-708
_LVOFreePooled		EQU	-714
_LVOAttemptSemaphoreShared	EQU	-720
_LVOColdReboot		EQU	-726
_LVOStackSwap		EQU	-732
_LVOChildFree		EQU	-738
_LVOChildOrphan		EQU	-744
_LVOChildStatus		EQU	-750
_LVOChildWait		EQU	-756
_LVOCachePreDMA		EQU	-762
_LVOCachePostDMA	EQU	-768

****************************************************
** Graphics_Lib.i
****************************************************

_LVOBltBitMap		EQU	-30
_LVOBltTemplate		EQU	-36
_LVOClearEOL		EQU	-42
_LVOClearScreen		EQU	-48
_LVOTextLength		EQU	-54
_LVOText		EQU	-60
_LVOSetFont		EQU	-66
_LVOOpenFont		EQU	-72
_LVOCloseFont		EQU	-78
_LVOAskSoftStyle	EQU	-84
_LVOSetSoftStyle	EQU	-90
_LVOAddBob		EQU	-96
_LVOAddVSprite		EQU	-102
_LVODoCollision		EQU	-108
_LVODrawGList		EQU	-114
_LVOInitGels		EQU	-120
_LVOInitMasks		EQU	-126
_LVORemIBob		EQU	-132
_LVORemVSprite		EQU	-138
_LVOSetCollision	EQU	-144
_LVOSortGList		EQU	-150
_LVOAddAnimOb		EQU	-156
_LVOAnimate		EQU	-162
_LVOGetGBuffers		EQU	-168
_LVOInitGMasks		EQU	-174
_LVODrawEllipse		EQU	-180
_LVOAreaEllipse		EQU	-186
_LVOLoadRGB4		EQU	-192
_LVOInitRastPort	EQU	-198
_LVOInitVPort		EQU	-204
_LVOMrgCop		EQU	-210
_LVOMakeVPort		EQU	-216
_LVOLoadView		EQU	-222
_LVOWaitBlit		EQU	-228
_LVOSetRast		EQU	-234
_LVOMove		EQU	-240
_LVODraw		EQU	-246
_LVOAreaMove		EQU	-252
_LVOAreaDraw		EQU	-258
_LVOAreaEnd		EQU	-264
_LVOWaitTOF		EQU	-270
_LVOQBlit		EQU	-276
_LVOInitArea		EQU	-282
_LVOSetRGB4		EQU	-288
_LVOQBSBlit		EQU	-294
_LVOBltClear		EQU	-300
_LVORectFill		EQU	-306
_LVOBltPattern		EQU	-312
_LVOReadPixel		EQU	-318
_LVOWritePixel		EQU	-324
_LVOFlood		EQU	-330
_LVOPolyDraw		EQU	-336
_LVOSetAPen		EQU	-342
_LVOSetBPen		EQU	-348
_LVOSetDrMd		EQU	-354
_LVOInitView		EQU	-360
_LVOCBump		EQU	-366
_LVOCMove		EQU	-372
_LVOCWait		EQU	-378
_LVOVBeamPos		EQU	-384
_LVOInitBitMap		EQU	-390
_LVOScrollRaster	EQU	-396
_LVOWaitBOVP		EQU	-402
_LVOGetSprite		EQU	-408
_LVOFreeSprite		EQU	-414
_LVOChangeSprite	EQU	-420
_LVOMoveSprite		EQU	-426
_LVOLockLayerRom	EQU	-432
_LVOUnlockLayerRom	EQU	-438
_LVOSyncSBitMap		EQU	-444
_LVOCopySBitMap		EQU	-450
_LVOOwnBlitter		EQU	-456
_LVODisownBlitter	EQU	-462
_LVOInitTmpRas		EQU	-468
_LVOAskFont		EQU	-474
_LVOAddFont		EQU	-480
_LVORemFont		EQU	-486
_LVOAllocRaster		EQU	-492
_LVOFreeRaster		EQU	-498
_LVOAndRectRegion	EQU	-504
_LVOOrRectRegion	EQU	-510
_LVONewRegion		EQU	-516
_LVOClearRectRegion	EQU	-522
_LVOClearRegion		EQU	-528
_LVODisposeRegion	EQU	-534
_LVOFreeVPortCopLists	EQU	-540
_LVOFreeCopList		EQU	-546
_LVOClipBlit		EQU	-552
_LVOXorRectRegion	EQU	-558
_LVOFreeCprList		EQU	-564
_LVOGetColorMap		EQU	-570
_LVOFreeColorMap	EQU	-576
_LVOGetRGB4		EQU	-582
_LVOScrollVPort		EQU	-588
_LVOUCopperListInit	EQU	-594
_LVOFreeGBuffers	EQU	-600
_LVOBltBitMapRastPort	EQU	-606
_LVOOrRegionRegion	EQU	-612
_LVOXorRegionRegion	EQU	-618
_LVOAndRegionRegion	EQU	-624
_LVOSetRGB4CM		EQU	-630
_LVOBltMaskBitMapRastPort	EQU	-636
_LVOAttemptLockLayerRom	EQU	-654
_LVOGfxNew		EQU	-660
_LVOGfxFree		EQU	-666
_LVOGfxAssociate	EQU	-672
_LVOBitMapScale		EQU	-678
_LVOScalerDiv		EQU	-684
_LVOTextExtent		EQU	-690
_LVOTextFit		EQU	-696
_LVOGfxLookUp		EQU	-702
_LVOVideoControl	EQU	-708
_LVOOpenMonitor		EQU	-714
_LVOCloseMonitor	EQU	-720
_LVOFindDisplayInfo	EQU	-726
_LVONextDisplayInfo	EQU	-732
_LVOGetDisplayInfoData	EQU	-756
_LVOFontExtent		EQU	-762
_LVOReadPixelLine8	EQU	-768
_LVOWritePixelLine8	EQU	-774
_LVOReadPixelArray8	EQU	-780
_LVOWritePixelArray8	EQU	-786
_LVOGetVPModeID		EQU	-792
_LVOModeNotAvailable	EQU	-798
_LVOWeighTAMatch	EQU	-804
_LVOEraseRect		EQU	-810
_LVOExtendFont		EQU	-816
_LVOStripFont		EQU	-822

****************************************************

CALL	MACRO
	JSR	_LVO\1(A6)
	ENDM
	
****************************************************
gb_Actiview   EQU	$22
gb_Copinit    EQU	$26
Int3_Vector   EQU	$06C
AttnFlags     EQU	$128

_AbsExecBase  EQU	$4
_LeftMouse    EQU	6
_RightMouse   EQU	2

CLRBITS	      EQU	$7FFF
****************************************************
