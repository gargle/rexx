/**************************************************************************
 **************************************************************************
 **************************************************************************

  REXX BS2000 V.3.1.
  (C) 26-01-2000 by Betton

  This program requires the rxSock dll function library for regina

 **************************************************************************
 **************************************************************************
 **************************************************************************/



trace on



/**************************************************************************
  FLAGS
 **************************************************************************/

F._log = 0                                     /* F._log = 1 -> log on    */

/**************************************************************************
  CONSTANTS
 **************************************************************************/

C._EMDUE = "66" /* EM DUE */
C._DUE   = "67" /* DUE    */

C._K1    = "53" /* K1     */
C._K2    = "54" /* K2     */
C._K3    = "55" /* K3     */
C._K4    = "56" /* K4     */
C._K5    = "57" /* K5     */

C._F1    = "5B" /* F1     */
C._F2    = "5C" /* F2     */
C._F3    = "5D" /* F3     */
C._F4    = "5E" /* F4     */
C._F5    = "5F" /* F5     */

/**************************************************************************
  EBCDIC TO ASCII CONVERSION
  USE : string = translate("ebcdic text",C._to_ascii,)
 **************************************************************************/
C._to_ascii = x2c("00 01 02 03 7F 09 7F 7F 7F 7F 7F 0B 0C 0D 0E 0F" || ,
                  "10 11 12 13 7F 7F 08 7F 18 19 7F 7F 1C 1D 1E 1F" || ,
                  "7F 7F 7F 7F 7F 0A 17 1B 7F 7F 7F 7F 7F 05 06 07" || ,
                  "7F 7F 16 7F 7F 7F 7F 04 7F 7F 7F 7F 14 15 7F 1A" || ,
                  "20 7F 7F 7F 7F 7F 7F 7F 7F 7F 60 2E 3C 28 2B 94" || ,
                  "26 7F 7F 7F 7F 7F 7F 7F 7F 7F 21 24 2A 29 3B 7F" || ,
                  "2D 2F 7F 7F 7F 7F 7F 7F 7F 7F 5E 2C 25 5F 3E 3F" || ,
                  "7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 3A 23 15 27 3D 22" || ,
                  "7F 61 62 63 64 65 66 67 68 69 7F 7F 7F 7F 7F 7F" || ,
                  "7F 6A 6B 6C 6D 6E 6F 70 71 72 7F 7F 7F 7F 7F 7F" || ,
                  "7F 7F 73 74 75 76 77 78 79 7A 7F 7F 7F 7F 7F 7F" || ,
                  "7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 8E 99 9A 7F 7F" || ,
                  "7F 41 42 43 44 45 46 47 48 49 7F 7F 7F 7F 7F 7F" || ,
                  "7F 4A 4B 4C 4D 4E 4F 50 51 52 7F 7F 7F 7F 7F 7F" || ,
                  "7F 7F 53 54 55 56 57 58 59 5A 7F 7F 7F 7F 7F 7F" || ,
                  "30 31 32 33 34 35 36 37 38 39 7F 84 7F 81 7F E1")

/**************************************************************************
  ASCII TO EBCDIC CONVERSION
  USE : string = c2x(translate("ascii text",C._to_ebcdic,))
 **************************************************************************/
C._to_ebcdic = x2c("00 01 02 03 37 2D 2E 2F 16 05 25 0B 0C 0D 0E 0F" || ,
                   "10 11 12 13 3C 7C 32 26 18 19 3F 27 1C 1D 1E 1F" || ,
                   "40 5A 7F 7B 5B 6C 50 7D 4D 5D 5C 4E 6B 60 4B 61" || ,
                   "F0 F1 F2 F3 F4 F5 F6 F7 F8 F9 7A 5E 4C 7E 6E 6F" || ,
                   "7C C1 C2 C3 C4 C5 C6 C7 C8 C9 D1 D2 D3 D4 D5 D6" || ,
                   "D7 D8 D9 E2 E3 E4 E5 E6 E7 E8 E9 BB BC BD 6A 6D" || ,
                   "4A 81 82 83 84 85 86 87 88 89 91 92 93 94 95 96" || ,
                   "97 98 99 A2 A3 A4 A5 A6 A7 A8 A9 FB 4F FD FF 07" || ,
                   "07 FD 07 07 FB 07 07 07 07 07 07 07 07 07 BB 07" || ,
                   "07 07 07 07 4F 07 07 07 07 BC BD 07 07 07 07 07" || ,
                   "07 07 07 07 07 07 07 07 07 07 07 07 07 07 07 07" || ,
                   "07 07 07 07 07 07 07 07 07 07 07 07 07 07 07 07" || ,
                   "07 07 07 07 07 07 07 07 07 07 07 07 07 07 07 07" || ,
                   "07 07 07 07 07 07 07 07 07 07 07 07 07 07 07 07" || ,
                   "07 FF 07 07 07 07 07 07 07 07 07 07 07 07 07 07" || ,
                   "07 07 07 07 07 07 07 07 07 07 07 07 07 07 07 07")



