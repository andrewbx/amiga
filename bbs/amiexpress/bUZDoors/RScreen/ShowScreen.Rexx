/* Random Screen Log-Off Door - bUZ ^ dATA dIVISION */

parse arg node
options results
address value 'AERexxControl'node

signal on error
signal on syntax
signal on ioerr

noofscreens = 5
screenpath = 'DOORS:bUZDoors/RScreen/'
tr = transmit
sm = sendmessage
cls = d2c('12')
CR="0d"x 

/* Put in your paths for the screens here */

Screen.1 = screenpath'Private.txt'

/* Start of main program */

  tr ''
  if exists(Screen.1) then do
    open(fil,Screen.1,"R")
  sm cls
  do i=1 to 105
    textscreen=(readln(fil))
    sm textscreen||CR||"[B"
  end
  close(fil) 
  end
  call endprog
end:

/* Error Calls */

error_o:
  tr
  tr "Error in Line #"Sigl" : exiting ..."
  tr ERRORTEXT(Sigl)
  call endprog
    
error:	call error_o
syntax:	call error_o
ioerr:	call error_o
  
/* End of Program */

endprog:
  tr ""
  shutdown
  exit
end