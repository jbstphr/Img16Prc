Sample data-series
  for invocation of "TestUtil<.exe>"
  via ImageJ-macro "TestUtil.ijm".

The names are mmmWWWWxHHHHa.DCM, where:
  = mmm - suggested "image process mode number" (e.g. "001","020","100");
  = WWWWxHHHH - dimension;
  = suffixes ~"a,b" denote ~different patients, different slices;
  = suffix "std" denotes standard sample process (when available).

The targets are:
  = 000_ - rational sharpness & contrast of dental panorama;
  = 003_ - rational sharpness & contrast of dental cephaloscopy with panoramic detector;
  = 005_,006_ - rational sharpness & contrast of dental intraoral images;
  = ... - reproduce (perhaps slightly imrove) accompanied "state-of-art".

Check-box "anti-scatter-grid":
  = 005_,006_ 
    enable (unless one needs very high speed).
  = 10..69:
    - enable for
      ??_??5? - rather read-out vert noise,
      ??_??6?,??_??7? - anti-scatter,
      41???????? - lungs,anti-scatter;
    - disable otherwise.
  = ignored for other modes.

"Ribs detection" [RD] Enabled=1 is set in "41*.ini".
Either mode "040 med Fluoro", "040 med Fluoro-Ribs" are applicable to the same source
images "040...","041...".

"Collimator detection" [CO] Enable=1 is set in "?1*.ini". Respective process-modes in
the dialog's list-box have suffix "...-Collimator".

"Air Estimation" [AE] Enable=1 is set in the modes, where background area is large
typically.

