#!/bin/bash
from=$1
to=$2

sed -f ${from}2std.sed | ./inline.pl | sed -f std2${to}.sed

exit
