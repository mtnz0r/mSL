on *:text:*:#:{
  if $istok($strip($1-),$me,32) {
    if ($active != #) echo -ta 7(INFO)1 HIGHLIGHTS @ # < $+ $nick $+ > $1-
    if (!$window(@HightLight)) window -kn @HightLight
    echo @HightLight ( $+ $fulldate $+ ) [ $+ # $+ ] < $+ $nick $+ > $1-
  }
}
