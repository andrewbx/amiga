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
AUConfig = DoorPath"GroupDir/GroupDir.CFG"
DirPath = "CONFS:Conf_08/"
NoOfDirs = 1
GroupNo = 0
/*---------------------------------------------------------------------------*/
/* Initialise Variables                                                      */
/*---------------------------------------------------------------------------*/
Tr=Transmit; GChar=GetChar; PUser=PutUser; PUstr=PutUstr
Sm=SendMessage; GUser=GetUser; CLS="0c"x; CR="0d"x
GUser 144; Date=Result; Pos=1; ForeGr=10; Guser 131; CArg=Result
NrOfSets=18
/*---------------------------------------------------------------------------*/
/* Parameter Check - If Parameter was specified correctly run it!!!          */
/*---------------------------------------------------------------------------*/
/*Carg=Right(Carg,1)
Carg=Upper(Strip(Carg))
 If Carg~='W' Then do
   Option=Carg
   Call SELECTED
   Call PROG_EXIT
 End*/
/*---------------------------------------------------------------------------*/
PROG_MAIN:
 Call BACKGROUND; Call DRAWMENU
 GChar; Option=upper(Result)
 Call SELECTED
/* Do n=1 to NrOfSets
 If Option=n Then Call SELECTED
 End*/
 Select
  When Option="Q" Then do
    Sm "[21;52H[35mQuit!"
    IF Exists("T:GD_DIR"NoOfDirs".Bak") Then Do
      Address command "COPY T:GD_DIR1.Bak TO" DirPath"DIR1"
      Address command "DELETE T:GD_DIR#?.#?"
    End
    Call PROG_EXIT
  End
  When Option=CR Then do; Sm "[21;52H[35mAborted!"; Call PROG_EXIT; End
  Otherwise Call PROG_MAIN
 End
/*---------------------------------------------------------------------------*/
DRAWMENU:
  Sm "[21;11H[37m[32m[[33m1-"NrOfSets"[32m][34m=[36mSelect Group [32m[[33mA[32m][34m=[36mFlags [32m[[33mQ[32m][34m=[36mQuit ? "
  Sm "[23;11H[36mAwaiting Command..."
  Do o=1 to NrOfSets
   Row_c=o+ForeGr
    GroupNo=o
    IF GroupNo > 9 Then Do
    Row_d=Row_c-9
    Sm "["Row_d";40H[33m"GroupNo
    End
    Else Do
    Sm "["Row_c";10H[33m0"GroupNo
    End
  End
    Sm "[11;14H[32mFlood"
    Sm "[12;14H[32mCrux"
    Sm "[13;14H[32mBadKarma"
    Sm "[14;14H[32mHellfire"
    Sm "[15;14H[32mTristar+RedSector"
    Sm "[16;14H[32mSkid Row"
    Sm "[17;14H[32mAfterShock"
    Sm "[18;14H[32mAnthrox"
    Sm "[19;14H[32mData Division"
    Sm "[11;44H[32mDigital Corruption"
    Sm "[12;44H[32mDecision"
    Sm "[13;44H[32mRoyal"
    Sm "[14;44H[32mLSD"
    Sm "[15;44H[32mOutlaws"
    Sm "[16;44H[32mSunFlex"
    Sm "[17;44H[32mSaints"
    Sm "[18;44H[32mShelter"
    Sm "[19;44H[32mSunset"
    Sm "[21;52H[1 p"
RETURN
/*---------------------------------------------------------------------------*/
SELECTED:
 If Option="A" then do; pustr "A"; Sm "[25;1H"; Puser 508; Call PROG_MAIN; End
 If Option=1 Then do; DirName="dir"NoOfDirs".flood"; Call CHANGEDIR; End
 If Option=2 Then do; DirName="dir"NoOfDirs".crux"; Call CHANGEDIR; End
 If Option=3 Then do; DirName="dir"NoOfDirs".bk"; Call CHANGEDIR; End
RETURN

CHANGEDIR:
If Exists(DirPath"DIR1") Then Do
  Address command "COPY" DirPath"DIR1 TO T:GD_DIR1.Bak"
End
Address command "COPY" DirPath||DirName "TO" DirPath"DIR1"
Sm "[23;11H[36mDirectory [35m- [33m"upper(DirName)" [35m-[36m Currently Selected"
Call ACTION
RETURN

ACTION:
  Sm "[21;55H[0 p"
  Sm "[21;11H[32m[[33mZ[32m][34m=[36mSearch [32m[[33mR[32m][34m=[36mList [32m[[33mD[32m][34m=[36mD/L [32m[[33mU[32m][34m=[36mU/L ?            [0m"
  Sm "[21;49H[1 p"
  GetChar; Act=upper(result)
  Sm "[25;1H"
  if act="U" then do; pustr "U"; Puser 508; Call PROG_MAIN; End
  if act="D" then do; pustr "D"; Puser 508; Call PROG_MAIN; End
  if act="Z" then do; pustr "Z"; Puser 508; Call PROG_MAIN; End
  if act="R" then do; pustr "FR"; Puser 508; Call PROG_MAIN; End
RETURN

/*---------------------------------------------------------------------------*/
/* BackGround Template                                                       */
/*---------------------------------------------------------------------------*/
BACKGROUND:
Sm CLS
Sm "[0;40m[2J[H[0 p"
Sm ""CR"[B"
Sm ""CR"[B"
Sm ""CR"[B"
Sm ""CR"[B"
Sm "                        [44m [0m [44m [0m [44;37m gROUP -[43;30m- LiSTER v0.1 [0m [43m [0m [43m [0;34m"CR"[B"
Sm ""CR"[B"
Sm "[34m                                                                    |"CR"[B"
Sm "        .--+--------------------------+--+--------------------------o- -"CR"[B"
Sm "        |[35mNo[34m| [35mGroup Name               [34m|[35mNo[34m| [35mGroup Name               [34m|"CR"[B"
Sm "        |--|--------------------------|--|--------------------------|"CR"[B"
Sm "        |  |                          |  |                          |"CR"[B"
Sm "        |  |                          |  |                          |"CR"[B"
Sm "        |  |                          |  |                          |"CR"[B"
Sm "        |  |                          |  |                          |"CR"[B"
Sm "        |  |                          |  |                          |"CR"[B"
Sm "        |  |                          |  |                          |"CR"[B"
Sm "        |  |                          |  |                          |"CR"[B"
Sm "        |  |                          |  |                          |"CR"[B"
Sm "        |  :                          :  :                          |"CR"[B"
Sm "        |--+--------------------------+--+--------------------------|"CR"[B"
Sm "        |                                                           |"CR"[B"
Sm "        |-----------------------------------------------------------|"CR"[B"
Sm "        |                                                           |"CR"[B"
Sm "        `-----------------------------------------------------------'"CR"[B"
RETURN

/*---------------------------------------------------------------------------*/
/* Error Signals                                                             */
/*---------------------------------------------------------------------------*/
IOERR:  Tr ""
        Tr "I/O Error! Non-Existent File Or Directory"
        Call PROG_EXIT
ERROR:
SYNTAX: Tr "Error in Line.. <#"sigl">" errortext(sigl)
        Call PROG_EXIT
         
S_OVER: Tr ""
        Tr "Error! Max Number of Settings Allowed is <9>"

/*---------------------------------------------------------------------------*/
/* ShutDown Procedure                                                        */
/*---------------------------------------------------------------------------*/
PROG_EXIT: Tr ""
           Tr "[28;0H[1 p"
           Bufferflush; ShutDown; Exit
           End