/**************************************************************************
  GLOBALS
 **************************************************************************/

G._header_block         = ""
G._control_block        = ""
G._data_block           = ""

G._send_sequence_number = x2d("80")

G._screen.              = ""
G._screen.0             = 0



/**************************************************************************
 **************************************************************************
 **************************************************************************

  MAIN

 **************************************************************************
 **************************************************************************
 **************************************************************************/

call lineout 'bs2000.log'        /* log file of screen and raw data */
call lineout 'bs2000.log'              /* will be erased at start         */
'rm bs2000.log >nul'

/**************************************************************************
  Install RxSock, open a socket to the server and connect to the server
 **************************************************************************/

/* setup socket package */
if RxFuncQuery("SockLoadFuncs") then
do
  rc = RxFuncAdd("SockLoadFuncs", "RxSock", "SockLoadFuncs")
  rc = SockLoadFuncs()
end

/* get irc server address */
rc = SockGetHostByName("test.bs2000.netpost","host.!")
if (rc = 0) then
do
  say "Unable to resolve name of BS2000."
  exit
end

server = host.!addr

/* open a socket to the server */
/* sock = SockSocket("AF_INET", "SOCK_STREAM", "IPPROTO_TCP") */
sock = SockSocket("AF_INET", "SOCK_STREAM", "IPPROTO_TCP")
if (sock = -1) then
do
  say "Error opening socket: " errno
  exit
end

/* connect to server */
server.!family = "AF_INET"
server.!port   = 102
server.!addr   = server

rc = SockConnect(sock, "server.!")
if (sock = -1) then
do
  say "Error connecting socket: " errno
  exit
end



/**************************************************************************
 **************************************************************************

  Main BS2000 Conversation START

 **************************************************************************
 **************************************************************************/

/* pass on terminal-id and $dialog */
uit = "030000321DE00000000000C0010AC108"       || ,
      c2x(translate("REXX@JCL",C._to_ebcdic,)) || ,    /* 01 = partnertyp */
      "C208"                                   || ,    /* 4E = dsstyp 78  */
      c2x(translate("$DIALOG",C._to_ebcdic,))  || ,    /* a0 = charset    */
      "40FE0E018000000000000004014EA08100"             /* 81 = 2nd device */
rc = SockSend(sock, x2c(uit))
if F._log then call charout 'bs2000.log','SEND ' 
if F._log then call lineout 'bs2000.log',uit 

rc = BS2000_receive(1)

/* no idea what this is */
uit = "0300001F02F0"                   || ,
      d2x(G._send_sequence_number)     || ,
      "FD038000001700000000D200800000" || ,
      "48404030704043"||C._K1||"00"                                 /* K1 */
G._send_sequence_number = G._send_sequence_number + 1
rc = SockSend(sock, x2c(uit))
if F._log then call charout 'bs2000.log','SEND ' 
if F._log then call lineout 'bs2000.log',uit 

rc = BS2000_receive(1)
call BS2000_process G._data_block,1 
rc = BS2000_receive(1)
call BS2000_process G._data_block,1 

/* coded logon */
uit = "0300009A02F0"                                  || ,
      d2x(G._send_sequence_number)                    || ,     /* user */
      "FD038000001300000000D200800000"                || ,     /* pw   */
      "50404030704043"||C._DUE||"410000796630000040"  || ,     /* env  */
      c2x(translate("laenenj",C._to_ebcdic,)) ||copies("00",50) || ,
      c2x(translate("lj08   ",C._to_ebcdic,)) ||copies("00",50)   || ,
      c2x(translate("0",C._to_ebcdic,))
G._send_sequence_number = G._send_sequence_number + 1
rc = SockSend(sock, x2c(uit))
if F._log then call charout 'bs2000.log','SEND ' 
if F._log then call lineout 'bs2000.log',uit 

/* wait for user to log on */
call BS2000_receive_until_prompt 'nop',1 

call BS2000_send "MODIFY-TERMINAL-OPTIONS OVERFLOW=*NO-CONTROL",1 
call BS2000_receive_until_prompt 'nop',1 

call BS2000_send "STA",1 
call BS2000_receive_until_prompt 'nop',1 

