on *:text:!uptime:#:{ set %uptimeplz $chan | msg *status uptime }
on *:text:Running for *:?:if (%uptimeplz) && ($nick == *status) { msg %uptimeplz BNC Uptime: $1- | unset %uptimeplz }
