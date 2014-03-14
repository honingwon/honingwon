<?php
	require_once(dirname(__FILE__).'/../view/common.php');
	if(isset($_GET["en"]))
	{
		$en_language = $_GET["en"];
		$path_php = "";
		$path_js  = "";
		switch($en_language)
		{
			case 1:
				$path_php = "China/view.php";
				$path_js = "China/language.js";
				
				$r_php = file_get_contents($path_php);
				$str_php=  htmlspecialchars($r_php);
				file_put_contents('Language/view.php','<?php '.$str_php.' ?>');
				
				$r_js = file_get_contents($path_js);
				$str_js=  htmlspecialchars($r_js,ENT_NOQUOTES);
				file_put_contents('Language/language.js',$str_js);
				break;
			case 2:
				$path_php = "Japan/view.php";
				$path_js = "Japan/language.js";
				
				$r_php = file_get_contents($path_php);
				$str_php=  htmlspecialchars($r_php);
				file_put_contents('Language/view.php','<?php '.$str_php.' ?>');
				
				$r_js = file_get_contents($path_js);
				$str_js=  htmlspecialchars($r_js,ENT_NOQUOTES);
				file_put_contents('Language/language.js',$str_js);
				break;
		}
	}
	echo '<SCRIPT>top.location="'.MANAGER_PATH.'/view/default/index.php";</SCRIPT>';
?>