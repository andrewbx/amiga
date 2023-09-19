/*---------------------------------------------------------------------------*/
/*    Ami-User Settings Version 0.2 BETA @1997 - bUZ ^ dATA dIVISION ^ AR    */
/*---------------------------------------------------------------------------*/

Parse Arg Node
Options Results
Address Value 'AERexxControl'Node

Signal on SYNTAX
Signal on ERROR
Signal on IOERR

/*---------------------------------------------------------------------------*/
/* DOOR Paths                                                                */
/*---------------------------------------------------------------------------*/
DoorPath = "DOORS:bUZDoors/"
AUConfig = DoorPath"AUSettings/AU_Settings.CFG"
/*---------------------------------------------------------------------------*/
/* Initialise Variables                                                      */
/*---------------------------------------------------------------------------*/
Tr=Transmit; GChar=GetChar; PUser=PutUser; PUstr=PutUstr
Sm=SendMessage; GUser=GetUser; CLS="0c"x; CR="0d"x
GUser 144; Date=Result; Pos=1; ForeGr=9; Guser 131; CArg=Result
MainLine="[0mPlease Select [32m[[33m1- [32m][36m=[0mSetting [32m[[33mQ[32m][36m=[0mQuit ? "
Cfg_Line="[0mPlease Select [32m[[33mS[32m][36m=[0mChange Setting, [32m[[33mC[32m][36m=[0mChange Comment ? "

/*---------------------------------------------------------------------------*/
/* Open Configuration File - READ ONLY                                       */
/*---------------------------------------------------------------------------*/
If Exists(AUConfig) Then Do
 Open(CFG,AUConfig,"R")
  NrOfSets=Strip(Readln(CFG))
  If NrOfSets > 9 Then do; Call S_OVER; End
   If NrOfSets < 10 Then
     Exclude=9-NrOfSets
   Else
     Exclude=1
   Strip(Readln(CFG))
   Do a=1 to NrOfSets; Setting.a=Strip(Readln(CFG)); End
   Do x=1 to Exclude; Strip(Readln(CFG)); End
   Strip(Readln(CFG))
   Do b=1 to NrOfSets; Comment.b=Strip(Readln(CFG)); End
   Do x=1 to Exclude; Strip(Readln(CFG)); End
   Strip(Readln(CFG))
   Do c=1 to NrOfSets; Command.c=Strip(Readln(CFG)); End
 Close(CFG)
End
Else Do
  Call IOERR
End

/*---------------------------------------------------------------------------*/
/* Parameter Check - If Parameter was specified correctly run it!!!          */
/*---------------------------------------------------------------------------*/
Carg=Right(Carg,1)
Carg=Upper(Strip(Carg))
 If Carg='C' Then do; Call AU_CFG; Call PROG_EXIT; End
 If Carg~='W' Then do; Option=Carg; Call SELECTED; Call PROG_EXIT; End
/*---------------------------------------------------------------------------*/
PROG_MAIN:
 Call BACKGROUND
 Sm "[21;11H"MainLine
 Sm "[21;28H[33m"NrOfSets
 Call DRAWMENU
 GChar; Option=upper(Result)
 Do n=1 to NrOfSets
  If Option=n Then Call SELECTED
 End
 Select
  When Option="Q" Then do; Sm "[21;50H[35m - Quit! -"; Call PROG_EXIT; End
  When Option=CR Then do; Sm "[21;50H[35m - Aborted! -"; Call PROG_EXIT; End
  Otherwise Call PROG_MAIN
 End
/*---------------------------------------------------------------------------*/
DRAWMENU:
  Do o=1 to NrOfSets
   Row_c=o+ForeGr
    Sm "["Row_c";15H[36m"Setting.o
    Sm "["Row_c";42H[0m"Comment.o
    Sm "["Row_c";11H[32m[[33m"o"[32m]"
  End
  Sm "[21;50H[1 p"
RETURN
/*---------------------------------------------------------------------------*/
SELECTED:
Do s=1 to NrOfSets
 If Option=s Then do; Sm "[21;50H[36m"Option; Sm CLS; PUstr Command.s
  If Command.s="W" Then
    PUser 136
  Else
    PUser 508
 End
End
RETURN

AU_CFG:
Sm CLS
 Call BACKGROUND
 Sm "[21;11H"Cfg_Line
 Call DRAWMENU
RETURN

/*---------------------------------------------------------------------------*/
/* BackGround Template                                                       */
/*---------------------------------------------------------------------------*/
BACKGROUND:
Sm CLS
Sm "[0;40m[2J[H"
Sm "[0 p        [36m:"CR"[B"
Sm " [35m_ _ [36m__[32m/ [36m\________[35m __ _ _ _  _  _  _"CR"[B"
Sm "     [32m\  o  [36m/  [32m|  [36m/  [35m."CR"[B"
Sm " .   [32m/  [36m_  \  [32m:  [36m\ [35m-+-"CR"[B"
Sm "-+-[36m_[32m/   |   [36m\_    \ [35m:                                                [34m:"CR"[B"
Sm " [35m: [32m\  __|__  [36m/[32m__  [36m/[34m- - -                     -   -  - - - -- --- ----[36m+[34m- -"CR"[B"
Sm "    [32m\[36m/  [34m|  [32m\[36m/   [32m\[36m/     [44m [0m [44m [0m [44;36m AMI-uSER [43;30msETTINGS v0.2 [0m [43m [0m [43m [0;37m       -bETA- [34m|"CR"[B"
Sm "       <------------- ---------- ------.----- ---- --- -- -- - - - - : - -"CR"[B"
Sm "        :                              :                             :"CR"[B"
Sm "        |                              |                             |"CR"[B"
Sm "        |                              |                             |"CR"[B"
Sm "        |                              |                             |"CR"[B"
Sm "        |                              |                             |"CR"[B"
Sm "        |                              |                             |"CR"[B"
Sm "        |                              |                             |"CR"[B"
Sm "        |                              |                             |"CR"[B"
Sm "        |                              |                             |"CR"[B"
Sm "        |                              |                             |"CR"[B"
Sm "        :                              :                             :"CR"[B"
Sm "    - - : - - - - -- -- --- ---- ----- ------ ---------- ------------->"CR"[B"
Sm "        |                                                            [34m|"CR"[B"
Sm "     [34m- -[36m+[34m--- --- -- -- - - -  -   -          -   -   -   - -  -- ----+"CR"[B"
Sm "        . [35m-+ [32mCode & Design[33m: [36mbUZ[35m^[36mAR[35m^[36mDAT  [33m" Date "[35m+-"CR"[B"
RETURN

/*---------------------------------------------------------------------------*/
/* Error Signals                                                             */
/*---------------------------------------------------------------------------*/
IOERR:  Tr ""
        Tr "[31mI/O Error![36m Non-Existent File Or Directory"
        Call PROG_EXIT
ERROR:
SYNTAX: Tr "[36mError in Line.. [34m<[37m#"sigl"[34m>[36m" errortext(sigl)
        Call PROG_EXIT
         
S_OVER: Tr ""
        Tr "[31mError![36m Max Number of Settings Allowed is [34m<[37m9[34m>"

/*---------------------------------------------------------------------------*/
/* ShutDown Procedure                                                        */
/*---------------------------------------------------------------------------*/
PROG_EXIT: Tr ""
           Tr "[28;0H[1 p"
           Bufferflush; ShutDown; Exit
           End
