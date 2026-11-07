// This macro substitutes command-line-interface for "*.exe".
// Sample work-flow:
// = menu [File][Open] "D:\Img16Prc\DCM\010_5110.DCM"
// = menu [Plugins][Macros][Install] "D:\Img16Prc\Img16Prc.ljm"
// = menu [Plugins][Macros][Img16Prc] 
// = ensure about window's title ~"Process for 010_5210.DCM", label ~"input image 3200x3200 ..."
// = select [The mode] (default is file name's prefix)
// = enable|disable [anti-scatter] (as suitable for actual image)
// = adjust sliders [Brightness|Contrast|Sharpness] ("8=default")
// = button [Ok] produces ~"$3200x3200_10_1888.raw"
// = compare the result against state-of-art ~"010_5210std.DCM" (when available)

macro "Img16Prc" { // begin of the macro 
  // -- checkoops
  requires( "1.53k" ); // refer "https://imagej.nih.gov/ij/download.html", "Windows"
  list = getList( "image.titles" ); if (list.length<1)
    exit( "It applies to active image (16bit preferably).\nBut here is no one." );
  nam_cur = getInfo( "image.filename" );
  if (startsWith(nam_cur,"$") || indexOf(nam_cur,"std.")>0)
    exit( "It applies once.\nBut "+nam_cur+" seemingly is processed." );
  bdh = bitDepth(); if (bdh!=16 && bdh!=8) 
    exit( "It requires 16bit (8bit at least).\nBut "+nam_cur+" is "+bitDepth()+"bit" );
  W=getWidth(); H=getHeight();
  if (W<200 || W>8000 || H<200 || H>8000)
    exit( "It requires frame's dimensions 200..8000pix.\nBut "+nam_cur+" is "+W+"x"+H );
  os = getInfo( "os.name" );
  if (indexOf(os,"Linux")>= 0) {
    nam_exe = File.getDirectory( getInfo("macro.filepath") )+"Img16Prc";
    if (!File.exists( nam_exe )) nam_exe = "~/Img16Prc/Img16Prc";
    if (!File.exists( nam_exe )) nam_exe = "/mnt/D/Img16Prc/Img16Prc";
    if (!File.exists( nam_exe )) nam_exe = "/mnt/E/Img16Prc/Img16Prc";
  } else {
    nam_exe = File.getDirectory( getInfo("macro.filepath") )+"Img16Prc.exe";
    if (!File.exists( nam_exe )) nam_exe = "C:\\Img16Prc\\Img16Prc.exe";
    if (!File.exists( nam_exe )) nam_exe = "D:\\Img16Prc\\Img16Prc.exe";
    if (!File.exists( nam_exe )) nam_exe = "E:\\Img16Prc\\Img16Prc.exe";
    if (!File.exists( nam_exe )) nam_exe = File.openDialog( "Locate Img16Prc.exe" );
  };
  //-- dialog
  Dialog.create( "execute Img16Prc for "+nam_cur );
  if (bdh!=16)
    Dialog.addMessage( "This process is for ~> 10bit. "+bdh+"bit output is void." );
  getStatistics( stt_n, stt_av, stt_mn, stt_mx ); 
  Dialog.addMessage( "Input image "+W+"x"+H+"(gamut "+stt_mn+"<"+stt_av+"<"+stt_mx+")");
  choices = newArray(
    "070 ndt Pipe +wires",
    "071 ndt Phantom +slits",
    "090 mri Lims fastSE",
    "100 infrared MS_KinectAzure x1024",
    "102 infrared 324x256",
    "200 Optic barcode 8-bit" );
  cho_pfx = substring( nam_cur, 0, 3 );
  for (i=0;i<choices.length;i++) // -- stop at the first match
    if (indexOf(choices[i],cho_pfx)>-1) { cho_pfx = choices[i]; break; };
  Dialog.addChoice( "The mode", choices, cho_pfx  );
  Dialog.addCheckbox( "anti-scatter (bucky)", true );
  Dialog.addSlider( "Brightness", 1, 15, 8 );
  Dialog.addSlider( "Contrast",   1, 15, 8 );
  Dialog.addSlider( "Sharpness",  1, 15, 8 );
  Dialog.show();
  mod = substring( Dialog.getChoice(), 0, 3 ); // -- processing mode ~"mmm"
  if (mod.startsWith("0")) mod = substring(mod,1,lengthOf(mod));
  adj = 0; if (Dialog.getCheckbox()) adj = adj|(1<<12); // ????
  adj = adj|(256*Dialog.getNumber());
  adj = adj|(16*Dialog.getNumber());
  adj = adj|Dialog.getNumber(); // -- adjustments ~"1888"
  adj = String.pad( toHex(adj), 4 ); 
  nam = "$"+W+"x"+H; // -- temp filenames ~"$3200x3200_q"
  nam_inp = nam+".raw"; // ~"xyz.raw"
  nam_out = nam+"_"+mod+"_"+adj+".raw"; // ~"$3200x3200_q_NN_1888.raw"

  //-- execution
  setBatchMode( true );
  print( "\\Clear" );  print( "- adjustments' code "+adj+" // for "+nam_cur );
  print( "- "+nam_inp+" // duplicate current image" );
  run( "Duplicate...", "title="+nam_inp ); selectWindow( nam_inp );
  print( "- IntelByteOrder // in Edit>Options>InputOutput>Save" );
  if (bdh==8) { // -- aux convesion 8bit=>16
    run( "16-bit" ); call( "ij.ImagePlus.setDefault16bitRange", 14 ); run( "Apply LUT" ); };
  saveSettings(); run( "Input/Output...", "save" );
  save( nam_inp ); restoreSettings(); close();
  print( "- waiting for "+nam_out+"... // it takes 0.1..5s" );
  exec( nam_exe, W, H, nam_inp, mod, adj, "00" ); // flg 2?? requests AVX2
  setBatchMode( false );

  //-- open the output<s> (with adhoc contrast)
  // print( "- open "+nam_out+" // "+dsp_min+".."+dsp_max );
  fmt_sgn = "Signed"; if (mod>89) fmt_sgn = "Unsigned"; // if a mode produces cardinals
  run( "Raw...", "open="+nam_out+" image=[16-bit "+fmt_sgn+"] width="+W+" height="+H+" little-endian" );
  print( "- delete //"+nam_inp+","+nam_out ); File.delete( nam_inp ); File.delete( nam_out );
  if (mod>89) run( "Enhance Contrast", "saturated=0.22" );
  else setMinAndMax( 0, 16383 );
  if (bdh==8) { run( "Apply LUT" ); run("8-bit"); }; // -- aux convesion 16bit=>8
  if (isOpen( "Log" )) { selectWindow( "Log" ); run( "Close" );   }
} // end of macro "MGePrcs"
