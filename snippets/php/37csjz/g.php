<?php
header("Content-type: text/javascript");

$account = '';

function myTrim($str)
{
	$str = trim($str);
	$str=strip_tags($str,"");
	$str=preg_replace("{\t}","",$str);
	$str=preg_replace("{\r\n}","",$str);
	$str=preg_replace("{\r}","",$str);
	$str=preg_replace("{\n}","",$str);
	$str=preg_replace("{ }","",$str);
	return $str;
}

$file = fopen("a.txt","r");

if(!feof($file))
{

	$account = myTrim(fgets($file));
	
	echo '$("#account").val("' . $account . '")';
	
	if($account == '')
	{
		echo ';$("form").hide()';
		echo ';$("body").append("<h1>has no acc left</h1>")';
	}
	
}
  
fclose($file);
?>