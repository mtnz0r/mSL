alias -l from_network { return EFNet }
alias -l from_channel { return #arv1 }
alias -l output_network { return DALNet }
alias -l output_channel { return #arv2 }

alias debug_output { 
  if (!$output_network) && (!$output_channel) || (!$from_network) || (!$from_channel) { return }

  var %cid = $find_cid($output_network)
  if (!%cid) { return }

  scid -t1 %cid

  var %raw = $strip($1-)
  var %msg = $mid($gettok(%raw,5-,32),2-)
  var %chan = $gettok(%raw,4,32)

  if (%msg == $null) && ($network !== $output_network) && ($status !== connected) && ($me !ison $output_channel) && (%chan !== $from_channel) && (%msg == TIMEOUTCHECK) { return }

  if ($left(%msg,5) == [PRE]) { var %msg = Hello $gettok(%msg,3-,32) }

  if (*123* iswm %msg) || (*321* iswm %msg) { msg $output_channel %msg | return }

  editbox $output_channel %msg

  halt
}

alias start_debug { 
  if ($debug) || (!$output_network) && (!$output_channel) || (!$from_network) || (!$from_channel) { return }
  debug -ni @debuging $!debug_output
}

alias stop_debug {
  if (!$debug) { return }
  debug -c off @debuging 
}

alias -l find_cid {
  var %t = $scon(0)

  if (!$1) || (!%t) { return 0 }

  while (%t) {
    var %network = $scon(%t).network
    var %cid = $scon(%t).cid
    if ($1 == %network) { return %cid }
    dec %t
  }

  return 0
}
