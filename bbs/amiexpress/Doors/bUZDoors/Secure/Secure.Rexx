/*---------------------------------------------------------------------------*/
/*   Security Login Door Version 0.1 BETA @1997 - bUZ ^ dATA dIVISION ^ AR   */
/*---------------------------------------------------------------------------*/
Parse Arg Node
Options Results
Address Value 'AERexxControl'Node

Signal on SYNTAX
Signal on ERROR

ScreenPath="BBS:Screens/Node/"
PassWord="GSPOT"
ShellPass="GIMMYCLI"
Sysop1="sORCEROR"
Sysop2="cat"
Username="   "
VER="0.1"

/*---------------------------------------------------------------------------*/
/* Initialise Variables                                                      */
/*---------------------------------------------------------------------------*/
Tr=Transmit; GChar=GetChar; PUser=PutUser; PUstr=PutUstr
Sf=ShowFile; Sm=SendMessage; GUser=GetUser; CLS="0c"x; CR="0d"x
GUser 505; Baud=Result; Row=4; Column=23; Retries=5

/*---------------------------------------------------------------------------*/
PROG_MAIN:
 Call BACKGROUND
 
LOGIN_PHASE:
 Query "Login: "; Login=upper(Result)
 If Login=PassWord Then do; Call PROG_EXIT; End
 If Login="BUZ" Then do; Username=Sysop1; Call ENTER_SHELL; End
 If Login="CAT" Then do; Username=Sysop2; Call ENTER_SHELL; End
 Call PW_INPUT
/*---------------------------------------------------------------------------*/
PW_RETRY:
 Sm ""CR"[B"
 Address Command "Wait 1"
 Sm ""CR"[B"
 Sm "*** Bad PassWord ***"CR"[B"
 Sm ""CR"[B"
 Retries=Retries-1
 If Retries<=0 Then
   Call INVALID_LOGIN
 Else
   Call LOGIN_PHASE
/*---------------------------------------------------------------------------*/
PW_INPUT:
  Sm "Password: "
    Do i=1 to 25
    GChar; PW=result
    If PW=CR Then Call PW_RETRY
    sm "."
    End
RETURN
/*---------------------------------------------------------------------------*/
BACKGROUND:
 Sm CLS
 Sm "[0;40m[2J[H"
 Sm "[0 p"CR"[B"
 Sm "Welcome to DataNET. This system is for private members only."CR"[B"
 Sm ""CR"[B"
 Sm "Checking Free Terminal"
  do i=1 to 5
   if column>27 then
      Sm "["row";"column"H[0m."
   Else
      Address Command "Wait 1"
      Sm "["row";"column"H[0m."
    Column=column+1
  End
 Sm "["row";"column"H[0mOK"CR"[B"
 Sm ""CR"[B"
 Sm "Current Baud rate "Baud""CR"[B"
 Sm ""CR"[B"
 Address Command "Wait 1"
RETURN
/*---------------------------------------------------------------------------*/
INVALID_LOGIN:
 Sm "Login Incorrect."CR"[B"
 PUser 511
 Call PROG_EXIT

/*---------------------------------------------------------------------------*/
ENTER_SHELL:
 Sm ""CR"[B"
 Query "Prove you are [33m"Username"[0m - what is the password? > "; Passy=Upper(Result)
 If Passy=ShellPass Then do
   PUstr Username
   PUser 100
   PUstr "HELL"
   PUser 508
 End
 Call PROG_EXIT

/*---------------------------------------------------------------------------*/
/* Error Signals                                                             */
/*---------------------------------------------------------------------------*/
ERROR:
SYNTAX: Tr "[36mError in Line.. [34m<[37m#"sigl"[34m>[36m" errortext(sigl)
        Call PROG_EXIT

/*---------------------------------------------------------------------------*/
/* ShutDown Procedure                                                        */
/*---------------------------------------------------------------------------*/
PROG_EXIT: Tr "[1 p"
           Bufferflush; ShutDown; Exit
           End
