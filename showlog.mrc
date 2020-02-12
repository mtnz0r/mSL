alias showlog { logview $qt($$sfile($regsubex($window($active).logfile,/(?=[^\\]+$)\d+/g,*),Choose a log,Show Log)) } ; by Raccoon
