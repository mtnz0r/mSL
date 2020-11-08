; ---------------------------------------------
;  Telnet & Eggdrop Party Line Client for mIRC
;  Version 3.0 (December 16th, 2003)
;  Improved by westor to auto-respond to IRC 
;  server PING with the appropriate PONG and
;  to optionally hide server PING and the MOTD
; ---------------------------------------------

; ---------
;  PREFACE
; ---------
;
; This little mIRC script allows you to log into Eggdrop robots via DCC or
; Telnet with a very convinient interface. Passive DCC connections are
; also supported (ie. /CTCP <botnick> CHAT).
;
; The Telnet function may also be used to access various textual,
; line-based Internet services via mIRC. This could be useful for people
; who wish to explore Internet protocols such as HTTP or even IRC.
;
; The script attempts to simulate mIRC's behavior as much as possible.
; I worked very hard on the ease-of-use as well as the robustness of this
; script. If you find any bug or flaw, please tell me about it using the
; Email address below.
;
; Note: Only one Telnet window can be open for any combination of hostname
; and port. In the same manner, only one Login/PLogin window can be open
; for any given nickname. This is so because only one custom window may be
; opened for a given name, and I didn't want to clutter the window names
; with ID numbers.
;
; Have fun! :-)
; - Rotem "axen" E <rotem@siterush.com>

; -------------------
;  SETUP / UNINSTALL
; -------------------
;
; To install, just place this script file (eggdrop.mrc) in your mIRC's
; main folder (typically C:\Program Files\mIRC\), then just type the
; following command in any mIRC window: /load -rs eggdrop.mrc
; That's it, the script is loaded/installed.
;
; UNINSTALLING THE SCRIPT:
; To unload (uninstall) the script, just type the following command in any
; mIRC window: /unload -rs eggdrop.mrc
;
; Note: You can also load and unload the script by pressing Alt+R in mIRC,
; which opens the "Remote" section of the mIRC Editor. To load the script,
; click "File -> Load -> Script" and select this file (eggdrop.mrc).
; To unload the script, select the script file with "View -> eggdrop.mrc"
; (it may already be selected), and then click "File -> Unload".

; -------
;  USAGE
; -------
;
;   For Telnet, type:       /telnet <hostname> <port>
;   For DCC, type:          /login  <botnick>
;   For Passive DCC, type:  /plogin <botnick>
;
; To close a connection, simply close the connection's window.
; Alternatively, you can right-click within the window's background and
; select "Disconnect" from the menu, or use the /disc command.
;
; Also see configuration section below.
;
; For advanced users:
; You can send your password without leaving any track of it (the password
; won't be printed in the window and the editbox history will be cleared).
; To do so, type /pw <password> when you are asked for your password.
; This command also sends ".whom *" to the Eggdrop automatically.
;

; ---------------
;  CONFIGURATION
; ---------------
;
; 1. COLORS:
; Change the number after "return" to 0 in the following line if you wish
; to disable colors for the Eggdrop party line. You may change it back to
; 1 at any time to immediately re-enable the coloring.
; If you intend on using this script for any purpose other than accessing
; Eggdrop party lines, disable this option.
 
alias eggconf.color { return 1 }

 
; 2. ECHO:
; Change the number after "return" to 0 in the following line if you wish
; to disable the "echoing" of your own text lines. You may change it back
; to 1 at any time to immediately re-enable the echoing.
 
alias eggconf.echo { return 1 }

 
; 3. PLOGIN TIMEOUT (Advanced Users):
; When using the Passive DCC Login, how many seconds should we wait for
; the bot's DCC Chat request until we give up? The default setting (one
; minute) should be fine, unless the IRC network is in a major lag.
; Valid settings: 5 through 1000 (natural numbers only).
 
alias eggconf.time { return 60 }

 
; 4. AUTO /PW (Advanced Users):
; Setting this will automatically prefix your editbox with "/pw " when
; the Eggdrop sends the line "Enter your password." - quite convenient.
; See the "Usage" section above for details about the /pw command.
 
alias eggconf.pw { return 0 }

