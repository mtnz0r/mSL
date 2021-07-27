;============================
;
;   Script made by DobbaN
;
;     Thank You zNigel-
;      for the help ;D
;
;============================

;============================
;
; Commands:
;   -addbnc
;   -addvhost
;   -delbnc
;   -resetpass
;   -suspend
;   -reject
;   -unreject
;
;============================

on *:LOAD: {

  set %bnc.chan $?="Insert the channel"
  set %bnc.host $?="Insert the host/IP"
  set %bnc.port $?="Insert the port"

  set %abc.one
  set %abc.two
  set %abc.three
  set %abc.four
  set %num.one
  set %num.two
  set %num.three
  set %num.four

  set %password

}

alias password.key {
  %abc.one = $rand(A,Z)
  %abc.two = $rand(a,z)
  %abc.three = $rand(a,z)
  %abc.four = $str(%abc.two,2)
  %num.one = $rand(1,150)
  %num.two = $rand(1,150)
  %num.three = $calc(%num.one * %num.two)
  %num.four = $int($cos(%num.three))

  %password = %abc.one $+ %num.one $+ %num.four $+ %num.three $+ %abc.four $+ %abc.three $+ %num.two $+ %abc.two
}

on 10:TEXT:*:#: {
  if ($1 == -addznc) {
    if ($2) && ($3) {
      /password.key
      msg *controlpanel adduser $2 %password
      msg *controlpanel addnetwork $2 liberachat
      msg *controlpanel set bindhost $2 185.87.24.104
      msg *controlpanel addserver $2 liberachat irc.libera.chat +6697 
      msg *controlpanel set realname $2 BNC provider #bnc4you
      msg *controlpanel set quitmsg $2 BNC by #bnc4you
      msg *controlpanel addctcp $2 version Stable BNC #bnc4you 
      msg *controlpanel addchan $2 liberachat #bnc4you
      msg *controlpanel set maxnetworks $2 5
      msg *controlpanel set ClientEncoding $2 ^UTF-8
      msg $3 Your BNC! Sponsored by #bnc4you
      msg $3 IP: freebnc.bnc4you.xyz
      msg $3 Port: 1234 $(|) SSL: +1453
      msg $3 User/Identd: $2
      msg $3 Password: %password
      msg $3 Quickconnect: /server -m  freebnc.bnc4you.xyz:1234 $2/liberachat: $+ %password
      msg $3 Webinterface:  http://freebnc.bnc4you.xyz:1234 SSL: https://freebnc.bnc4you.xyz:1453
      msg $3 Please make sure you SAVE this information!
      msg #bnc4you.debug Done. Bouncer $2 added. $(|) Bouncer %slots $+ /100
      inc %slots
      msg *send_raw server $2 liberachat join #bnc4you
    }
    else { msg $chan $1 <IDENT> <NICK> }
    /password.key
  }
  if ($1 == -addvhost) {
    if ($2) {
      writeini servicelist.ini Vhosts $address($2,2) VHOST
      else { notice $nick $1 <VHOST> }
    }
  }
  if ($1 == -delznc) {
    if ($2) {
      remini servicelist.ini Accepted $address($2,2)
      msg *controlpanel deluser $2
      msg $chan Done. $2 removed.
    }
    else { notice $nick $1 <IDENT> }
  }
  if ($1 == -resetpass) {
    if ($2) && ($3) {
      /password.key
      msg *controlpanel set password $2 %password
      msg $3 Hello $3 $+ , your password changed. #bnc4you
      msg $3 IP: freebnc.bnc4you.xyz
      msg $3 Port: 1234 $(|) SSL: +1453
      msg $3 User/Identd: $2
      msg $3 Password: %password
      msg $3 Quickconnect: /server -m freebnc.bnc4you.xyz:1234 $2/libera: $+ %password
      msg $3 Webinterface: http://freebnc.bnc4you.xyz:1234 SSL: https://freebnc.bnc4you.xyz:1453 
      msg $3 Please make sure you SAVE this information!
      msg $3  Please read our RULES https://pastebin.com/raw/eDaeLZhn
      msg #bnc4you.debug [BNC4YOU] $2 password changed to sended $3 done. [BNC4YOU]
    }
    else { msg $chan $1 <IDENT> <NICK> }
    /password.key
  }
  if ($1 == -suspend) {
    if ($2) && ($3-) {
      msg *blockuser block $2
      msg $chan ?2ZNC? 4SUSPENDED1 ? username: $2 ? SUSPENDED by: $nick ? REASON: idle forbidden.
    }
    if ($2) && (!$3-) {
      msg *blockuser block $2
      msg $chan ?2ZNC? 4SUSPENDED1 ? username: $2 ? SUSPENDED by: $nick ? REASON: idle forbidden.
    }
    else { notice $nick $1 <IDENT> <REASON> }
  }
  if ($1 == -unsuspend) {
    if ($2) && ($3) {
      msg *blockuser unblock $2
      msg $chan ?2ZNC? 8UNSUSPENDED1 ? username: $2 ? UNSUSPENDED by: $nick ?
    }
    if ($3- == $null) {
      msg *blockuser unblock $2
      msg $chan ?2ZNC? 8UNSUSPENDED1 ? username: $2 ? UNSUSPENDED by: $nick ?
    }
    else { notice $nick $1 <NICK> }
  }
  if ($1 == -unreject) {
    if ($2) {
      remini servicelist.ini Rejects $address($2,2)
      .ban -k $chan $2 2 $3
    }
    else { notice $nick $1 <NICK> }
  }
  halt
}
On *:TEXT:*:?: { if (($wildsite == *!*@znc.in) && (*does not exist!* iswm $2-)) { msg #bnc4you.debug 1[4ZNC1] $1- } }
