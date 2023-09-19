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
sf = showfile
cls = d2c('12')
 
/* Put in your paths for the screens here */

Screen.1 = screenpath'Screen2.txt'
Screen.2 = screenpath'Screen2.txt'
Screen.3 = screenpath'Screen3.txt'
Screen.4 = screenpath'Screen4.txt'
Screen.5 = screenpath'Screen5.txt'

/* Start of main program */

  tr ''
  randnum = random(1,noofscreens,time(s))
  selected = Screen.randnum
  if ~exists(selected) then
    tr '[36mUnable to locate file[33m' selected '[0m'
  else
    tr cls
    sf Selected
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