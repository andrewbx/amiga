/* Shutdown Amiexpress Nodes */

if ~Show("L","rexxsupport.library") then do
 if Addlib("rexxsupport.library",0,-30,0) then NOP
 else do
   call showerror("This script needs the rexxsupport.library to work properly.")
   exit 20
 end
end

parse arg node
address 'AmiExpress_Node.'node; 'shutdown';

parse arg portname .

if portname='' then
   portname='DOPUS.1'
address value portname

options results
options failat 21

lf='0a'x

dopus request '"Node "'node'" shutdown successfully"'lf'"Connect to terminal or net? " Term|Net|Cancel'
 if rc=2 address command 'rx >nil: comms:internet/miami/linkup.rexx'
 if rc=1 address command 'rx >nil: comms:term/termup.rexx'
 
END_PROG:
 exit
