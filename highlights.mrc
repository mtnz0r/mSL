on *:text:*:#:{
  if $istok($strip($1-),$me,32) {
    if ($active != #) echo -ta 7(HIGHLIGHTS)1  $+([,$fulldate,]) $+(14<7,$network,/,$chan,14>) $+(14<9,$nick,14>) $1-
    if (!$window(@HightLight)) window -kn @HightLight
    echo @HightLight $+([,$fulldate,]) $+(14<7,$network,/,$chan,14>) $+(14<9,$nick,14>) $1-
  }
}
