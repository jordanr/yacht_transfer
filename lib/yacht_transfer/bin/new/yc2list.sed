#n

s/.*YACHT ID\#\([0-9]\+\)\".*/ID~\1/p
s/.*solid;\">\([A-Z '\'']\+\)<.*/MANUFACTURER~\1/p
s/.*solid;\">\([0-9]\+\).*/LENGTH~\1/p
