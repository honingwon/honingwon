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
	
	if($account == '')
	{
		echo ';$("body").append("<h1>has no acc left</h1>")';
	}
	else
	{
		echo "$.ajax({";
		echo "	url:'login.php?action=loginGame',";
		echo "	data:{login_account:'".$account."',password:123456},";
		echo "	type: 'POST',";
		echo "	dataType: 'text',";
		echo "	success:function(json) {";
		echo "	    console.log(json);";
		echo "		if(json =='true'){";
		echo "			window.location.href='game_login.php?server=S1';";
		echo "		}";
		echo "	}";
		echo "});";
	}
	
}
  
fclose($file);
?>