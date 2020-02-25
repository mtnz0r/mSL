on ^*:TEXT:$($+(*,$me,*)):*: { $iif($window(@Highlights),$null,window -n @Highlights)
  echo 3 -ml @Highlights $+([,$fulldate,]) $+(14<7,$network,/,$chan,14>) $+(14<9,$nick,14>) $1-
}

by Seb.