call BS2000_send "STA L",1 
call BS2000_receive_until_prompt 'nop',1 

call BS2000_send "LOGOFF NOSPOOL",1 
call BS2000_receive_until_prompt 'nop',1 
signal exit



/**************************************************************************
 **************************************************************************

  Main BS2000 Conversation END

 **************************************************************************
 **************************************************************************/



/**************************************************************************
  Close socket
 **************************************************************************/
exit:
call lineout 'bs2000.log' 
rc = SockSoClose(sock)
exit



/**************************************************************************
 **************************************************************************
 **************************************************************************

   BS2000 routines

 **************************************************************************
 **************************************************************************
 **************************************************************************/

/**************************************************************************
  Receive data from a socket

  This procedure will read raw data from a socket.
  It will do this by reading first the 7 header bytes of the message.
  If the total length of the message doesn't fit in a 512 byte boundary,
  the procedure will read the next message and will add the data block
  to the block already read. The header and control bytes will stay the
  same.

  This procedure is called for by BS2000_receive.
 **************************************************************************/
BS2000_receive_raw: procedure expose sock ,
                                     C. ,
                                     G. ,
                                     F.
/* read header (length = 7 bytes) */
rc = SockRecv(sock,"G._header_block",7)
if F._log then call charout 'bs2000.log','RECV ' 
if F._log then call charout 'bs2000.log',c2x(G._header_block) 
if rc = -1 then do
  say "Error receiving header from bs2000"
  say "RC = -1"
  signal exit
end
if left(G._header_block,1) \= x2c('03') then do
  say "Error receiving dat from bs2000"
  say "No header 03 BS2000_received"
  signal exit
end
lengte = c2d(substr(G._header_block,2,3))-7
data = ""
do while length(data) \= lengte
  len = lengte - length(data)   /* calculate how many bytes still to read */
  if len > 512 then             /* with a smaximum of 512                 */
    len = 512
  rc = SockRecv(sock,"block",len)
  if F._log then call charout 'bs2000.log',c2x(block) 
  if rc = -1 then do
    say "Error receiving data from bs2000"
    say "RC = -1 during block >LEN BS2000_receive"
    signal exit
  end
  data = data||block
end
if left(data,2) = x2c("FD03") then do        /* for FD 03 80 and FD 03 90 */
  G._control_block = substr(data,1,15)
  G._data_block    = substr(data,16,)
end
else /* normally we don't get here */          /* old data block won't be */
  G._data_block    = data                      /* overwritten             */
if F._log then call lineout 'bs2000.log','' 
return (rc)

/**************************************************************************
  Receive data

  This procedure will receive data from the BS2000.
  It the header block contains a different byte sequnce than 02F080
  the procedure will read the next block until the sequence 02F080 has
  been reached.
  If the control block contains FD0390 the procedure will send a quittung
  to the BS2000.
  If the data block contains the messages that indicate a logoff because
  of a CANCEL command the procedure will stop the communication with the
  BS2000.

  The parameter screen_flag = 1 will give output on the screen.
  The parameter screen_flag = 0 will give no output on the screen.

  This procedure is called for by the main program.
 **************************************************************************/
BS2000_receive: procedure expose sock ,
                                 C. ,
                                 G. ,
                                 F.
parse arg screen_flag
/* when header block ends at 02F080 then block has been send completely   */
/* if not, thus 02F000, the block has been send incomplete and there has  */
/* to be read again to get the complete block                             */
rc = BS2000_receive_raw()
do while (c2x(substr(G._header_block,5,3)) = "02F000")
  last_block = G._data_block                        /* last control block */
  rc = BS2000_receive_raw()                         /* gets overwritten   */
  G._data_block = last_block||G._data_block
end
if substr(G._control_block,1,3) = x2c("FD0390") then do
  sub = substr(G._control_block,4,2)
  uit = "0300000C02F0"               || ,
        d2x(G._send_sequence_number) || ,
        "FC0340" || c2x(sub)                           /* ANSWER QUITTUNG */
  G._send_sequence_number = G._send_sequence_number + 1
  rc = SockSend(sock, x2c(uit))
  if F._log then call charout 'bs2000.log','SEND ' 
  if F._log then call lineout 'bs2000.log',uit 
end
/* look for logout message EXC0419 */
if pos("EXC0419",translate(G._data_block,C._to_ascii,)) > 0 then do
  call BS2000_process G._data_block,screen_flag 
  rc = BS2000_receive_raw()
  call BS2000_process G._data_block,screen_flag 
  /* look for logout message EXC0421 */
  if pos("EXC0421",translate(G._data_block,C._to_ascii,)) > 0 then do
    signal exit
  end
  else do
    say "Error receiving EXC0421 from bs2000"
    say "RC = -1"
    signal exit
  end
