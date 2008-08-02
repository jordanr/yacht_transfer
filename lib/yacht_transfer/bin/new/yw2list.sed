#n

s/<input.* value=\"\([0-9]\+\)\">.*/ID~\1/p
s/\t\t\([^<]*\)<\/a>/MANUFACTURER~\1/p
s/.*nowrap>\([0-9]\+\).*/LENGTH~\1/p
