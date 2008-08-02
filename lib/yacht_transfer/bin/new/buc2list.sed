#n

s/.*seq=\([0-9]\+\).*/ID~\1/p
s/.*<b>\(.*\)<\/b>.*/MANUFACTURER~\1/p
s/.*>\([0-9'"]\+\)<\/FONT>.*/LENGTH~\1/p
