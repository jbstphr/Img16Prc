#!/bin/sh
# -- process the DataSeries by specific TBCS
# -- wildcards here shall be quoted (by standard quote_chars) 
if [ -n "$1" ]; then
  TBCS="$1"
else
  TBCS=1888
fi
Prog=./Img16Prc
# -- MRI low-field ankle spinecho
"$Prog" 256 256 "x0256MRI/?o.raw" 90 %TBCS% 00
# -- Infrared cheap surveilance 
"$Prog" 324 256 "x0324x0256ifr/?????.raw" 102 "$TBCS" 00
# -- Infrared Azure Kinects
"$Prog" 1024 1024 "x1024ifr/????.raw" 100 "$TBCS" 00
# -- OpticCamera barcode
"$Prog" 1280 960 "x1280x0960bar/???.raw" 200 %TBCS% 00
# -- NDT iron pipe (thin wires inside)
"$Prog" 1472 2172 "x1472x2172ndt/2050.raw" 70 %TBCS% 00
# -- NDT phantom+slits
"$Prog" 1472 2172 "x1472x2172ndt/3003.raw" 71 %TBCS% 00