; 5. Hide PINGs
; Hide (IRCd-sided) PINGs (to avoid it getting spammy and hiding 
; relevant backlog
 
alias hideping {
  if ($1 == $null) { echo -at Hideping is set to %hideping | return }
 
  if ($1 == on) { set %hideping on | echo -at Hideping is set to %hideping }
  if ($1 == off) { set %hideping off | echo -at Hideping is set to %hideping }
}

;6. Hide MOTD
; Hide the output of MOTD as most server/network rules are pretty much
; the same/universal or close to it
 
alias hidemotd {
  if ($1 == $null) { echo -at Hidemotd is set to %hidemotd | return }
 
  if ($1 == on) { set %hidemotd on | echo -at Hidemotd is set to %hidemotd }
  if ($1 == off) { set %hidemotd off | echo -at Hidemotd is set to %hidemotd }
}

;7 Automatically register connection (NICK/USER)
; Define a default NICK and USER to use when automatically registering
; the connection, also toggle whether to automatically register or not
 
alias rawregister {
  if ($1 == $null) { echo -at Autoregister is set to %rawregister | return }
 
  if ($1 == on) { set %rawregister on | echo -at Autoregister is set %rawregister }
  if ($1 == off) { set %rawregister off | echo -at Autoregister is set to %rawregister }
}
 
alias rawident {
  if ($1 == $null) { echo -at Rawident is set to %rawident | return }
 
  set %rawident $1
 
  echo -at Rawident is set to %rawident
}
 
alias rawgecos {
  if ($1 == $null) { echo -at Rawgecos is set to %rawgecos | return }
 
  set %rawgecos $1- 
 
  echo -at Rawgecos is set to %rawgecos 
}
 
alias rawnick {
  if ($1 == $null) { echo -at Rawnick is set to %rawnick | return }
 
  set %rawnick $1
 
  echo -at Rawnick is set to %rawnick
}

; END OF CONFIGURATION.
;
; DON'T CHANGE ANYTHING BELOW UNLESS YOU KNOW WHAT YOU'RE DOING!
;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 
; *** USER COMMANDS:
 
alias telnet {
  if ($1 isnum) || ($2 !isnum 1-100000) || ($2 == $null) || ($3 != $null) { egg.echo Usage: /telnet <hostname> <port> | return }
 
  var %temp = $+($1,:,$2)
  var %win = @ $+ %temp
 
  if ($sock(telnet. $+ %temp)) {
    if ($window(%win)) { window -a %win | return }
 
    sockclose telnet. $+ %temp 
  }
 
  if ($window(%win)) { window -a %win }
  else { window -ek0 %win @telnet }
 
  echo $colour(Info2) %win Telnet session
 
  linesep %win
 
  echo %win Hostname: $1 port $2
  echo %win Time: $asctime(ddd mmm dd) $time $asctime(yyyy)
 
  if (+ isin $2) { 
    linesep %win
 
    echo $colour(Ctcp) %win Connecting to host... (SSL: Yes)
 
    sockopen -e telnet. $+ %temp $1 $remove($2,+)
 
    return
  }
 
  linesep %win 
 
  echo $colour(Ctcp) %win Connecting to host...
 
  sockopen telnet. $+ %temp $1 $2
}
 
alias login {
  if ($1 == $null) || ($2 !== $null) { egg.echo * Usage: /login <botnick> | return }
 
  var %win = @ $+ $1 
 
  if ($sock(prelogin. $+ $1)) || ($sock(login. $+ $1)) || ($sock(plogin. $+ $1)) {
    if ($window(%win)) { window -a %win | return }
 
    sockclose $ifmatch
  }
 
  if ($window(%win)) { window -a %win }
  else { window -ek0 %win @login }
 
  echo $colour(Info2) %win Logging into $1
  echo $colour(Ctcp) %win Waiting for acknowledgement...
 
  socklisten prelogin. $+ $1
 
  var %ctcp = DCC CHAT chat $longip($ip) $sock(prelogin. $+ $1).port
 
  quote -q PRIVMSG $1 $+(:,$chr(1),%ctcp,$chr(1))
}
 
alias plogin {
  if ($1 == $null) || ($2 != $null) { egg.echo * Usage: /plogin <botnick> | return }
 
  var %win = $+(@,$1)
 
  if ($sock(prelogin. $+ $1)) || ($sock(login. $+ $1)) || ($sock(plogin. $+ $1)) {
    if ($window(%win)) { window -a %win | return }
 
    sockclose $ifmatch
  }
 
  if ($window(%win)) { window -a %win }
  else { window -ek0 %win @login }
 
  echo $colour(Info2) %win Logging into $1 (Passive)
  echo $colour(Ctcp) %win Requesting for a DCC Chat request...
 
  var %time = $iif($eggconf.time isnum 5-1000,$ifmatch,60)
 
  .timerplogin. $+ $1 1 %time plogin.timeout $1
 
  quote -q PRIVMSG $1 $+(:,$chr(1),CHAT,$chr(1))
}
 
alias pw {
  if (!$1) || ($left($active,1) !== @) { beep 1 | return }
 
  var %temp = $egg.getsock($active)
 
  if (!%temp) || ($sock(%temp).status !== active) { beep 1 | return }
 
  clear -h 
 
  sockwrite -n %temp $$1- 
  sockwrite -n %temp .whom * 
}
 
alias disc {
  if ($1) || ($left($active,1) !== @) { return }
 
  var %temp = $remove($active,@)
  var %sock = $egg.getsock($active) 
 
  if (!%sock) { beep 1 | return }
 
  var %status = $sock(%sock).status 
 
  sockclose %sock
 
  .timerplogin. $+ %temp off
 
  var %temp = $iif(((%status == listening) || (%status == connecting)),canceled,closed)
 
  linesep 
 
  echo $colour(Ctcp) -a Connection %temp
}

 
; *** PASSIVE LOGIN STUFF:
; *** Specific code for the Passive Login function.

; Receiving the bot's DCC Chat request.
ctcp *:DCC CHAT chat *:?:{
  var %win = $+(@,$nick) 
 
  if (!$timer(plogin. $+ $nick)) || (!$window(%win)) { return }
  if ($sock(prelogin. $+ $nick)) || ($sock(login. $+ $nick)) || ($sock(plogin. $+ $nick)) { return }
 
  haltdef
 
  .timerplogin. $+ $nick off
 
  var %ip = $longip($$4) 
  var %port = $$5
 
  linesep %win 
 
  echo $colour(Info2) %win Received a DCC Chat request from $nick
 
  linesep %win
 
  echo %win Hostname: %ip port %port
  echo %win Time: $asctime(ddd mmm dd) $time $asctime(yyyy)
 
  linesep %win
 
  echo $colour(Ctcp) %win Connecting to host...
 
  sockopen plogin. $+ $nick %ip %port
}

; We didn't get a DCC Chat request. Bummer.
alias plogin.timeout {
  var %win = @ $+ $$1 
  var %time = $iif($eggconf.time isnum 5-1000,$ifmatch,60)
 
  if ($window(%win)) { linesep %win | echo $colour(Ctcp) %win Login aborted: No DCC Chat request in %time seconds. }
}

 
; *** SOCKET CONTROL:
; *** Internet connections and traffic.

; Passive connections (Telnet/PLogin): Opening or failing to open.
on *:SOCKOPEN:*.*:{
  if (telnet.*:* !iswm $sockname) && (plogin.* !iswm $sockname) { return }
 
  var %win = @ $+ $gettok($sockname,2-,46)
 
  if (!$window(%win)) { sockclose $sockname | return }
 
  if ($sockerr > 0) { linesep %win | echo $colour(Ctcp) %win Connection failed | return }
 
  echo $colour(Ctcp) %win Connection established 
 
  linesep %win
 
  if ($gettok($insert($remove(%win,@),telnet.,0),2,46) == irc) && (%rawregister == on) { sockwrite -nt $insert($remove(%win,@),telnet.,0) NICK %rawnick }
  if ($gettok($insert($remove(%win,@),telnet.,0),2,46) == irc) && (%rawregister == on) { sockwrite -nt $insert($remove(%win,@),telnet.,0) USER %rawident %user2ndparam %user3rdparam : $+ %rawgecos }
 
}

; Active connections (Login): Opening or failing to open.
on *:SOCKLISTEN:prelogin.*:{
  var %newsock = login. $+ $gettok($sockname,2,46) 
  var %win = @ $+ $gettok($sockname,2,46)
 
  if ($sock(%newsock)) || (!$window(%win)) { sockclose $sockname | return }
 
  sockaccept %newsock
  sockclose $sockname
 
  if ($sockerr > 0) { linesep %win | echo $colour(Ctcp) %win Connection failed | return }
 
  echo $colour(Ctcp) %win Connection established
 
  linesep %win
}

; All connections (Telnet/Login/PLogin): Receiving data.
on *:SOCKREAD:*.*:{
  if (telnet.*:* !iswm $sockname) && (login.* !iswm $sockname) && (plogin.* !iswm $sockname) { return }
 
  var %win = @ $+ $gettok($sockname,2-,46)
 
  if (!$window(%win)) { sockclose $sockname | return }
  if ($sockerr > 0) { echo $colour(Ctcp) %win * Error: $sockerr | return }
 
  :nextread
 
  sockread %temp
 
  if ($sockbr == 0) { return }
 
  if (!%temp) { echo -tlbfr %win $chr(160) | goto nextread }
 
  if ($gettok(%temp,1,32) == PING) { 
    sockwrite -nt $sockname PONG : $+ $remove($gettok(%temp,2-,32),:)
 
    if (%hideping == on) goto nextread 
  }
 
  if ($gettok(%temp,2,32) == 372) && (%hidemotd == on) { goto nextread }

  ;echo -st nickname is: $+ $remove($gettok(%temp,1,33),:)
  ;echo -st servername is: $+ $remove($gettok(%temp,1,32),:)
  ;if ($gettok(%temp,2,32) == 002) { echo -st IS: $gettok(%temp,10,32) }  
  ;if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :VERSION) && ($chr(46) isin $gettok(%temp,1,32)) && if UnrealIRCd !isincs $gettok(%temp,10,32)  { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) : $+ VERSION A Telnet IRC Client | echo -st servername: $remove($gettok(%temp,1,32),:) | echo -st nickname: $remove($gettok(%temp,1,33),:) }  
  ;if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :VERSION) && ($chr(46) !isin $gettok(%temp,1,33)) && if UnrealIRCd isincs $gettok(%temp,10,32) && ($gettok(%temp,1,33) === IRC) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) : $+ VERSION A Telnet IRC Client | echo -st servername: $remove($gettok(%temp,1,32),:) | echo -st nickname: $remove($gettok(%temp,1,33),:) }
  ;if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :VERSION) && ($chr(46) !isin $gettok(%temp,1,33)) && if UnrealIRCd isincs $gettok(%temp,10,32) && ($gettok(%temp,1,33) !== IRC) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) : $+ VERSION A Telnet IRC Client | echo -st nickname: $remove($gettok(%temp,1,33),:) | echo -st servername: $remove($gettok(%temp,1,32),:) }
  ;if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :VERSION) && ($chr(46) !isin $gettok(%temp,1,33)) && if UnrealIRCd !isincs $gettok(%temp,10,32) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) : $+ VERSION A Telnet IRC Client | echo -st nickname: $remove($gettok(%temp,1,33),:) | echo -st servername: $remove($gettok(%temp,1,32),:) } 
 
  if ($gettok(%temp,2,32) == PRIVMSG) && (($gettok(%temp,4,32) == :PING) || ($gettok(%temp,4,32) == :PING)) && ($chr(46) isin $gettok(%temp,1,32)) && ($chr(33) !isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) : $+ PING $gettok(%temp,5-,32) $+  }   
  if ($gettok(%temp,2,32) == PRIVMSG) && (($gettok(%temp,4,32) == :PING) || ($gettok(%temp,4,32) == :PING)) && ($chr(46) !isin $gettok(%temp,1,33)) && ($chr(33) isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) : $+ PING $gettok(%temp,5-,32) $+  }
 
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :TIME) && ($chr(46) isin $gettok(%temp,1,32)) && ($chr(33) !isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) : $+ TIME $+ $date $+ $chr(32) $+ $time $+  }  
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :TIME) && ($chr(46) !isin $gettok(%temp,1,33)) && ($chr(33) isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) : $+ TIME $+ $date $+ $chr(32) $+ $time $+  }
 
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :VERSION) && ($chr(46) isin $gettok(%temp,1,32)) && ($chr(33) !isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) :VERSION A Terminal IRC Client }  
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :VERSION) && ($chr(46) !isin $gettok(%temp,1,33)) && ($chr(33) isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) :VERSION A Terminal IRC Client }

  ;if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :VERSION) && ($chr(46) isin $gettok(%temp,1,32)) && ($chr(33) !isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) : $+ VERSION A Telnet IRC Client }  
  ;if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :VERSION) && ($chr(46) !isin $gettok(%temp,1,33)) && ($chr(33) isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) : $+ VERSION A Telnet IRC Client }
 
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :FINGER) && ($chr(46) isin $gettok(%temp,1,32)) && ($chr(33) !isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) : $+ FINGER $fullname $+ $chr(32) $+ (AdiIRC $+ $chr(32) $+ $version $+ $chr(32) $+ $bits $+ $chr(32) $+ Bit) }  
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :FINGER) && ($chr(46) !isin $gettok(%temp,1,33)) && ($chr(33) isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) : $+ FINGER $fullname $+ $chr(32) $+ (AdiIRC $+ $+ $chr(32) $+ $version $+ $chr(32) $+ $bits $+ $chr(32) $+ Bit) }
 
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :USERINFO) && ($chr(46) isin $gettok(%temp,1,32)) && ($chr(33) !isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) : $+ USERINFO $username $+ $chr(32) $+ ( $+ $fullname $+ )  }  
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :USERINFO) && ($chr(46) !isin $gettok(%temp,1,33)) && ($chr(33) isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) : $+ USERINFO $username $+ $chr(32) $+ ( $+ $fullname $+ )  }
 
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :CLIENTINFO) && ($chr(46) isin $gettok(%temp,1,32)) && ($chr(33) !isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) : $+ CLIENTINFO ABOUT ACTION CLIENTINFO DCC FINGER MACHINEGOD PING SOURCE TIME USERINFO VERSION }  
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :CLIENTINFO) && ($chr(46) !isin $gettok(%temp,1,33)) && ($chr(33) isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) : $+ CLIENTINFO ABOUT ACTION CLIENTINFO DCC FINGER MACHINEGOD PING SOURCE TIME USERINFO VERSION }
 
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :SOURCE) && ($chr(46) isin $gettok(%temp,1,32)) && ($chr(33) !isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) : $+ SOURCE https://adiirc.com/ }  
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :SOURCE) && ($chr(46) !isin $gettok(%temp,1,33)) && ($chr(33) isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) : $+ SOURCE https://adiirc.com/ }
 
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :MACHINEGOD) && ($chr(46) isin $gettok(%temp,1,32)) && ($chr(33) !isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) : $+ MACHINEGOD The machine god has $chr(2) $+ fallen $+ $chr(15) $+ , and the unbelievers $chr(31) $+ rejoiced $+ $chr(15) $+ . But from the debris rose new machines which will have their vengeance. ~The Book of Atheme, 10:31 }  
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :MACHINEGOD) && ($chr(46) !isin $gettok(%temp,1,33)) && ($chr(33) isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) : $+ MACHINEGOD The machine god has $chr(2) $+ fallen $+ $chr(15) $+ , and the unbelievers $chr(31) $+ rejoiced $+ $chr(15) $+ . But from the debris rose new machines which will have their vengeance. ~The Book of Atheme, 10:31 }
 
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :ABOUT) && ($chr(46) isin $gettok(%temp,1,32)) && ($chr(33) !isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,32),:) : $+ ABOUT http://www.findagrave.com/cgi-bin/fg.cgi?page=gr&GRid=10369601 }  
  if ($gettok(%temp,2,32) == PRIVMSG) && ($gettok(%temp,4-,32) == :ABOUT) && ($chr(46) !isin $gettok(%temp,1,33)) && ($chr(33) isin $gettok(%temp,1,32)) { sockwrite -nt $sockname NOTICE $remove($gettok(%temp,1,33),:) : $+ ABOUT http://www.findagrave.com/cgi-bin/fg.cgi?page=gr&GRid=10369601 }
 
  %temp = $replace(%temp,$chr(32),$chr(160)) 
  %temp = $egg.proc(%win,%temp)
 
  echo -tlbfr %win %temp
 
  goto nextread
}

