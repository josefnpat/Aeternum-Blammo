#!/usr/bin/php5
<?php
$bin = "/usr/bin/love";
$files = explode("\n",rtrim(`ldd $bin`));

$skip_cases = array("libGL.so","tls.so","glcore.so");//libX
$skip_starts = array();//"/lib/");
$valid = array();

foreach($files as $line){
  preg_match("@(\s){1,}(.*){1}\ =>\ (.*){1}\ \((.*){1}\)@",$line,$matches);
  if(!empty($matches)){
    $skip = false;
    foreach($skip_cases as $c){ // Contains
      if(strstr($matches[2],$c)){
        $skip = true;
        break;
      }
    }
    foreach($skip_starts as $s){ //Starts with
      if(substr($matches[3],0,strlen($s))==$s){
        $skip = true;
        break;
      }
    }
    if(!$matches[3]){ // Has file to link to
      $skip = true;
    }
    if(!$skip){
      $valid[] = $matches[3];
    }
  }
}

$arc = rtrim(`uname -m`);
passthru("mkdir love_$arc");
passthru("cp $bin love_$arc/");
foreach($valid as $file){
  passthru("cp $file love_$arc/");
}
passthru("du -h love_$arc/");