end
return (rc)

/**************************************************************************
  Receive data from socket until prompt has arrived
  No Acknowledge will be given

  This procedure will read data from the BS2000 until a prompt has been
  reached.

  The parameter hook \= '' will pass control to a procedure that will
     handle the incoming data.

  The parameter screen_flag = 1 will give output on the screen.
  The parameter screen_flag = 0 will give no output on the screen.

  This procedure is called for in BS2000_receive_until_prompt.
 **************************************************************************/
BS2000_receive_until_prompt_raw: procedure expose sock ,
                                                  C. ,
                                                  G. ,
                                                  F.
/* parameter HOOK    */
/* HOOK = what to do */
parse arg hook, screen_flag
rc = BS2000_receive(screen_flag)
tekst = BS2000_process(G._data_block,screen_flag)
if routine \= "" then interpret hook
data = G._data_block
/* wait for prompt to appear */
sub = substr(G._control_block,6,1)
/* if sub = x2c("33") or x2c("35") or x2c("37") -> prompt-msg from program */
/* if sub = x2c("32")                           -> BS2000 message          */
prompt = sub = x2c("33") | ,
         sub = x2c("35") | ,
         sub = x2c("37")
do while prompt \= 1
  /* sub \= x2c("33") or x2c("35") or x2c("37") */
  rc = BS2000_receive(screen_flag)
  tekst = tekst || BS2000_process(G._data_block,screen_flag)
  if routine \= "" then interpret hook
  data = data||G._data_block
  sub = substr(G._control_block,6,1)
  prompt = sub = x2c("33") | ,
           sub = x2c("35") | ,
           sub = x2c("37")
end
return tekst

/**************************************************************************
  Receive data from socket until prompt has arrived and do acknowledge

  This procedure will read data from the BS2000 until a prompt has been
  reached. Whenever the prompt contains PLEASE ACKNOWLEDGE the procedure
  will send the ACKNOWLEDGE to be BS2000.

  The parameter hook \= '' will pass control to a procedure that will
     handle the incoming data.

  The parameter screen_flag = 1 will give output on the screen.
  The parameter screen_flag = 0 will give no output on the screen.

  This procedure is called for by the main program.
 **************************************************************************/
BS2000_receive_until_prompt: procedure expose sock ,
                                              C. ,
                                              G. ,
                                              F.
/* parameter HOOK    */
/* HOOK = what to do */
parse arg hook, screen_flag
data = ""
do forever
  tekst = BS2000_receive_until_prompt_raw(hook, screen_flag)
  data = data||tekst
  if \BS2000_please_acknowledge(tekst) then
      leave
end
return data

/**************************************************************************
  Send a command to bs2000

  This procedure will send a command to the BS2000.
  It will look for a control byte in the last control block received and
  adapt the control block for the send command according to the value
  contained in the control byte of the received block.

  The parameter command contains the string that will be send.

  The parameter screen_flag = 1 will give output on the screen.
  The parameter screen_flag = 0 will give no output on the screen.

  This procedure is called for by the main program.
 **************************************************************************/
BS2000_send: procedure expose sock ,
                              C. ,
                              G. ,
                              F.
parse arg command, screen_flag
if screen_flag then call charout ,command
if F._log then call lineout 'bs2000.log',command 
if substr(G._control_block,6,1) = x2c("33") then
  control_byte = x2c("13")
else if substr(G._control_block,6,1) = x2c("37") then
  control_byte = x2c("17")
else do
  say "Error receiving control_block from bs2000"
  signal exit
end
G._control_block = substr(G._control_block,1,3) || ,
                  x2c("0000")                   || ,
                  control_byte                  || ,
                  x2c("00000000D200000000")
lengte = length(command)+35
uit = x2c("030000")||d2c(lengte)||x2c("02F0")     || ,
      d2c(G._send_sequence_number)                || ,     /* length = 07 */
      G._control_block                            || ,     /* length = 15 */
      x2c("48454030704043"||C._DUE||"411C40FFF0") || ,     /* length = 13 */
      translate(command,C._to_ebcdic,)
G._send_sequence_number = G._send_sequence_number + 1
rc = SockSend(sock, uit)
if F._log then call charout 'bs2000.log','SEND ' 
if F._log then call lineout 'bs2000.log',c2x(uit) 
return rc

