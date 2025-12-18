RAW 311:*:{
  echo -a 
  echo -a  :::93:: [ $2 93] :::::
  echo -a  — 93Realname: $mid($gettok($2-,2,42),2,99)
  echo -a  — 93Address: $3 $+ @ $+ $4 $+ 
  halt
}
raw 319:*: {
  haltdef
  var %x = 1
  while (%x <= $numtok($3-,32)) {
    inc %x 1
  }
  echo -a  — 93Channels ( $+ $numtok($3-,32) $+ 93): $3-
}
RAW 307:*:{
  echo -a  — $2 93has identified this nick!
  halt
}
RAW 330:*:{
  echo -a  — 93Authed as $3
  halt
}
RAW 335:*:{
  echo -a  — $2 93is a Bot 93on $network
  halt
}
RAW 379:*:{
  echo -a  — $2 93 $+ $3 $4 $5  $+ $6
  halt
}
raw 276:*: {
  haltdef
  echo -a  — $2 93 $+ $3 $4 $5 $6  $+ $7
}
raw 344:*: {
  haltdef
  echo -a  — $2 93is connecting from $7 $8
}
raw 338:*: {
  haltdef
  echo -a  — $2 93is actually on host $3 
}
raw 275:*: {
  haltdef
  echo -a  — $2 93 $+ $3 $4 $5  $+ Secure Connection $8
}
raw 320:*: {
  haltdef
  echo -a  — $2 93 $+ $3 $4  $+ $5 $6 $7  $+ $8 $9 $10
}
RAW 378:*:{
  echo -a  — $1 93 $+ $3 $4 $5  $+ $6 ( $+ $7 $+ )
  halt
}
RAW 671:*:{
  echo -a  — $2 93is $4 $5  $+ $6 $7
  halt
}
RAW 313:*:{
  echo -a  — $2 93is an 43IRC Οperator
  halt
}
RAW 312:*:{
  echo -a  — 93Server: $3 ( $+ $4- $+ ) 
  halt 
}
RAW 301:*:{ 
  echo -a  — 93Away: $3- 
  halt 
}
RAW 317:*:{
  echo -a  — 93Idle for $duration($3) 93| Signed on $asctime($4) 93( $+ $duration($calc($ctime - $4 )) 93ago)
  halt
}
RAW 318:*:{
  echo -a  :::93:: END of WHOIS ::::: 
  echo -a 
  halt
}

alias whois { whois $$1 $$1 }
