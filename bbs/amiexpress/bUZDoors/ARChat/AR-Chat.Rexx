/*---------------------------------------------------------------------------*/
/*      AR Sysop Chat Screens 0.1 BETA @1997 - bUZ ^ dATA dIVISION ^ AR      */
/*---------------------------------------------------------------------------*/

Parse Arg Node
Options Results
Nodeid="AERexxControl"Node
Address Value Nodeid

Signal on ERROR
Signal on SYNTAX
Signal on IOERR

DoorPath="DOORS:bUZDoors/ARChat/"
ScreenPath=DoorPath"Screens/"
SysopChoice=" Press [1]=Normal [2]=Nice [3]=Tired [4]=Helpful [5]=Nasty [6]=Busy "
Gu=GetUser
Pu=PutUser
Pt=PutUstr
Tr=Transmit
CLS="0c"x
CR="0d"x

Gu 100; UserName=RESULT
Gu 102; Location=RESULT
Gu 122; PreLines=RESULT
Gu 144; TimeDate=RESULT

PROG_S:
Pt 29; Pu 122; Pu 522; Tr ""; Tr ""
Pt "[33mSYSOP [32m-[0m"SysopChoice; Pu 10
GetChar; Opt=RESULT
 Select
  When Opt="2" Then Do; FileName=ScreenPath"STARTCHAT2.TXT"; Call DISPLAYFILE; End
  When Opt="3" Then Do; FileName=ScreenPath"STARTCHAT3.TXT"; Call DISPLAYFILE; End
  When Opt="4" Then Do; FileName=ScreenPath"STARTCHAT4.TXT"; Call DISPLAYFILE; End
  When Opt="5" Then Do; FileName=ScreenPath"STARTCHAT5.TXT"; Call DISPLAYFILE; End
  When Opt="6" Then Do; FileName=ScreenPath"STARTCHAT6.TXT"; Call DISPLAYFILE; End
  Otherwise Do
   FileName=ScreenPath"STARTCHAT1.TXT"
   Call DISPLAYFILE
  End  
 End
Pt PreLines; Pu 122
Call PROG_E

DISPLAYFILE:
If ~Exists(FileName) Then
 Do
   Pt FileName" Not Found! "; Pu 10
   RETURN
 End
Tr CLS
Pt FileName; Pu 8
Pt TimeDate" Sysop jumped in for a chat with "USERNAME" from "LOCATION" "; Pu 150
RETURN

IOERR:  Tr ""
        Tr "[31mI/O Error![36m Non-Existent File Or Directory"
        Call PROG_E

ERROR:  Tr ""
SYNTAX: Tr "[36mError in Line.. [34m<[37m#"sigl"[34m>[36m" errortext(sigl)
        Call PROG_E

PROG_E: BufferFlush; Shutdown; Exit