/**************************************************************************
  Preprocess received text

  This procedure will preprocess the text received.

  It will look for the control bytes and bypass them completely. Only
  the control bytes indicating a CRLF or a position will be translated
  into CRLF.

  The parameter data contains the incoming data.

  The parameter screen_flag = 1 will give output on the screen.
  The parameter screen_flag = 0 will give no output on the screen.

  This procedure is called for in BS2000_receive_until_prompt_raw and by
     the main program.
 **************************************************************************/
BS2000_process: procedure expose C. ,
                                 G. ,
                                 F.
parse arg data, screen_flag
tekst = translate(data,C._to_ascii,)
start = 1
position = pos(x2c("21"),data,start)
do until position = 0
  start = position + 1
  position = pos(x2c("21"),data,start)
end
einde = length(tekst)
position = pos(x2c("2740817C"),data,1) /* system message received       */
if position > 0 then do
  start = position + 4
  einde = pos(x2c("19"),data,start)    /* these end with '19'           */
  if einde = 0 then do
    say "Error receiving system_msg from bs2000"
    signal exit
  end
  say ''                                            /* force a new line */
end
position = pos(x2c("274081C8"),data,1)
if position > 0 then do /* 2740817C0000007C7C00005A received after      */
  einde = length(tekst) /* system message                               */
  return tekst          /* nothing else follows                         */
end
do i = start until i > einde
  if substr(tekst,i,2) = x2c('1B71') then do                     /* LZE */
    tekst =  substr(tekst,1,i-1) || x2c('0D0A')||substr(tekst,i+2)
    i = i - 1
    iterate
  end
  if substr(tekst,i,1) = x2c('7f') then do
    tekst =  substr(tekst,1,i-1) || substr(tekst,i+1,)    /* PAR02E EM  */
    i = i - 1
    iterate
  end
  if substr(tekst,i,1) = x2c('19') then do                       /* EM  */
    tekst =  substr(tekst,1,i-1) || substr(tekst,i+1,)
    i = i - 1
    iterate
  end
  if substr(tekst,i,1) = x2c('1B') then do                       /* ESC */
    tekst =  substr(tekst,1,i-1) || substr(tekst,i+2,)
    i = i - 1
    iterate
  end
  if substr(tekst,i,1) = x2c('1C') then do                       /* IS4 */
    tekst =  substr(tekst,1,i-1)||x2c('0D0A')||substr(tekst,i+4,)/* ZLA */
    i = i - 1                                                    /* SPA */
    iterate                                                /* (SAD) ITB */
  end
  if substr(tekst,i,1) = x2c('1D') then do                       /* IS3 */
    tekst =  substr(tekst,1,i-1) || substr(tekst,i+2,)
    i = i - 1
    iterate
  end
  if substr(tekst,i,1) = x2c('1E') then do                       /* IS2 */
    tekst =  substr(tekst,1,i-1) || substr(tekst,i+2,)
    i = i - 1
    iterate
  end
end
/* if start \= 08 then say '' */
if screen_flag then call charout , substr(tekst,start,)
if F._log then call lineout 'bs2000.log',substr(tekst,start,) 
/* put everything in screen variables                                   */
lijn = G._screen.0
j = start
if substr(tekst,j,2) = x2c("0D0A") then     /* lines starting with CRLF */
  j = j + 2                                 /* won't be blank on screen */
do i = j
  i = pos(x2c("0D0A"),tekst,j)
  if (i \= 0) then do
    lijn = lijn + 1
    G._screen.lijn = substr(tekst,j,i-j)
    i = i + 2
    j = i
  end
  else
    leave
end
if (j <= length(tekst)) then do
  lijn = lijn + 1
  G._screen.lijn = substr(tekst,j,)
end
G._screen.0 = lijn
return tekst

/**************************************************************************
  Please Ackowlegde

  This procedure looks for the PLEASE ACKNOWLEDGE message.
  If found, it will send a K1 to the BS2000.

  The parameter data contains the incoming data.

  This procedure is called for in BS2000_receive_until_prompt
 **************************************************************************/
BS2000_please_acknowledge: procedure expose sock ,
                                            C. ,
                                            G. ,
                                            F.
parse arg data
please = 0
if pos("PLEASE ACKNOWLEDGE",data)> 0 then do
  please = 1
  uit = "0300001F02F0"                   || ,
        d2x(G._send_sequence_number)     || ,
        "FD038000001300000000D200800000" || ,
        "48454030704043" || C._K1 || "41"                           /* K1 */
  G._send_sequence_number = G._send_sequence_number + 1
  rc = SockSend(sock, x2c(uit))
  if F._log then call charout 'bs2000.log','SEND ' 
  if F._log then call lineout 'bs2000.log',uit 
end
return (please = 1)

