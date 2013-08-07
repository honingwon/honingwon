<?php
//写入帐号
$account = $_GET["account"];
echo "account:".$account."<br>";

if($account == "")exit();

$content = file_get_contents("a.txt");
echo "content:".file_get_contents("a.txt")."<br>";
echo "find:".stristr($content,$account)."<br>";

if(stristr($content,$account) != "")
{
	echo "此帐号已存";
	$file = fopen("log.txt","a");
	fwrite($file,$account . "\r\n");
	fclose($file);
}
else
{
	$file = fopen("a.txt","a");
	fwrite($file,$account . "\r\n");
	fclose($file);
}


?>