; All connections (Telnet/Login/PLogin): Closing.
on *:SOCKCLOSE:*.*:{
  var %pre = $gettok($sockname,1,46)
 
  if (%pre != prelogin) && (%pre != login) && (%pre !== plogin) && (telnet.*:* !iswm $sockname) { return }
 
  var %win = @ $+ $gettok($sockname,2-,46)
 
  if $window(%win) { linesep %win | echo $colour(Ctcp) %win Connection closed }
}

 
; *** WINDOW CONTROL:
; *** User input in Telnet/Login/PLogin windows.
 
on *:INPUT:@:{
  if ($left($1,1) == $comchar) { return }
 
  var %sock = $egg.getsock($active)
 
  if ($sock(%sock).status !== active) { beep 1 | return }
 
  sockwrite -n %sock $1- 
 
  if ($eggconf.echo) { echo -at 14> $1- }
}
 
on *:CLOSE:@:{
  var %temp = $remove($active,@)
  var %sock = $egg.getsock($active)
 
  if (%sock) { sockclose %sock } 
  if (%temp !== Status Window) { .timerplogin. $+ %temp off }
}

; Nickname completion. Good.
on *:KEYDOWN:@:9:{
  var %temp = $gettok($editbox($active),0,32)
 
  if ($gettok($editbox($active),%temp,32) $+ * iswm $remove($active,@)) { var %nick = $remove($active,@) }
  elseif ($gettok($editbox($active),%temp,32) $+ * iswm $me) { var %nick = $me }
  else { return }
 
  dec %temp
 
  if (%temp == 0) { var %temp = 1000000 }
  else { var %temp = 1- $+ %temp }
 
  editbox $active $gettok($editbox($active),%temp,32) %nick 
 
  halt
}

 
; *** TELNET/EGGDROP LINE PROCCESSING FUNCTIONS:

