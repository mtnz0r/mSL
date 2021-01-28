on *:INPUT:#:{
  if ($left($1,1) != /) {
    haltdef
    var %lines = $1-
    if (%lines == $null) { %lines  }
    if (!$window(@Pastedelay)) { window -lh @Pastedelay }
    if (($target ischan) && (c isincs $gettok($chan($active).mode,1,32))) { 
      %lines = $strip(%lines,c) 
    }
    if ($window(@Pastedelay)) { aline @Pastedelay %lines }
    .timerpastedelay 1 0 start.pastedelay
    halt
    if ($me isop #) { .msg # $1- | echo -tm $chan 02(@01 $+ $me $+ 02)01 $1- | haltdef }
    if ($me ishop #) { .msg # $1- | echo -tm $chan 02(%01 $+ $me $+ 02)01 $1- | haltdef }
    if ($me isvoice #) { .msg # $1- | echo -tm $chan 02(+01 $+ $me $+ 02)01 $1- | haltdef }
    if ($me isreg #) { .msg # $1- | echo -tm $chan 02(01 $+ $me $+ 02)01 $1- | haltdef }
    if ($inpaste) && ($istok(channel query chat,$window($active).type,32)) {
    }
  }
}
 
alias -l start.pastedelay {
  var %PDWindow = @Pastedelay, %pastedelay
  if (($line(%PDWindow,0) > 3) && (!$$input(Paste $line(%PDWindow,0) lines to $active $+ ? $crlf $pdpreview,iyw,Confirm Paste Delay))) {
    var %play = $$input(Play $line(%PDWindow,0) lines to $active $+ ? $crlf $pdpreview,iyw,Confirm Playback text))
    $iif((%play),!.play -b $active 3000)
    window -c @Pastedelay
    return
  }
  pastedelay $active 1 %pastedelay
}
 
alias -l pdpreview {
  return $crlf $line(@Pastedelay,1) $crlf $line(@Pastedelay,2) $crlf $line(@Pastedelay,3) $crlf $line(@Pastedelay,4)
}
