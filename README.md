# Img16Prc
16-bit Image-Process (for Windows, Ubuntu) 
The directory for application-debug-work-flow

= The actors:

  - Img16Prc.so|.dll - processing library
  - Img16Prc<.exe> - the files' iterator (executes Img16Prc.so|.dll)
  - Img16Prc.ljm - ImageJ macro (executes Img16Prc<.exe> for single image)
  
= Images' sub-directories for the iterator:

  xWWWWxHHHHsfx/*

= Images' sub-directories imageJ:

  BMP/*, DCM/*, TIFF/*

= DataSeries' viewer:

  - Img16DatSer.exe (should work smooth under WinE in Ubuntu)
  - Img16DatSer.ini (transient initialization profile; could be deleted at any moment ~without_a_harm) 
  - Dedicated documentation "Img16DatSer.pdf".

= Service batch files:

  - _clean.sh|.bat - delete processing results in xWWWWxHHHHsfx/*
  - _process.sh|.bat - process all images in xWWWWxHHHHsfx/* with specified TagBrightnessContrastSharpness; by default "TBCS=0888"

= The documentation:

 - _ReadMe_Img16Prc.pdf - systematic
 - _ReadMe_Img16Prc.txt - adhoc work-flow-references
  