; Gets rid of them nasty Telnet control characters.
alias egg.fixtel {
  var %temp = $replace($1,[1m,,[0m,,$cr,$chr(160),$+($chr(255),$chr(251),$chr(1)),$chr(160),$+($chr(255),$chr(252),$chr(1)),$chr(160)) 
 
  return %temp
}

; Eggdrop line processor. :D
alias egg.proc {
  var %win = $$1
  var %line = $$2
 
  if (<*> iswm $gettok(%line,1,160)) { window -g1 %win }
 
  if (telnet.*:* iswm $sockname) || (plogin.* iswm $sockname) { var %line = $egg.fixtel(%line) }
  if ($eggconf.color) { var %line = $egg.colorize(%line) | var %line = $egg.spaces(%line) }
 
  if (%line == Enter your password.) && ($eggconf.pw) { editbox $iif((!$editbox(%win)),-p) %win /pw $editbox(%win) }
 
  return %line
}

; Gets an Eggdrop line and returns a colored copy of it (using $egg.col).
alias egg.colorize {
  var %line = $$1- 
 
  if ($left(%line,1) == $chr(160)) { return %line }
 
  var %w1 = $gettok(%line,1,160)
  var %right = $right(%line,- $+ $len(%w1))
 
  if (<*> iswm %w1) { 
    var %w1 = $egg.col(%w1,<,>,@) 
 
    return %w1 $+ %right 
  }
 
  elseif (%w1 == ***) { return $egg.col(***) $+ %right }
  elseif (%w1 == ###) { return $egg.col(###) $+ %right }
  elseif ([*:*] iswm %w1) {
    var %w1 = $egg.col(%w1,[,])
    var %w2 = $gettok(%line,2,160)
    var %right2 = $right(%line,- $+ $len($gettok(%line,1-2,160)))
 
    if ($+($chr(40),*!*@*,$chr(41)) iswm %w2) { var %w2 = $egg.col(%w2,$chr(40),$chr(41)) }
    elseif (#*# iswm %w2) { var %w2 = $egg.col(%w2,$chr(35)) }
    else { return %w1 $+ %right }
 
    return %w1 %w2 $+ %right2
  }
 
  return %line
}

; Returns $1 with any occurrence of $2-$n colored, or just $1 colored.
alias egg.col {
  var %b = $chr(2)
  var %k = $chr(3)
  var %o = $chr(15)
 
  if (!$2) { return $+(%b,%k,10,$1,%o) }
 
  var %word = $1
  var %str = $2
  var %i = 2
 
  while (%str) { 
    var %word = $replace(%word,%str,$+(%b,%k,10,%str,%o))
 
    inc %i 
 
    var %str = $eval($ $+ %i,2) 
  } 
 
  return %word
}

; Gets rid of 160 where possible. Yes, I know this is redundant. =\
alias egg.spaces {
  var %line = $1
  var %i = 2
  var %len = $len(%line)
 
  while ($right(%line,1) == $chr(160)) && (%line !== $chr(160)) { var %line = $left(%line,-1) }
 
  while (%i < %len) {
    if ($mid(%line,%i,1) !== $chr(160)) { inc %i | continue }
 
    if ($mid(%line,$calc(%i - 1),1) !== $chr(160)) && ($mid(%line,$calc(%i + 1),1) != $chr(160)) { var %line = $mid(%line,1,$calc(%i - 1)) $mid(%line,$calc(%i + 1)) }
 
    inc %i 2
  }
 
  return %line
}

 
; *** MISC. STUFF:

; Gets a window name and returns the full sockname matching it, if any.
alias egg.getsock {
  var %temp = $remove($$1,@)
 
  if ($sock(telnet. $+ %temp)) { return $+(telnet,.,%temp) }
  elseif ($sock(prelogin. $+ %temp)) { return $+(prelogin,.,%temp) }
  elseif ($sock(login. $+ %temp)) { return $+(login,.,%temp) } 
  elseif ($sock(plogin. $+ %temp)) { return $+(plogin,.,%temp) }
  else { return 0 } 
}

; Cancels Login/PLogin if the specified nickname isn't on IRC.
raw 401:*:{
  if ($window(@ $+ $2).cid == $cid) {
    var %win = @ $+ $2
    if ($sock(prelogin. $+ $2)) { var %what = Login | sockclose prelogin. $+ $2 }
    elseif ($timer(plogin. $+ $2)) { var %what = PLogin | .timerplogin. $+ $2 off }
    else { return }
 
    linesep %win
 
    echo -c Ctcp %win %what aborted: $2- 
  }
}

; Checks whether a window is "idle" or not. Used in right-click menus.
alias egg.idle {
  if (!$egg.getsock($1)) && (!$timer(plogin. $+ $remove($1,@))) { return 1 } 
 
  return 0
}

; Bad parameters error report.
alias egg.echo { echo $colour(Info) $iif(($active == Status Window),-ae,-a) * $1- }

 
; *** RIGHT-CLICK MENUS:

; Telnet: Connect/Disconnect buttons.
menu @telnet   {
  $iif((!$egg.idle($active)),$style(2)) Connect:telnet $replace($remove($active,@),$chr(58),$chr(32))
  $iif(($egg.idle($active)),$style(2)) Disconnect:disc
}

; Login/PLogin: Similar to DCC Chats, with Connect/Disconnect buttons.
menu @login   {
  dclick:whois $remove($active,@)
  Info:uwho $remove($active,@)
  Whois:whois $remove($active,@)
  -
  CTCP
  .Ping:ctcp $remove($active,@) PING
  .Time:ctcp $remove($active,@) TIME
  .Version:ctcp $remove($active,@) VERSION
  DCC
  .Send:dcc send $remove($active,@)
  .Chat:dcc chat $remove($active,@)
  -
  $iif((!$egg.idle($active)),$style(2)) Login:login $remove($active,@)
  $iif((!$egg.idle($active)),$style(2)) PLogin:plogin $remove($active,@)
  $iif(($egg.idle($active)),$style(2)) Disconnect:disc
}
